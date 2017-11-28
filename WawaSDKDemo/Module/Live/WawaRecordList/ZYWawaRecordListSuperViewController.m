//
//  ZYWawaRecordListSuperViewController.m
//  WawaSDKDemo
//
//

#import "ZYWawaRecordListSuperViewController.h"

@interface ZYWawaRecordListSuperViewController ()

@end

@implementation ZYWawaRecordListSuperViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

- (void)setupUI {
    self.navigationController.navigationBarHidden = NO;
    self.title = @"娃娃详情";
    self.view.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.wawaRecordListVc.view];
    self.wawaRecordListVc.view.frame = self.view.bounds;
}

- (ZYWawaRecordListTableViewController *)wawaRecordListVc {
    if (!_wawaRecordListVc) {
        _wawaRecordListVc = [[ZYWawaRecordListTableViewController alloc] init];
    }
    return _wawaRecordListVc;
}

@end
