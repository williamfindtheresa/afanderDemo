//
//  WwHalfExchangeViewController.m
//  prizeClaw
//


#import "WwHalfExchangeViewController.h"
#import "WwWawaExchangeViewController.h"

@interface WwHalfExchangeViewController ()

@property (weak, nonatomic) IBOutlet UIView *bottomV;

@property (nonatomic, strong) WwWawaExchangeViewController * exchangeVC;

@end

@implementation WwHalfExchangeViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.exchangeVC = [WwWawaExchangeViewController createWithInitData:nil];
    // TODO
//    self.exchangeVC.DVL_InitData = self.DVL_InitData;
    self.exchangeVC.view.frame = self.bottomV.bounds;
    [self.bottomV addSubview:self.exchangeVC.view];
    self.navigationController.view.backgroundColor = [UIColor clearColor];
    
    // Do any additional setup after loading the view.
}

#pragma mark - Action
- (IBAction)closeButton:(id)sender {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
