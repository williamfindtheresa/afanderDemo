//
//  WwWawaParticularsSuperViewController.m
//  F_Sky
//


#import "WwWawaParticularsSuperViewController.h"
#import "WwWawaParticularsTableViewController.h"

@interface WwWawaParticularsSuperViewController ()
@property (nonatomic, strong) WwWawaParticularsTableViewController *wawaParticularsVC;
@end

@implementation WwWawaParticularsSuperViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

- (void)setupUI {
    [self.view addSubview:self.wawaParticularsVC.view];
    self.view.backgroundColor = [UIColor clearColor];
}

- (WwWawaParticularsTableViewController *)wawaParticularsVC {
    if (!_wawaParticularsVC) {
        _wawaParticularsVC = [[WwWawaParticularsTableViewController alloc] init];
        _wawaParticularsVC.view.frame = self.view.bounds;
    }
    return _wawaParticularsVC;
}


@end
