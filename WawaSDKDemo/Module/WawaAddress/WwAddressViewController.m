//
//  WwAddressViewController.m
//  WawaSDKDemo
//

#import "WwAddressViewController.h"
#import "WwAddressTableViewCell.h"
#import "WwNewAddressViewController.h"
#import "WwUserAddressDataModel.h"

@interface WwAddressViewController ()<UITableViewDataSource,UITableViewDelegate,CellButtonDelegate,UIAlertViewDelegate>
@property (nonatomic ,strong) UITableView * tableView; /** 列表视图*/
@property (nonatomic, strong) WwAddressModel * deleteM; /**< 删除,临时*/
@property (nonatomic, strong) WwUserAddressDataModel *dataModel;
@end

@implementation WwAddressViewController

- (void)dealloc {
    [self removeObserver];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = RGBCOLORV(0xfafafa);
    self.navigationItem.title = @"管理收货地址";
    self.navigationController.navigationBarHidden = NO;
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.left.equalTo(self.view);
        make.bottom.equalTo(self.view).with.offset(-50);
        make.right.equalTo(self.view);
    }];
    
    UIButton *addNewBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    addNewBtn.frame = CGRectMake((ScreenWidth-250)/2, ScreenHeight-50, 250, 40);
    addNewBtn.backgroundColor = RGBCOLORV(0xffda44);
    addNewBtn.layer.backgroundColor = RGBCOLORV(0xffda44).CGColor;
    addNewBtn.layer.cornerRadius = 19.5f;
    [addNewBtn setTintColor:RGBCOLORV(0x4c4c4c)];
    [addNewBtn setTitle:@"添加新地址" forState:UIControlStateNormal];
    [addNewBtn addTarget:self action:@selector(newBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:addNewBtn];
    [addNewBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@250);
        make.height.equalTo(@40);
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(self.view).with.offset(-10.f);
    }];
    [self addObserver];
    
    // 请求地址数据
    [self requestAddressList];
}

#pragma mark - View Life Cycle
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.navigationController.tabBarController) {
        UITabBarController *tabVC = self.navigationController.tabBarController;
        tabVC.tabBar.hidden = YES;
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (self.navigationController.tabBarController) {
        UITabBarController *tabVC = self.navigationController.tabBarController;
        tabVC.tabBar.hidden = NO;
    }
}

#pragma mark - Observer
- (void)removeObserver {
    [self.dataModel removeObserver:self forKeyPath:kWwDataModelFetchResult];
}

- (void)addObserver {
    [self.dataModel addObserver:self forKeyPath:kWwDataModelFetchResult options:NSKeyValueObservingOptionNew context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    if (object == self.dataModel && [keyPath isEqualToString:kWwDataModelFetchResult]) {
        [self.tableView reloadData];
    }
}


#pragma mark - Action
- (void)newBtnAction {
    WwNewAddressViewController *newAddressVC = [[WwNewAddressViewController alloc] init];
    newAddressVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:newAddressVC animated:YES];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataModel.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WwAddressTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kWwAddressTableViewCellIdentifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;  // 点击cell 不变色
    cell.addressLabel.numberOfLines = 0;
    cell.delegate = self;
    WwAddressModel * model = [self.dataModel objectAtIndex:indexPath.row];
    cell.model = model;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    //获取indexPath
    NSIndexPath *indexPath = [[NSIndexPath alloc]initWithIndex:section];
    if (indexPath.section == 0) {
        return 0;
    }
    return 30;
}

#pragma mark -- TableView cell Delegate
- (void)defaultBtnDidClicked:(WwAddressModel *)model {
    BOOL toType = !model.isDefault;
    if (toType == NO) {
        return; //默认不可以取消默认地址
    }
//    [ZXHttpTask POST:kUserSetDefaultAddress parameters:@{@"id":@(model.aID),@"isDefault":@(toType)} taskResponse:^(DVLHttpResponse *response) {
//        if (!response.code) {
//            [kZXUserModel.addressArr  enumerateObjectsUsingBlock:^(ZYUserAddressModel *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//                obj.isDefault = NO;
//            }];
//            model.isDefault = toType;
//            [self.tableV reloadData];
//        } else {
//            [ZYTipsView showInfoWithStatus:response.message];
//            [self.tableV reloadData];
//        }
//    }];
}

- (void)editBtnDidClicked:(WwAddressModel *)model {
//    [ZXRouter pushPage:ZXPageEditAddress withDate:model];
    WwNewAddressViewController *editVC = [[WwNewAddressViewController alloc] initWithNibName:nil bundle:nil];
    editVC.defaultUserAddress = model;
    [self.navigationController pushViewController:editVC animated:YES];
}

- (void)deleteBtnDidClicked:(WwAddressModel *)model {
    self.deleteM = model;
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"确定要删除该地址吗？" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
    [alertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
//        [ZXHttpTask POST:kUserAddressDelete parameters:@{@"id":@(self.deleteM.aID)} taskResponse:^(DVLHttpResponse *response) {
//            if (!response.code) {
//                [ZYTipsView showInfoWithStatus:@"删除成功"];
//                [self requestAddressList];
//            } else {
//                [ZYTipsView showInfoWithStatus:response.message];
//            }
//        }];
    }
    self.deleteM = nil;
}

#pragma mark - Request
- (void)requestAddressList {
    [self.dataModel refreshData];
}

#pragma mark - Getter
- (WwUserAddressDataModel *)dataModel {
    if (!_dataModel) {
        _dataModel = [[WwUserAddressDataModel alloc] init];
    }
    return _dataModel;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 180;
        _tableView.backgroundColor = RGBCOLORV(0xfafafa);
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        // xib添加
        [_tableView registerNib:[UINib nibWithNibName:@"WwAddressTableViewCell" bundle:nil] forCellReuseIdentifier:kWwAddressTableViewCellIdentifier];
    }
    return _tableView;
}


@end
