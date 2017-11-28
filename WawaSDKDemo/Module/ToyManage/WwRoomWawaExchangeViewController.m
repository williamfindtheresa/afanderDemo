//
//  WwRoomWawaExchangeViewController.m
//  prizeClaw
//


#import "WwRoomWawaExchangeViewController.h"
#import "WwToyCheckingCell.h"
#import "WwToyOrderCell.h"
#import "WwToyCheckView.h"
#import "WwToyDeliverFooter.h"
#import "WwToyDeliverHeader.h"
#import "WwDataModel.h"
#import "WwToyManagePanel.h"
#import "UIBarButtonItem+Extension.h"
#import "WwPopupsView.h"
#import "WwShareAudioPlayer.h"

// 屏蔽寄存数据和订单数据的封装对象
#pragma mark - WwWawaExchangeItem
@interface WwRoomWawaExchangeItem : NSObject

@property (nonatomic, copy) NSArray <WwWawaDepositModel *> *depositList; // 寄存中
@property (nonatomic, strong) WwWawaOrderModel *orderModel; // 订单
@end

@implementation WwRoomWawaExchangeItem

@end

#pragma mark - WwWawaExchangeDataModel

@interface WwRoomWawaExchangeDataModel : WwDataModel<UITableViewDataSource>
@property (nonatomic, weak) WwRoomWawaExchangeViewController *ownVC;
@property (nonatomic, copy) NSArray <WwRoomWawaExchangeItem *>*exchangeList;
@property (nonatomic, assign, readonly) NSInteger totalWawaCount;
@property (nonatomic, assign, readonly) NSInteger defaultSelectCount;
@property (nonatomic, assign, readonly) NSInteger defaultSelectValue;
@property (nonatomic, assign) BOOL firstFetch;
@end

@implementation WwRoomWawaExchangeDataModel

+ (instancetype)createWithInitData:(id)aData {
    WwRoomWawaExchangeDataModel *model = [self new];
    return model;
}

- (void)dealloc {
    
}

- (BOOL)emptyData {
    return self.exchangeList.count == 0;
}

- (NSInteger)totalWawaCount {
    NSInteger count = 0;
    for (int i=0; i<self.exchangeList.count; ++i) {
        WwRoomWawaExchangeItem *item = self.exchangeList[i];
        if (item.depositList) {
            count += item.depositList.count;
        }
        else if (item.orderModel) {
            count += item.orderModel.records.count;
        }
    }
    return count;
}

- (NSInteger)defaultSelectCount {
    NSInteger count = 0;
    for (int i=0; i<self.exchangeList.count; ++i) {
        WwRoomWawaExchangeItem *item = self.exchangeList[i];
        if (item.depositList) {
            count += item.depositList.count;
            break;
        }
    }
    return count;
}

- (NSInteger)defaultSelectValue {
    __block NSInteger value = 0;
    for (int i=0; i<self.exchangeList.count; ++i) {
        WwRoomWawaExchangeItem *item = self.exchangeList[i];
        if (item.depositList) {
            NSArray <WwWawaDepositModel *> *list = item.depositList;
            [list enumerateObjectsUsingBlock:^(WwWawaDepositModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([obj isKindOfClass:[WwWawaDepositModel class]]) {
                    value += obj.coin;
                }
            }];
            break;
        }
    }
    return value;
}

- (void)fetchData {
    [[WawaSDK WawaSDKInstance].userInfoMgr requestUserWawaList:WawaList_Deposit withCompleteHandler:^(int code, NSString *message, WwUserWawaModel *model) {
        if (code == WwErrorCodeSuccess) {
            NSMutableArray *sectionArray = [@[] mutableCopy];
            NSArray *depositArray = [WwWawaDepositModel mj_objectArrayWithKeyValuesArray:[WwUserWawaModel mj_keyValuesArrayWithObjectArray:model.depositList]];
            
            if ([depositArray isKindOfClass:[NSArray class]]) {
                if ([depositArray isKindOfClass:[NSArray class]] && depositArray.count!=0) {
                    NSMutableArray <WwWawaDepositModel *>*resultList
                    = [NSMutableArray arrayWithArray:depositArray];
                    WwRoomWawaExchangeItem * item = [[WwRoomWawaExchangeItem alloc] init];
                    item.depositList = resultList;
                    
                    if (!_firstFetch) {
                        _firstFetch = YES;
                        [resultList enumerateObjectsUsingBlock:^(WwWawaDepositModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                            // Note:对寄存中的默认全选
                            if ([obj isKindOfClass:[WwWawaDepositModel class]]) {
                                obj.selected = YES;
                            }
                        }];
                    }
                    // 1.添加寄存中
                    [sectionArray addObject:item];
                }
            }
            self.exchangeList = sectionArray;
        }
        [self.ownVC reloadData];
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.exchangeList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger count = 0;
    if (section < self.exchangeList.count) {
        WwRoomWawaExchangeItem *item = self.exchangeList[section];
        if (item.depositList) {
            count = item.depositList.count;
        }
        else if (item.orderModel) {
            count = item.orderModel.records.count;
        }
    }
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    
    if (indexPath.section < self.exchangeList.count) {
        WwRoomWawaExchangeItem *item = self.exchangeList[indexPath.section];
        if (item.depositList) {
            if (indexPath.row < item.depositList.count) {
                WwToyCheckingCell * checkCell = [tableView dequeueReusableCellWithIdentifier:kWwToyCheckingCell forIndexPath:indexPath];
                WwWawaDepositModel *model = item.depositList[indexPath.row];
                [checkCell reloadDataWithModel:model];
                
                @weakify(self);
                [checkCell cellSelectedWithBlock:^(BOOL select) {
                    @strongify(self);
                    NSInteger value = model.coin;
                    WwRoomWawaExchangeViewController *vc = (WwRoomWawaExchangeViewController *)self.ownVC;
                    vc.selectCount += (select? 1 : -1);
                    vc.selectValue += (select? value: -value);
                }];
                cell = checkCell;
            }
        }
        else if (item.orderModel) {
            WwToyOrderCell * orderCell = [tableView dequeueReusableCellWithIdentifier:kWwToyOrderCell forIndexPath:indexPath];
            if (indexPath.row < item.orderModel.records.count) {
                WwWawaOrderItem *orderItem = item.orderModel.records[indexPath.row];
                orderCell.style = ToyOrderCell_CanSelect;
                
                [orderCell reloadDataWithModel:orderItem];
                @weakify(self);
                [orderCell orderCellSelectedWithBlock:^(BOOL select) {
                    @strongify(self);
                    [self setOrderModelSelected:select withIndexPath:indexPath];
                }];
                cell = orderCell;
            }
        }
    }
    
    if (!cell) {
        cell = [tableView dequeueReusableCellWithIdentifier:kWwToyCheckingCell forIndexPath:indexPath];
    }
    [cell setNeedsUpdateConstraints];
    
    return cell;
}

#pragma mark - Helper Methods
- (void)setOrderModelSelected:(BOOL)select withIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section < self.exchangeList.count) {
        WwRoomWawaExchangeItem *exchangeItem = self.exchangeList[indexPath.section];
        if (exchangeItem.orderModel) {
            // 如果是个未发送的订单，则将其余的都选中
            NSArray <WwWawaOrderItem *>*records = exchangeItem.orderModel.records;
            
            exchangeItem.orderModel.selected = select;
            
            NSInteger value = 0;
            for (int i=0; i<records.count; ++i) {
                WwWawaOrderItem *orderItem = records[i];
                orderItem.selected = select;
                value += (orderItem.coin * orderItem.num);
            }
            NSInteger orderItemCount = records.count;
            
            // 刷新整个section
            WwRoomWawaExchangeViewController *vc = (WwRoomWawaExchangeViewController *)self.ownVC;
            vc.selectCount += (select? orderItemCount : -orderItemCount);
            vc.selectValue += (select? value : -value);
            
            [vc.tableView reloadSection:indexPath.section withRowAnimation:UITableViewRowAnimationNone];
        }
    }
}

@end

@interface WwRoomWawaExchangeViewController () <ToyManagePanelDelegate, UITableViewDelegate>
@property (nonatomic, strong) WwRoomWawaExchangeDataModel *Ww_DataModel;
@property (nonatomic, strong) WwToyManagePanel *panel;
@property (nonatomic, strong) WwPopupsView *exchangeSuccessView;
@end


@implementation WwRoomWawaExchangeViewController

- (void)dealloc {
    [self setWw_DataModel:nil];
}

- (Class)Ww_DataModelClass {
    return [WwRoomWawaExchangeDataModel class];
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self initData];
        [self initUI];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    CGRect frame = self.view.frame;
    self.tableView.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, frame.size.height);
    [self showManagePanel:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerClass:[WwToyCheckingCell class] forCellReuseIdentifier:kWwToyCheckingCell];
    [self.tableView registerClass:[WwToyOrderCell class] forCellReuseIdentifier:kWwToyOrderCell];
    self.tableView.backgroundColor = RGBCOLOR(250, 250, 250);
    self.view.backgroundColor = RGBCOLOR(250, 250, 250);
        
    _panel = [WwToyManagePanel createPanelWithFrame:CGRectZero andStyle:ToyManagePanel_Exchange];
    _panel.delegate = self;
    _panel.frame = CGRectMake(0, self.view.size.height, ScreenWidth, HeightOfToyManagePanel);
    _panel.hidden = YES;
}

- (void)initData {
    _Ww_DataModel = [WwRoomWawaExchangeDataModel createWithInitData:nil];
    _Ww_DataModel.ownVC = self;
    [_Ww_DataModel fetchData];
}

- (void)initUI {
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.delegate = self;
    _tableView.dataSource = self.Ww_DataModel;
    
    [self.view addSubview:_tableView];
}

#pragma mark - Public
- (void)reloadData {
    // 初始化默认选择数目
    [self setDefaultSelectCount:self.Ww_DataModel.defaultSelectCount withValue:self.Ww_DataModel.defaultSelectValue];
    [self showManagePanel:self.Ww_DataModel.exchangeList.count];
    [self.tableView reloadData];
}

#pragma mark - Private
- (void)showManagePanel:(BOOL)show {
    if (!_panel.superview) {
        [self.view addSubview:_panel];
        [self.view bringSubviewToFront:_panel];
    }
    if (self.panel.isHidden == !show) {
        // 如果panel状态和要操作的状态一致
        return;
    }
    
    if (show && ![self isCheckingDataEmpty]) {
        // Note: 如果寄存中数据为空，不显示面板
        
        self.panel.hidden = NO;
        if (self.panel.bottom == self.view.bottom) {
            return;
        }
        [UIView animateWithDuration:0.2 animations:^{
            self.panel.bottom = self.view.bottom;
        } completion:^(BOOL finished) {
            self.panel.hidden = NO;
            self.tableView.height = self.view.height - HeightOfToyManagePanel;
        }];
    }
    else {
        if (self.panel.top == self.view.bottom) {
            return;
        }
        
        [UIView animateWithDuration:0.2 animations:^{
            self.panel.top = self.view.bottom;
        } completion:^(BOOL finished) {
            self.panel.hidden = YES;
            self.tableView.height = self.view.height;
        }];
    }
}

- (BOOL)isCheckingDataEmpty {
    return self.Ww_DataModel.exchangeList.count == 0;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    WwToyCheckingCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell) {
        self.selectCount += (cell.isSelected? -1: 1);
        [cell setCellSelected:!cell.isSelected];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    CGFloat height = 0.f;
    if (indexPath.section < self.Ww_DataModel.exchangeList.count) {
        WwRoomWawaExchangeItem *item = self.Ww_DataModel.exchangeList[indexPath.section];
        if (item.depositList) {
            height = ToyCheckingCellRowHeight;
        }
        else if (item.orderModel) {
            height = ToyOrderCellRowHeight;
        }
    }
    return height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section < self.Ww_DataModel.exchangeList.count) {
        WwRoomWawaExchangeItem *item = self.Ww_DataModel.exchangeList[section];
        CGFloat height = 0.f;
        if (item.depositList.count) {
            height = 0.1f;
        }
        else if (item.orderModel) {
            height = HeightOfToyDeliverHeader;
        }
        
        return height;
    }
    
    return 0.1f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section < self.Ww_DataModel.exchangeList.count) {
        WwRoomWawaExchangeItem *item = self.Ww_DataModel.exchangeList[section];
        ToyDeliverHeaderStyle style = DeliverHeader_None;
        if (item.depositList.count) {
            return nil;
        }
        else if (item.orderModel) {
            style = DeliverHeader_Prepareing;
        }
        
        WwToyDeliverHeader *view = [WwToyDeliverHeader createWithStyle:(ToyDeliverHeaderStyle)style];
        [view reloadWithData:item.orderModel];
        return view;
    }
    return nil;
}

#pragma mark - ToyManagePanelDelegate
- (void)onToyManagePanelAction:(ToyManagePanelAction)action {
    switch (action) {
        case ToyManagePanelAction_SelectAll:
            [self selectDepositAll:YES];
            break;
        case ToyManagePanelAction_UnselectAll:
            [self selectDepositAll:NO];
            break;
        case ToyManagePanelAction_RightAction:
            [self exchangeCoin];
            break;
        default:
            break;
    }
}

#pragma mark - Helper Methods
- (void)selectDepositAll:(BOOL)select {
    [self setAllSelect:select];
    [self.panel setAllSelect:select];
}

- (void)setAllSelect:(BOOL)select {
    NSArray<WwRoomWawaExchangeItem *> *array = self.Ww_DataModel.exchangeList;
    NSInteger numOfSelected = 0;
    NSInteger value = 0;
    
    for (int i=0; i<array.count; ++i) {
        WwRoomWawaExchangeItem *exchangeItem = array[i];
        if (exchangeItem.depositList) {
            NSArray *depoList = exchangeItem.depositList;
            
            for (int i=0; i<depoList.count; ++i) {
                WwWawaDepositModel *model = depoList[i];
                if ([model isKindOfClass:[WwWawaDepositModel class]]) {
                    // Note:寄存标记选中
                    model.selected = select;
                    
                    if (select) {
                        numOfSelected += 1;
                    }
                    value += model.coin;
                }
            }
        }
        else if (exchangeItem.orderModel) {
            NSArray <WwWawaOrderItem *>*records = exchangeItem.orderModel.records;
            
            // Note:订单标记选中
            exchangeItem.orderModel.selected = select;
            
            for (int i=0; i<records.count; ++i) {
                WwWawaOrderItem *orderItem = records[i];
                orderItem.selected = select;
                if (select) {
                    numOfSelected += 1;
                }
                
                value += (orderItem.coin * orderItem.num);
            }
        }
    }
    self.selectCount = numOfSelected;
    self.selectValue = (select ? value : 0);
    
    [self.tableView reloadData];
}

- (void)exchangeCoin {
    NSArray *toyList = [self selectToyList];
    if (toyList.count == 0) {
        NSLog(@"请至少选择一个娃娃");
        return;
    }
    NSDictionary *para = [self createExchangeParaWithList:toyList];
    NSInteger changeValue = self.selectValue;
    [[WawaSDK WawaSDKInstance].userInfoMgr requestWawaExchangeCoin:para withCompleteHandler:^(int code, NSString *message) {
        if (code == 0) {
            NSLog(@"兑换成功");
            [self exchangeSuccessView:[@(changeValue) stringValue]];
            [self.Ww_DataModel fetchData];
            [[WwShareAudioPlayer shareAudioPlayer] playResultAudioWithFile:@"exchange_success" ofType:@"mp3"];
        }
        else {
            NSLog(@"兑换失败");
        }
    }];
    
}

- (NSDictionary *)createExchangeParaWithList:(NSArray <WwRoomWawaExchangeItem *>*)list {
    NSMutableString *idStr = [@"" mutableCopy];
    NSMutableString *orderIdStr = [@"" mutableCopy];
    
    for (int i=0; i<list.count; ++i) {
        WwRoomWawaExchangeItem *exchangeItem = list[i];
        if (exchangeItem.depositList) {
            // 寄存中数据拼接 "ids" 字段
            NSArray *depoList = exchangeItem.depositList;
            
            for (int i=0; i<depoList.count; ++i) {
                WwWawaDepositModel *model = depoList[i];
                if (i==depoList.count -1) {
                    [idStr appendString:[NSString stringWithFormat:@"%ld", model.ID]];
                }
                else {
                    [idStr appendString:[NSString stringWithFormat:@"%ld,", model.ID]];
                }
            }
        }
        else if (exchangeItem.orderModel) {
            // 未发货数据拼接 "orderIds" 字段
            [orderIdStr appendString:[NSString stringWithFormat:@"%@,", exchangeItem.orderModel.orderId]];
        }
    }
    NSMutableDictionary *para = [@{} mutableCopy];
    para[@"ids"] = idStr;
    para[@"orderIds"] = orderIdStr;
    return para;
}

- (NSArray <WwRoomWawaExchangeItem *> *)selectToyList {
    NSMutableArray <WwRoomWawaExchangeItem *>*array = [@[] mutableCopy];
    
    for (int i=0; i<self.Ww_DataModel.exchangeList.count; ++i) {
        WwRoomWawaExchangeItem *exchangeItem = self.Ww_DataModel.exchangeList[i];
        
        if (exchangeItem.depositList) {
            // 如果是寄存section，将其中选中的过滤出来
            NSArray *depoArray = exchangeItem.depositList;
            NSMutableArray *selectDepoArray = [@[] mutableCopy];
            
            for (int i=0; i<depoArray.count; ++i) {
                WwWawaDepositModel *depositItem = depoArray[i];
                if (depositItem.selected) {
                    [selectDepoArray addObject:depositItem];
                }
            }
            if (selectDepoArray.count) {
                // 创建一个新的ExchangeItem 保存选中的寄存中的toy
                WwRoomWawaExchangeItem *tmp = [WwRoomWawaExchangeItem new];
                tmp.depositList = selectDepoArray;
                [array addObject:tmp];
            }
        }
        else if (exchangeItem.orderModel) {
            if (exchangeItem.orderModel.selected) {
                [array addObject:exchangeItem];
            }
        }
    }
    return array;
}

- (void)setDefaultSelectCount:(NSInteger)defaultCount withValue:(NSInteger)value {
    self.selectCount = defaultCount;
    self.selectValue = value;
    if (defaultCount == 0) {
        // Note: 如果寄存中为空，禁止掉半选状态
        self.panel.halfSelect = NO;
    }
}

#pragma mark - Setter
- (void)setSelectCount:(NSInteger)count{
    _selectCount = count;
    NSInteger total = self.Ww_DataModel.totalWawaCount;
    [self.panel setCurrentSelectNumber:_selectCount withTotal:total];
}

- (void)setSelectValue:(NSInteger)selectValue {
    _selectValue = selectValue;
    [self.panel setSelectTotalValue:selectValue];
}


- (void)exchangeSuccessView:(NSString *)successStr {
    [self.exchangeSuccessView show];
    [self.exchangeSuccessView.titleLabel setText:@"兑换成功"];
    self.exchangeSuccessView.middleImages = @[@"sign_light", @"jinbi"];
    [self.exchangeSuccessView.imageDesLabel setText:[NSString stringWithFormat:@"金币x%@", successStr]];
    self.exchangeSuccessView.sureBtnConstraintHeight.constant = 10;
}
- (WwPopupsView *)exchangeSuccessView {
    if (!_exchangeSuccessView) {
        _exchangeSuccessView = [WwPopupsView instancePopupsView:WwPopupsViewTypeNormal];
    }
    return _exchangeSuccessView;
}



@end
