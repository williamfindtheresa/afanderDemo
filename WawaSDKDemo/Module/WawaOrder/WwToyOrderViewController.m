//
//  WwToyOrderViewController.h
//  F_Sky
//

#import "WwToyOrderViewController.h"
#import "WwToyOrderCell.h"
#import "WwOrderAdressCell.h"
#import "WwToyManageViewController.h"
#import "WwUserAddressDataModel.h"


#import <WawaSDK/WwDataDef.h>


@interface WwToyOrderViewController () <UITableViewDelegate, UITableViewDataSource>
{
    WwAddressModel *_defaultAddress;  //默认地址
}

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, weak) IBOutlet UIButton *conformBtn;
@property (nonatomic, weak) IBOutlet UILabel *totalLabel;
@property (nonatomic, strong) WwAddressModel *selectedAddress; //选择的地址
@property (nonatomic, strong) WwAddressModel *address; // 获取当前选择的订单地址
@property (nonatomic, strong) WwUserAddressDataModel *dataModel;
@property (nonatomic, strong) NSMutableArray <WwWawaOrderItem *> *ordersList;
@end

@implementation WwToyOrderViewController

- (void)dealloc {
    [self removeObserver];
}

- (void)awakeFromNib {
    [super awakeFromNib];
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

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"订单确认";
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, CGFLOAT_MIN)];
    self.tableView.backgroundView = nil;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    UINib *adrrCell = [UINib nibWithNibName:kWwOrderAdressCellIdentifier bundle:nil];
    [self.tableView registerNib:adrrCell forCellReuseIdentifier:kWwOrderAdressCellIdentifier];
    [self.tableView registerClass:[WwToyOrderCell class] forCellReuseIdentifier:kWwToyOrderCell];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView reloadData];
    
    [self addObserver];
    [self dealDataSource];
    
    // 获取地址列表
    [_dataModel refreshData];
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
        if (_dataModel.list.count == 0) {
            _defaultAddress = nil;
            _selectedAddress = nil;
            [self.tableView reloadData];
        }
        else {
            if (!_defaultAddress) {
                for (WwAddressModel *address in _dataModel.list) {
                    if (address.isDefault) {
                        _defaultAddress = address;
                        break;
                    }
                }
                [self.tableView reloadData];
            }
        }
    }
}

- (void)onBackButtonPressed {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)dealDataSource {
    //获取计算个数
    NSArray <WwWawaDepositModel *> *arr = self.wawaList;
    NSInteger count = arr.count;
    self.totalLabel.text = [NSString stringWithFormat:@"共计：%zi个娃娃",count];
    
    //合并暂存数据
    BOOL exit;
    WwWawaOrderItem *orderItemTmp;
    for (WwWawaDepositModel *dmodel in arr) {
        exit = NO;
        orderItemTmp = nil;
        
        for (WwWawaOrderItem *order in self.ordersList) {
            if (order.wid == dmodel.wid) {
                exit = YES;
                orderItemTmp = order;
                break;
            }
        }
        
        if (exit) {
            //把原先的 +1
            orderItemTmp.num += 1;
        }
        else {
            //新加
            WwWawaOrderItem *oi = [[WwWawaOrderItem alloc] init];
            oi.wid = dmodel.wid;
            oi.pic = dmodel.pic;
            oi.name = dmodel.name;
            oi.coin = dmodel.coin;
            oi.num  = 1;
            [self.ordersList addObject:oi];
        }
    }
}

#pragma mark - Action
- (IBAction)conformSend:(UIButton *)sender {
    if (self.address == nil) {
        NSLog(@"请选择收货地址");
        return;
    }
    
    // Note:2个娃娃包邮，1个娃娃邮件扣除60金币
    // 发一个请求，成功之后返回管理页面
    [[WwUserInfoManager UserInfoMgrInstance] requetCreateOrderWithWawaIds:[self getWawaIdsList] address:self.address withCompleteHandler:^(int code, NSString *message) {
        if (code == 0) {
            [self postNotification];
            [self onBackButtonPressed];
        }
    }];
}

- (NSArray <NSString *> *)getWawaIdsList {
    NSMutableArray *idsList = [@[] mutableCopy];
    
    NSArray<WwWawaDepositModel *> *wawaRecordList = self.wawaList;
    [wawaRecordList enumerateObjectsUsingBlock:^(WwWawaDepositModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [idsList addObject:[NSString stringWithFormat:@"%ld", obj.ID]];
    }];
    
    return idsList;
}

- (WwAddressModel *)address {
    if (_selectedAddress) {
        return _selectedAddress;
    }
    else if (_defaultAddress) {
        return _defaultAddress;
    }
    
    return nil;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }
    else {
        return self.ordersList.count;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    
    switch (section) {
        case 0:{
            //返回地址的那个
            cell = [tableView dequeueReusableCellWithIdentifier:kWwOrderAdressCellIdentifier forIndexPath:indexPath];
            [(WwOrderAdressCell *)cell loadWithData:self.address];
            break;
        }
        case 1:{
            cell = [tableView dequeueReusableCellWithIdentifier:kWwToyOrderCell forIndexPath:indexPath];
            
            WwWawaOrderItem *item = [self.ordersList objectAtIndex:row];
            [(WwToyOrderCell *)cell reloadDataWithModel:item];
            [(WwToyOrderCell *)cell setSeparatorVisible:NO];
            break;
        }
        default:
            break;
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        UIView *view = [[UIView alloc] initWithFrame:(CGRect){0,0,ScreenWidth,0.01}];
        return view;
    }
    else {
        UIView *view = [[UIView alloc] initWithFrame:(CGRect){0,0,ScreenWidth,40}];
        view.backgroundColor = [UIColor whiteColor];
        UILabel *label = [[UILabel alloc] initWithFrame:(CGRect){16,10,100,20}];
        label.text = @"订单内容";
        label.textColor = RGBCOLOR(68, 68, 68);
        label.font = font(15);
        [view addSubview:label];
        
        UIView *sep = [[UIView alloc] initWithFrame:(CGRect){15,39,ScreenWidth - 30, 1}];
        sep.backgroundColor = RGBCOLOR(234, 234, 234);
        [view addSubview:sep];
        return view;
    }
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    
    switch (section) {
        case 0:{
            return  (126.0 * ScreenWidth / 375.0);
            break;
        }
        case 1:{
            return ToyOrderCellRowHeight;
            break;
        }
        default:
            break;
    }
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return CGFLOAT_MIN;
    }
    else {
        return 40;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        //编辑地址
        WwOrderAdressCell *cell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        
        if (cell.isAddAddress) {
            //新建地址
//            [ZXRouter pushPage:ZXPageEditAddress];
        }
        else {
        
            //如果是选择地址
            @weakify(self);
            void (^selectAddress)(WwAddressModel *model) = ^(WwAddressModel *model) {
                @strongify(self);
                if (model) {
                    self.selectedAddress = model;
                }
                [self.tableView reloadData];
            };
            //去选择新地址
//            [ZXRouter pushPage:ZXPageSelectAddress withDate:@{@"block":selectAddress}];
        }
    }
}

- (void)postNotification {
    // 刷新寄存和运送页
    [[NSNotificationCenter defaultCenter] postNotificationName:NotiRefreshCheckingList object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:NotiRefreshDelieverList object:nil];
    // 默认回到运送页
    NSDictionary *dict = @{@"select":@1};
    [[NSNotificationCenter defaultCenter] postNotificationName:NotiRefreshCurrentSelectSegment object:dict];
}

#pragma mark - Getter 
- (WwUserAddressDataModel *)dataModel {
    if (!_dataModel) {
        _dataModel = [[WwUserAddressDataModel alloc] init];
    }
    return _dataModel;
}

- (NSMutableArray <WwWawaOrderItem *> *)ordersList {
    if (!_ordersList) {
        _ordersList = [NSMutableArray array];
    }
    return _ordersList;
}

@end
