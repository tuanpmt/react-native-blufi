
import { NativeModules, NativeEventEmitter } from 'react-native';

const { RNBluFi } = NativeModules;

RNBluFi.init = function(dataOutCallback) {
	const RNBluFiEvents = new NativeEventEmitter(RNBluFi);
  if (RNBluFi.subscription) {
    RNBluFi.subscription.remove();
  }
	RNBluFi.subscription = RNBluFiEvents.addListener('onData', data => {
		if (dataOutCallback) {
			dataOutCallback(data);
		}
	});
	RNBluFi.setup();
}
RNBluFi.SERVICE_UUID = '0000ffff-0000-1000-8000-00805f9b34fb';
RNBluFi.NOTIFY_CHARA_UUID = '0000ff02-0000-1000-8000-00805f9b34fb';
RNBluFi.WRITE_CHARA_UUID = '0000ff01-0000-1000-8000-00805f9b34fb';

if (!RNBluFi.writeDone) {
  RNBluFi.writeDone = () => {};
}
RNBluFi.write = function(data, timeout_sec) {
  return RNBluFi.writeData(data, timeout_sec ? timeout_sec : 0);
}

export default RNBluFi;
