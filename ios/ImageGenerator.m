#import <React/RCTBridgeModule.h>

@interface RCT_EXTERN_MODULE(ImageGenerator, NSObject)

RCT_EXTERN_METHOD(generate:(NSDictionary *)layers
                  withConfig: (NSDictionary *)config
                  withResolver:(RCTPromiseResolveBlock)resolve
                  withRejecter:(RCTPromiseRejectBlock)reject)

@end
