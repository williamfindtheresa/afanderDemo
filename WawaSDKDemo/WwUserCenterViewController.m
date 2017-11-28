//
//  WwUserCenterViewController.m
//  F_Sky
//
//

#import <Foundation/Foundation.h>
#import "WwUserCenterViewController.h"
#import "WwGameRecordViewController.h"
#import "WwToyManageViewController.h"
#import "WwAddressViewController.h"


@interface WwUserCenterViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *loginBtn;
@end

@implementation WwUserCenterViewController

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
    }
    return self;
}


- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad {
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 30, ScreenWidth, ScreenHeight - 30) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"WwTableViewCell"];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.view addSubview:_tableView];
    
    _loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _loginBtn.frame = CGRectMake(ScreenWidth/2, ScreenHeight/2, 50, 30);
    [_loginBtn addTarget:self action:@selector(onLoginClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:_loginBtn];
    [self setTitle:@"个人中心"];
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.row == 0) {
        WwToyManageViewController *toyVC = [[WwToyManageViewController alloc] initWithNibName:nil bundle:nil];
        [self.navigationController pushViewController:toyVC animated:YES];
    }
    else if (indexPath.row == 1) {
        WwGameRecordViewController *recordVC = [[WwGameRecordViewController alloc] initWithNibName:nil bundle:nil];
        [self.navigationController pushViewController:recordVC animated:YES];
    }
    else if (indexPath.row == 2) {
        WwAddressViewController *recordVC = [[WwAddressViewController alloc] initWithNibName:nil bundle:nil];
        [self.navigationController pushViewController:recordVC animated:YES];
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WwTableViewCell"];
    if (indexPath.row == 0) {
        cell.textLabel.text = @"我的娃娃";
    }
    else if (indexPath.row == 1) {
        cell.textLabel.text = @"游戏记录";
    }
    else if (indexPath.row == 2) {
        cell.textLabel.text = @"收货地址";
    }
    return cell;
}

#pragma mark - Private Methods
- (void)onLoginClicked:(UIButton *)sender {
    if (sender == _loginBtn) {
        [[WwUserInfoManager UserInfoMgrInstance] loginUserWithCompleteHandler:^(int code, NSString *message) {
            
        }];
    }
}

@end
