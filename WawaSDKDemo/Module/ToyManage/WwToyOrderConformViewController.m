//
//  WwToyOrderConformViewController.m
//  prizeClaw
//


#import "WwToyOrderConformViewController.h"
#import "WwToyOrderCell.h"
#import "WwOrderAdressCell.h"
#import "UIBarButtonItem+Extension.h"
#import "WwPopupsView.h"
#import "WwToyManageViewController.h"
#import "WwOrderAdressCell.h"

@interface WwToyOrderConformViewController () <UITableViewDataSource, UITableViewDataSource, WwPopupsViewDelegate>
{
    NSInteger _totalNum;
    NSMutableArray <WwWawaOrderItem *> *_ordersArr;
    
    WwAddressModel *_defaultAddress;  //默认地址
    
}

@property (nonatomic, weak) IBOutlet  UITableView *listTable;
@property (nonatomic, weak) IBOutlet  UIButton *conformBtn;
@property (nonatomic, weak) IBOutlet  UILabel *totalLabel;

@property (nonatomic, strong) WwAddressModel *selectedAddress; //选择的地址
@property (nonatomic, strong) WwAddressModel *address; // 获取当前选择的订单地址
@property (nonatomic, strong) WwPopupsView *deliverPopupsView;

@end

@implementation WwToyOrderConformViewController


- (void)dealloc
{
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem backButtonAddTaget:self action:@selector(onBackButtonPressed)];
    
    // 获取下最新地址
    
    
    self.title = @"订单确认";
//    [self Ww_adjustTableView:self.listTable];
    self.listTable.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, CGFLOAT_MIN)];
    self.listTable.backgroundView = nil;
    self.listTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    UINib *adrrCell = [UINib nibWithNibName:kWwOrderAdressCellIdentifier bundle:nil];
    [self.listTable registerNib:adrrCell forCellReuseIdentifier:kWwOrderAdressCellIdentifier];
    
    //已经发货的cell
    [self.listTable registerClass:[WwToyOrderCell class] forCellReuseIdentifier:kWwToyOrderCell];
    
    [self dealDataSource];
    
    
    self.listTable.delegate = self;
    self.listTable.dataSource = self;
    [self.listTable reloadData];
}

- (void)onBackButtonPressed {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)dealDataSource
{
    //获取计算个数
    NSArray<WwWawaDepositModel *> *arr = self.Ww_InitData; //按条数
    NSInteger count = arr.count;
    self.totalLabel.text = [NSString stringWithFormat:@"共计：%zi个娃娃",count];
    _totalNum = count;
    
    //合并暂存数据
    BOOL exit;
    WwWawaOrderItem *orderItemTmp;
    for (WwWawaDepositModel *dmodel in arr) {
        exit = NO;
        orderItemTmp = nil;
        
        for (WwWawaOrderItem *order in _ordersArr) {
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
            [_ordersArr addObject:oi];
        }
    }
}

#pragma mark - Action
- (IBAction)conformSend:(UIButton *)sender {
    
    if (self.address == nil) {
        NSLog(@"请选择收货地址");
        return;
    }
    
    if (_totalNum <= 1) {
        // 提示扣除60金币
        [self showDeliverPopupsView];
    }
    else {
        // 发一个请求，成功之后返回管理页面
        [[WawaSDK WawaSDKInstance].userInfoMgr requetCreateOrderWithWawaIds:[self createOrderPara] address:[WwAddressModel mj_objectWithKeyValues:[self.address mj_keyValues]] withCompleteHandler:^(int code, NSString *message) {
            if (code == WwErrorCodeSuccess) {
                [self postNotification];
                [self onBackButtonPressed];
            }
            NSLog(@"%@",message);
        }];
    }
}

- (NSArray *)createOrderPara {
    NSMutableArray *arrayM = [@[] mutableCopy];
    NSArray<WwWawaDepositModel *> *wawaRecordList = self.Ww_InitData; //按条数
    for (int i=0; i<wawaRecordList.count; ++i) {
        WwWawaDepositModel *item = wawaRecordList[i];
        // Note:创建订单，使用娃娃记录ID，而不是娃娃ID
        [arrayM addObject:[@(item.ID) stringValue]];
    }
    return arrayM;
}

- (WwAddressModel *)address
{
    if (_selectedAddress) {
        return _selectedAddress;
    }
    else if (_defaultAddress) {
        return _defaultAddress;
    }
    
    return nil;
}


#pragma mark - UITableViewDataSource UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }
    else {
        return _ordersArr.count;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
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
            
            WwWawaOrderItem *item = [_ordersArr safeObjectAtIndex:row];
            [(WwToyOrderCell *)cell reloadDataWithModel:item];
            [(WwToyOrderCell *)cell  setSeparatorVisible:NO];
            break;
        }
           
        default:
            //error donot happen
            break;
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

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
            //error donot happen
            break;
    }
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return CGFLOAT_MIN;
    }
    else {
         return 40;
    }
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
        label.textColor = WwColorGen(@"#444444");
        label.font = font(15);
        [view addSubview:label];
        
        UIView *sep = [[UIView alloc] initWithFrame:(CGRect){15,39,ScreenWidth - 30, 1}];
        sep.backgroundColor = WwColorGen(@"#eaeaea");
        [view addSubview:sep];
        return view;
    }
}



- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //
    if (indexPath.section == 0) {
        //编辑地址
        WwOrderAdressCell *cell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        
        if (cell.isAddAddress) {
            //新建地址
            
        }
        else {
        
            //如果是选择地址
            @weakify(self);
            void (^selectAddress)(WwAddressModel *model) = ^(WwAddressModel *model) {
                @strongify(self);
                if (model) {
                    self.selectedAddress = model;
                }
                [self.listTable reloadData];
            };
            //去选择新地址
            

        }
    }
}


#pragma mark - Add Observe
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
//    if (object == kZXUserModel && [keyPath isEqualToString:@"addressArr"]) {
//        //编辑地址
//        NSArray<WwAddressModel *> * arr  = change[NSKeyValueChangeNewKey];
//        if (arr.count == 0) {
//            _defaultAddress = nil;
//            _selectedAddress = nil;
//            [self.listTable reloadData];
//        }
//        else {
//
//            if (!_defaultAddress) {
//                for (WwAddressModel *am in arr) {
//                    if (am.isDefault) {
//                        _defaultAddress = am;
//                        break;
//                    }
//                }
//
//                if (!_defaultAddress) {
//                    NSLog(@"adress - error");
//                }
//                [self.listTable reloadData];
//            }
//        }
//    }
}

- (void)showDeliverPopupsView {
    [self.deliverPopupsView show];
    self.deliverPopupsView.titleLabel.text = @"温馨提示";
    self.deliverPopupsView.backgroundImageView.image = [UIImage imageNamed:@"exchange_background"];
    self.deliverPopupsView.contentLabel.text = @"两个娃娃起才可以包邮发货哦 邮寄单个娃娃，需支付60金币运费";
    [self.deliverPopupsView.sureButton setTitle:@"确定" forState:UIControlStateNormal];
}

- (void)postNotification {
    // 刷新寄存和运送页
    [[NSNotificationCenter defaultCenter] postNotificationName:NotiRefreshCheckingList object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:NotiRefreshDelieverList object:nil];
    // 默认回到运送页
    NSDictionary *dict = @{@"select":@1};
    [[NSNotificationCenter defaultCenter] postNotificationName:NotiRefreshCurrentSelectSegment object:dict];
}

- (WwPopupsView *)deliverPopupsView {
    if (!_deliverPopupsView) {
        _deliverPopupsView = [WwPopupsView instancePopupsView:WwPopupsViewTypeEvent];
        _deliverPopupsView.delegate = self;
    }
    return _deliverPopupsView;
}

#pragma mark - WwPopupsViewDelegate
- (void)popupsViewDelegate:(WwPopupsView *)popupsView eventButton:(UIButton *)btn {
    if (btn.tag == 1) {
        // 发一个请求，成功之后返回管理页面
        [[WawaSDK WawaSDKInstance].userInfoMgr requetCreateOrderWithWawaIds:[self createOrderPara] address:[WwAddressModel mj_objectWithKeyValues:[self.address mj_keyValues]] withCompleteHandler:^(int code, NSString *message) {
            if (code == WwErrorCodeSuccess) {
                NSLog(@"%@",message);
                [self postNotification];
                [self onBackButtonPressed];
            } else {
                NSLog(@"%@",message);
            }
        }];
    }
}

#pragma mark - SetterAndGetter



@end
