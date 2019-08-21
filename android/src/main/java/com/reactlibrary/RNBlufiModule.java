
package com.reactlibrary;

import androidx.annotation.Nullable;

import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.Callback;

import com.espressif.blufi.BlufiClient;
import com.espressif.blufi.BlufiCallback;

import com.facebook.react.bridge.WritableMap;
import com.facebook.react.modules.core.DeviceEventManagerModule;
import com.facebook.react.uimanager.IllegalViewOperationException;

public class RNBluFiModule extends ReactContextBaseJavaModule {

    private final ReactApplicationContext reactContext;
    private static final String E_LAYOUT_ERROR = "E_LAYOUT_ERROR";
    private BlufiClient mBluFi = null;
    private Object mNegotiateLock;
    private boolean isNegotiated = false;
    private Object mWriteLock;
    private byte[] receivedData;


    public RNBluFiModule(ReactApplicationContext reactContext) {
        super(reactContext);
        this.reactContext = reactContext;
    }

    @Override
    public String getName() {
        return "RNBluFi";
    }

    @ReactMethod
    public void setup() {
        if (mBluFi != null) {
            mBluFi.close();
        }
        mNegotiateLock = new Object();
        mWriteLock = new Object();
        mBluFi = new BlufiClient(new BlufiCallbackMain(this));
    }

    @ReactMethod
    public void writeData(final byte[] data, final int timeout_sec, final Promise promise) {
        Thread thread = new Thread() {
            @Override
            public void run() {
                synchronized (mNegotiateLock) {
                    try {
                        mBluFi.postCustomData(data);
                        if (timeout_sec > 0) {
                            mWriteLock.wait(timeout_sec*1000);
                        }

                        promise.resolve(receivedData);
                    } catch (Exception e) {
                        promise.reject(e);
                    }
                }
            }
        };
        thread.start();
    }

    @ReactMethod
    public void writeDone() {
        mBluFi.writeDone();
    }

    @ReactMethod
    public void inputData(byte[] data) {
        mBluFi.inputData(data);
    }

    @ReactMethod
    public void negotiate(final Promise promise) {
        Thread thread = new Thread() {
            @Override
            public void run() {
                synchronized (mNegotiateLock) {
                    try {
                        mBluFi.negotiateSecurity();
                        mNegotiateLock.wait(30*1000);
                        if (!isNegotiated) {
                            throw new Exception("Failed to negotiate with BluFi device");
                        }
                        promise.resolve(null);
                    } catch (Exception e) {
                        promise.reject(e);
                    }
                }
            }
        };

        thread.start();
    }

    public void negotiateDone(boolean status) {
        isNegotiated = status;
        mNegotiateLock.notifyAll();
    }
    public void receiveData(byte[] data) {
        this.receivedData = data;
        mWriteLock.notifyAll();
    }

    public void sendEvent(String eventName,
                          @Nullable WritableMap params) {
        this.reactContext
                .getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class)
                .emit(eventName, params);
    }


    private class BlufiCallbackMain extends BlufiCallback {

        private final RNBluFiModule rnBluFi;

        public BlufiCallbackMain(RNBluFiModule rnBluFi) {
            this.rnBluFi = rnBluFi;
        }

        @Override
        public void onReceiveCustomData(BlufiClient client, int status, byte[] data) {
            this.rnBluFi.receiveData(data);
        }

        @Override
        public void onError(BlufiClient client, int errCode) {
            super.onError(client, errCode);
        }

        @Override
        public void onNegotiateSecurityResult(BlufiClient client, int status) {
            if (status == BlufiCallback.STATUS_SUCCESS) {
                this.rnBluFi.negotiateDone(true);
                return;
            }
            this.rnBluFi.negotiateDone(false);
        }

        @Override
        public void onBluFiData(BlufiClient client, byte[] data) {
            WritableMap params = Arguments.createMap();
            this.rnBluFi.sendEvent("onData", null);
        }
    }

}