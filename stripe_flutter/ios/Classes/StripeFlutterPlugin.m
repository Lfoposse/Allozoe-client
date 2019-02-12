#import "StripeFlutterPlugin.h"


#import <Stripe/Stripe.h>


@implementation StripeFlutterPlugin {
    FlutterResult flutterResult;
}
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    
    FlutterMethodChannel* channel = [FlutterMethodChannel methodChannelWithName:@"stripe_view" binaryMessenger:[registrar messenger]];
    
    StripeFlutterPlugin* instance = [[StripeFlutterPlugin alloc] init];
    [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    if ([@"addSource" isEqualToString:call.method]) {
        [self openStripeCardVC:result];
    }
    else if ([@"setPublishableKey" isEqualToString:call.method]) {
        [[STPPaymentConfiguration sharedConfiguration] setPublishableKey:call.arguments];
    }
    else {
        result(FlutterMethodNotImplemented);
    }
}

-(void)openStripeCardVC:(FlutterResult) result {
    flutterResult = result;
    
    STPAddSourceViewController* addSourceVC = [[STPAddSourceViewController alloc] init];
    addSourceVC.srcDelegate = self;
    
    UINavigationController* navigationController = [[UINavigationController alloc] initWithRootViewController:addSourceVC];
    [navigationController setModalPresentationStyle:UIModalPresentationFormSheet];
    
    UIViewController* controller = [[[UIApplication sharedApplication] keyWindow] rootViewController];
    [controller presentViewController:navigationController animated:true completion:nil];
}

- (void)addCardViewControllerDidCancel:(STPAddSourceViewController *)addCardViewController {
    [addCardViewController dismissViewControllerAnimated:true completion:nil];
}

- (void)addCardViewController:(STPAddSourceViewController *)addCardViewController
              didCreateSource:(NSString *)source
                   completion:(STPErrorBlock)completion {
    flutterResult(source);
    
    [addCardViewController dismissViewControllerAnimated:true completion:nil];
}

@end
