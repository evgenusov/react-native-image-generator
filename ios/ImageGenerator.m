#import <React/RCTBridgeModule.h>

@interface RCT_EXTERN_MODULE(ImageGenerator, NSObject)


RCT_EXTERN_METHOD(addLayer:(NSString)uri
                  withWidth:(float)width
                  withHeight:(float)height
                  withX:(float)x
                  withY:(float)y
                  withResolver:(RCTPromiseResolveBlock)resolve
                  withRejecter:(RCTPromiseRejectBlock)reject)


RCT_EXTERN_METHOD(save:(NSString)filename
                  withWidth:(float)width
                  withHeight:(float)height
                  withResolver:(RCTPromiseResolveBlock)resolve
                  withRejecter:(RCTPromiseRejectBlock)reject)

@end
