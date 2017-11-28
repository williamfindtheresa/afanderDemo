//
//  WwWawaRecordListSuperViewController.m
//  F_Sky
//


#import "WwWawaRecordListSuperViewController.h"

@interface WwWawaRecordListSuperViewController ()

@end

@implementation WwWawaRecordListSuperViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

- (void)setupUI {
    self.view.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.wawaRecordListVc.view];
}

- (WwWawaRecordListTableViewController *)wawaRecordListVc {
    if (!_wawaRecordListVc) {
        _wawaRecordListVc = [[WwWawaRecordListTableViewController alloc] init];
        _wawaRecordListVc.view.frame = self.view.bounds;
    }
    return _wawaRecordListVc;
}

@end
