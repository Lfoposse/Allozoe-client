#import "FlutterPlugin.h"


@implementation FlutterPlugin {
    FlutterResult flutterResult;
}
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {

    FlutterMethodChannel* channel = [FlutterMethodChannel methodChannelWithName:@"stripe_payment" binaryMessenger:[registrar messenger]];

    FlutterPlugin* instance = [[FlutterPlugin alloc] init];
    [registrar addMethodCallDelegate:instance channel:channel];
}



@end
