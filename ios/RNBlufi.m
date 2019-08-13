
#import "React/RCTBridgeModule.h"
#import "React/RCTEventEmitter.h"

@interface RCT_EXTERN_MODULE(RNBluFi, RCTEventEmitter)
RCT_EXTERN_METHOD(setup)
RCT_EXTERN_METHOD(inputData:(NSArray *)data)
RCT_EXTERN_METHOD(negotiate: (RCTResponseSenderBlock)callback)
RCT_EXTERN_METHOD(negotiate: (RCTPromiseResolveBlock)resolve
                  rejecter: (RCTPromiseRejectBlock)reject)

RCT_EXTERN_METHOD(writeData: (NSArray *)data
                  timeout: (NSInteger)timeout_sec
                  resolver: (RCTPromiseResolveBlock)resolve
                  rejecter: (RCTPromiseRejectBlock)reject)
@end
