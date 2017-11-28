//
//  WwToyExchangeView.m
//  prizeClaw


#import <Foundation/Foundation.h>
#import "WwWawaExchangeViewController.h"
#import "WwToyCheckingCell.h"
#import "WwToyOrderCell.h"
#import "WwToyCheckView.h"
#import "WwToyDeliverFooter.h"
#import "WwToyDeliverHeader.h"
#import "WwToyManagePanel.h"
#import "UIBarButtonItem+Extension.h"
#import "WwPopupsView.h"
#import "WwShareAudioPlayer.h"
#import "WwDataModel.h"


// 屏蔽寄存数据和订单数据的封装对象
#pragma mark - WwWawaExchangeItem
@interface WwWawaExchangeItem : NSObject

@property (nonatomic, copy) NSArray <WwWawaDepositModel *> *depositList; // 寄存中
@property (nonatomic, strong) WwWawaOrderModel *orderModel; // 订单
@end

@implementation WwWawaExchangeItem

@end

#pragma mark - WwWawaExchangeDataModel

@interface WwWawaExchangeDataModel : WwDataModel
@property (nonatomic, copy) NSArray <WwWawaExchangeItem *>*exchangeList;
@property (nonatomic, assign, readonly) NSInteger totalWawaCount;
@property (nonatomic, assign, readonly) NSInteger defaultSelectCount;
@property (nonatomic, assign, readonly) NSInteger defaultSelectValue;
@property (nonatomic, assign) BOOL firstFetch;
@property (nonatomic, assign) WwWawaExchangeViewController * ownerVC;                      /**< 控制器*/
@end

@implementation WwWawaExchangeDataModel

+ (instancetype)createWithInitData:(id)aData {
    WwWawaExchangeDataModel *model = [WwWawaExchangeDataModel new];
    return model;
}

- (BOOL)emptyData {
    return self.exchangeList.count == 0;
}

- (NSInteger)totalWawaCount {
    NSInteger count = 0;
    for (int i=0; i<self.exchangeList.count; ++i) {
        WwWawaExchangeItem *item = self.exchangeList[i];
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
        WwWawaExchangeItem *item = self.exchangeList[i];
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
        WwWawaExchangeItem *item = self.exchangeList[i];
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
    // TODO
//    [ZXHttpTask GET:WwUserToyList parameters:@{@"type":@"deposit,express"} taskResponse:^(WwHttpResponse *response) {
//        if (!response.code) {
//            NSMutableArray *sectionArray = [@[] mutableCopy];
//
//            NSDictionary *deposit = response.data[@"deposit"];
//
//            if ([deposit isKindOfClass:[NSDictionary class]]) {
//                NSArray *list = deposit[@"list"];
//                if ([list isKindOfClass:[NSArray class]] && list.count!=0) {
//                    NSMutableArray <WwWawaDepositModel *>*resultList
//                    = [WwWawaDepositModel mj_objectArrayWithKeyValuesArray:list];
//                    WwWawaExchangeItem * item = [[WwWawaExchangeItem alloc] init];
//                    item.depositList = resultList;
//
//                    if (!_firstFetch) {
//                        _firstFetch = YES;
//                        [resultList enumerateObjectsUsingBlock:^(WwWawaDepositModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//                            // Note:对寄存中的默认全选
//                            if ([obj isKindOfClass:[WwWawaDepositModel class]]) {
//                                obj.selected = YES;
//                            }
//                        }];
//                    }
//                    // 1.添加寄存中
//                    [sectionArray addObject:item];
//                }
//            }
//
//            NSDictionary *express = response.data[@"express"];
//            if ([express isKindOfClass:[NSDictionary class]]) {
//                NSArray *list = express[@"list"];
//                if ([list isKindOfClass:[NSArray class]] && list.count!=0) {
//                    NSMutableArray <WwWawaOrderModel *> *resultList = [WwWawaOrderModel mj_objectArrayWithKeyValuesArray:list];
//
//                    NSMutableArray *array = [@[] mutableCopy];
//                    for (int i=0; i<resultList.count; ++i) {
//                        WwWawaOrderModel *model = resultList[i];
//                        if (model.status == 0) {
//                            // 只过滤未发货状态
//                            [array addObject:model];
//                        }
//                    }
//
//                    for (int i=0; i<array.count; ++i) {
//                        WwWawaExchangeItem * item = [[WwWawaExchangeItem alloc] init];
//                        item.orderModel = array[i];
//                        // 2.添加未发货
//                        [sectionArray addObject:item];
//                    }
//                }
//            }
//
//            self.exchangeList = sectionArray;
//        }
//        [self setValue:@(response.code) forKey:kWwKeyPathDataFetchResult];
//    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.exchangeList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger count = 0;
    if (section < self.exchangeList.count) {
        WwWawaExchangeItem *item = self.exchangeList[section];
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
        WwWawaExchangeItem *item = self.exchangeList[indexPath.section];
        if (item.depositList) {
            if (indexPath.row < item.depositList.count) {
                WwToyCheckingCell * checkCell = [tableView dequeueReusableCellWithIdentifier:kWwToyCheckingCell forIndexPath:indexPath];
                WwWawaDepositModel *model = item.depositList[indexPath.row];
                [checkCell reloadDataWithModel:model];
                
                @weakify(self);
                [checkCell cellSelectedWithBlock:^(BOOL select) {
                    @strongify(self);
                    NSInteger value = model.coin;
                    WwWawaExchangeViewController *vc = (WwWawaExchangeViewController *)self.ownerVC;
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
        WwWawaExchangeItem *exchangeItem = self.exchangeList[indexPath.section];
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
            WwWawaExchangeViewController *vc = (WwWawaExchangeViewController *)self.ownerVC;
            vc.selectCount += (select? orderItemCount : -orderItemCount);
            vc.selectValue += (select? value : -value);
            
            [vc.tableView reloadSection:indexPath.section withRowAnimation:UITableViewRowAnimationNone];
        }
    }
}

@end


#pragma mark - WwWawaExchangeViewController
@interface WwWawaExchangeViewController () <ToyManagePanelDelegate>
@property (nonatomic, strong) WwWawaExchangeDataModel *Ww_DataModel;
@property (nonatomic, strong) WwToyManagePanel *panel;
@property (nonatomic, strong) WwPopupsView *exchangeSuccessView;
@end


@implementation WwWawaExchangeViewController

- (void)dealloc {
//    [self removeObserver];
}

- (instancetype)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:UITableViewStyleGrouped];
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

- (Class)Ww_DataModelClass {
    return [WwWawaExchangeDataModel class];
}

- (Class)Ww_UIClass {
    return [WwToyCheckingCell class];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.navigationController.navigationBar.hidden = NO;
    self.view.superview.backgroundColor = RGBCOLOR(250, 250, 250);
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    CGRect frame = self.tableView.frame;
    self.tableView.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, frame.size.height-HeightOfToyManagePanel);
    [self showManagePanel:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setTitle:@"兑换金币"];
    [self.tableView registerClass:[WwToyCheckingCell class] forCellReuseIdentifier:kWwToyCheckingCell];
    [self.tableView registerClass:[WwToyOrderCell class] forCellReuseIdentifier:kWwToyOrderCell];
    self.tableView.backgroundColor = RGBCOLOR(250, 250, 250);
    self.view.backgroundColor = RGBCOLOR(250, 250, 250);
    [self.navigationController.navigationBar setTranslucent:NO];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem backButtonAddTaget:self action:@selector(onBackButtonPressed:)];
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 53, 0);
    _panel = [WwToyManagePanel createPanelWithFrame:CGRectZero andStyle:ToyManagePanel_Exchange];
    _panel.delegate = self;
    _panel.frame = CGRectMake(0, ScreenHeight, ScreenWidth, HeightOfToyManagePanel);
    _panel.hidden = YES;
}

#pragma mark - Private
- (void)onBackButtonPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)showManagePanel:(BOOL)show {
    if (!_panel.superview) {
        [self.view.superview addSubview:_panel];
        [self.view.superview bringSubviewToFront:_panel];
    }
    if (self.panel.isHidden == !show) {
        // 如果panel状态和要操作的状态一致
        return;
    }
    
    if (show && ![self isCheckingDataEmpty]) {
        // Note: 如果寄存中数据为空，不显示面板
        
        self.panel.hidden = NO;
        [UIView animateWithDuration:0.2 animations:^{
            self.panel.bottom = ScreenHeight;
        }];
    }
    else {
        [UIView animateWithDuration:0.2 animations:^{
            self.panel.top = ScreenHeight;
        } completion:^(BOOL finished) {
            self.panel.hidden = YES;
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
        WwWawaExchangeItem *item = self.Ww_DataModel.exchangeList[indexPath.section];
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
        WwWawaExchangeItem *item = self.Ww_DataModel.exchangeList[section];
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
        WwWawaExchangeItem *item = self.Ww_DataModel.exchangeList[section];
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

#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    if (object == self.Ww_DataModel) {
        // 初始化默认选择数目
        [self setDefaultSelectCount:self.Ww_DataModel.defaultSelectCount withValue:self.Ww_DataModel.defaultSelectValue];
        [self showManagePanel:self.Ww_DataModel.exchangeList.count];
        [self.tableView reloadData];
    }
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
    NSArray<WwWawaExchangeItem *> *array = self.Ww_DataModel.exchangeList;
    NSInteger numOfSelected = 0;
    NSInteger value = 0;
    
    for (int i=0; i<array.count; ++i) {
        WwWawaExchangeItem *exchangeItem = array[i];
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
    @weakify(self);
    [[WwUserInfoManager UserInfoMgrInstance] requestWawaExchangeCoin:para withCompleteHandler:^(int code, NSString *message) {
        @strongify(self);
        if (!code) {
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

- (NSDictionary *)createExchangeParaWithList:(NSArray <WwWawaExchangeItem *>*)list {
    NSMutableString *idStr = [@"" mutableCopy];
    NSMutableString *orderIdStr = [@"" mutableCopy];
    
    for (int i=0; i<list.count; ++i) {
        WwWawaExchangeItem *exchangeItem = list[i];
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

- (NSArray <WwWawaExchangeItem *> *)selectToyList {
    NSMutableArray <WwWawaExchangeItem *>*array = [@[] mutableCopy];
    
    for (int i=0; i<self.Ww_DataModel.exchangeList.count; ++i) {
        WwWawaExchangeItem *exchangeItem = self.Ww_DataModel.exchangeList[i];
        
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
                WwWawaExchangeItem *tmp = [WwWawaExchangeItem new];
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
