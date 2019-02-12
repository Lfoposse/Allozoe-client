

#import "STPAddSourceViewController.h"

@interface STPAddSourceViewController ()

@end

@implementation STPAddSourceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationItem.leftBarButtonItem setTarget:self];
    [self.navigationItem.leftBarButtonItem setAction:@selector(cancelClicked:)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)cancelClicked:(id)sender {
    [self.srcDelegate addCardViewControllerDidCancel:self];
}

-(void)nextPressed:(id)sender {
    
    //TODO hackedihack
    STPPaymentCardTextField* paymentCell = [((UITableView*)self.view.subviews.firstObject) cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]].subviews.firstObject.subviews.firstObject;
    
    STPAPIClient *apiClient = [[STPAPIClient alloc] initWithConfiguration:[STPPaymentConfiguration sharedConfiguration]];
    
    STPCardParams *cardParams = paymentCell.cardParams;
    //cardParams.address = self.addressViewModel.address;
    cardParams.currency = self.managedAccountCurrency;
    STPSourceParams *sourceParams = [STPSourceParams cardParamsWithCard:cardParams];
    if (cardParams) {
        [apiClient createSourceWithParams:sourceParams completion:^(STPSource *source, NSError *tokenError) {

            
            NSString *str = @"";
            NSString* expMonth = [NSString stringWithFormat:@"%lu", cardParams.expMonth];
            NSString* expYear = [NSString stringWithFormat:@"%lu", cardParams.expYear];
            str = [str stringByAppendingString:cardParams.number];
            str = [str stringByAppendingString:@"/"];
            str = [str stringByAppendingString:expMonth];
            str = [str stringByAppendingString:@"/"];
            str = [str stringByAppendingString:expYear];
            str = [str stringByAppendingString:@"/"];
            str = [str stringByAppendingString:cardParams.cvc];
                [self.srcDelegate addCardViewController:self didCreateSource:str completion:^(NSError * _Nullable error) {
                    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                        if (error) {
                            //[self handleCardTokenError:error];
                        }
                        else {
                            //self.loading = NO;
                        }
                    }];
                }];
           
        }];
    }
}

/*
 #pragma mark - Navigation
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end

