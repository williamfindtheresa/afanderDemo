//
//  WwToyManageViewController.m
//  WawaSDKDemo
//
//

#import <Foundation/Foundation.h>
#import "WwToyManageViewController.h"
#import "WwToyExchangeViewController.h"
#import "WwToyDepositViewController.h"
#import "WwToyDeliverViewController.h"
#import "WwToyOrderViewController.h"
#import "WwSegmentControl.h"
#import "WwToyManagePanel.h"
#import "WwDataModel.h"
#import "WawaKitConstants.h"
#import "WwBaseScrollView.h"

@interface WwToyManageDataModel : WwDataModel

@property (nonatomic, strong) NSMutableArray <WwWawaDepositModel *> *depositList; // 寄存中
@property (nonatomic, strong) NSMutableArray <WwWawaOrderModel *> *deliverList;// 已发货
@property (nonatomic, strong) NSMutableArray <WwWawaOrderModel *> *exchangeList;// 已兑换

@end

@implementation WwToyManageDataModel
- (void)asyncFetchListAtPage:(NSInteger)pageIndex isRefresh:(BOOL)isRefresh withComplete:(void (^)(BOOL, NSArray *, NSInteger, long long))complete {
    [[WwUserInfoManager UserInfoMgrInstance] requestUserWawaList:WawaList_All withCompleteHandler:^(int code, NSString *message, WwUserWawaModel *model) {
        self.depositList = model.depositList;
        self.deliverList = model.deliverList;
        self.exchangeList = model.exchangeList;
    }];
}

@end

@interface WwToyManageViewController() <WwSegmentControlDelegate, ToyManagePanelDelegate, UIScrollViewDelegate>
@property (nonatomic, strong) WwToyManageDataModel *dataModel;
@property (nonatomic, strong) WwSegmentControl *segmentControl;
@property (nonatomic, strong) UIScrollView *scrollBaseV;
@property (nonatomic, strong) WwToyDepositViewController *depositVC;
@property (nonatomic, strong) WwToyDeliverViewController *deliverVC;
@property (nonatomic, strong) WwToyExchangeViewController *exchangeVC;
@property (nonatomic, strong) WwToyManagePanel *panel;
@end

@implementation WwToyManageViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self initData];
    }
    return self;
}

- (void)initData {
    _dataModel = [[WwToyManageDataModel alloc] init];
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
    
    [self setTitle:@"我的娃娃"];
    self.view.backgroundColor = RGBCOLORV(0xeeeeee);
    
    [self.navigationController.navigationBar setTranslucent:NO];
    self.automaticallyAdjustsScrollViewInsets = NO;
    NSArray *titles = [self columnTitleOfSections];
    self.segmentControl = [WwSegmentControl segmentWithFrame:CGRectMake(0, 0, ScreenWidth, HeightOfSegmentControl) titleArray:titles defaultSelect:0];
    self.segmentControl.delegate = self;
    [self.segmentControl setBottomLineVisible:YES];
    [self.segmentControl setTitleColor:RGBCOLOR(140, 140, 140) selectTitleColor:RGBCOLOR(68, 68, 68) BackGroundColor:[UIColor whiteColor] titleFontSize:16.f];
    [self.view addSubview:self.segmentControl];
    
    
    self.scrollBaseV = [[WwBaseScrollView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.scrollBaseV];
    self.scrollBaseV.backgroundColor = RGBCOLOR(250, 250, 250);
    self.scrollBaseV.delegate = self;
    self.scrollBaseV.directionalLockEnabled = YES;
    self.scrollBaseV.bounces = NO;
    self.scrollBaseV.frame = CGRectMake(0, HeightOfSegmentControl, ScreenWidth, ScreenHeight - 66 - HeightOfSegmentControl);
    
    CGSize size = _scrollBaseV.bounds.size;
    self.scrollBaseV.contentSize = CGSizeMake([self columnTitleOfSections].count*size.width, size.height);
    self.scrollBaseV.pagingEnabled = YES;
    self.scrollBaseV.scrollsToTop = NO;
    
    self.segmentControl.backgroundColor = RGBCOLOR(250, 250, 250);
    
    CGRect rect = CGRectZero;
    rect.size = self.scrollBaseV.contentSize;
    rect.size.width = self.scrollBaseV.bounds.size.width;
    
    self.depositVC = [[WwToyDepositViewController alloc] initWithNibName:nil bundle:nil];
    [self addChildViewController:self.depositVC];
    [self.scrollBaseV addSubview:self.depositVC.view];
    [self.depositVC.view setFrame:rect];

    self.deliverVC = [[WwToyDeliverViewController alloc] initWithNibName:nil bundle:nil];
    [self addChildViewController:self.deliverVC];
    [self.scrollBaseV addSubview:self.deliverVC.view];
    
    rect.origin.x = rect.size.width;
    [self.deliverVC.view setFrame:rect];
    
    self.exchangeVC = [[WwToyExchangeViewController alloc] initWithNibName:nil bundle:nil];
    [self addChildViewController:self.exchangeVC];
    [self.scrollBaseV addSubview:self.exchangeVC.view];
    
    rect.origin.x = rect.size.width*2;
    [self.exchangeVC.view setFrame:rect];
    
    [self.segmentControl selectTheSegment:0];
    
    // 添加观察
    [self addObserver];
    
    // 获取数据
    [self.dataModel refreshData];
}

#pragma mark - Observer
- (void)addObserver {
    // segment
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onNotiRefreshSegmentTitleHandler:) name:NotiRefreshSegmentTitle object:nil];
    // panel
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onNotiCheckingSelectCountChanged:) name:NotiToyManagePanelSelectChange object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onNotiPanelVisibleChanged:) name:NotiToyManagePanelVisible object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onNotiRefreshCheckingList:) name:NotiRefreshCheckingList object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onNotiRefreshDeliverList:) name:NotiRefreshDelieverList object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onNotiRefreshExchangeList:) name:NotiRefreshExchangeList object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onNotiRefreshCurrentSelectSegment:) name:NotiRefreshCurrentSelectSegment object:nil];
}

- (void)onNotiRefreshCurrentSelectSegment:(NSNotification *)noti {
    NSDictionary *dict = noti.object;
    if (dict[@"select"]) {
        NSInteger index = [dict[@"select"] integerValue];
        if (index<0 || index>self.segmentControl.buttonArray.count) {
            return;
        }
        [self.segmentControl setSelectSegment:index];
    }
}

- (void)onNotiRefreshSegmentTitleHandler:(NSNotification *)noti {
    NSDictionary *dict = noti.object;
    if (dict[@"index"]) {
        NSInteger index = [dict[@"index"] integerValue];
        NSString *title = dict[@"title"];
        [self.segmentControl refreshSegmentTitle:title atIndex:index];
    }
}

- (void)onNotiRefreshCheckingList:(NSNotification *)notification {
    [self.depositVC refreshList];
}

- (void)onNotiRefreshDeliverList:(NSNotification *)notification {
    [self.deliverVC refreshList];
}

- (void)onNotiRefreshExchangeList:(NSNotification *)notification {
    [self.exchangeVC refreshList];
}

- (void)showManagePanel:(BOOL)show {
    if (!_panel) {
        _panel = [WwToyManagePanel createPanelWithFrame:CGRectZero andStyle:ToyManagePanel_ToyChecking];
        _panel.delegate = self;
        _panel.frame = CGRectMake(0, ScreenHeight-HeightOfToyManagePanel-10, ScreenWidth, HeightOfToyManagePanel);
        _panel.hidden = YES;
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
        [UIView animateWithDuration:0.2 animations:^{
            CGFloat newbottom = ScreenHeight-HeightOfToyManagePanel-10;
            CGRect newframe = self.panel.frame;
            newframe.origin.y = newbottom - self.panel.frame.size.height;
            self.panel.frame = newframe;
        }];
    }
    else {
        [UIView animateWithDuration:0.2 animations:^{
            CGFloat newtop = ScreenHeight;
            CGRect newframe = self.panel.frame;
            newframe.origin.y = newtop;
            self.panel.frame = newframe;
        } completion:^(BOOL finished) {
            self.panel.hidden = YES;
        }];
    }
}

- (BOOL)isCheckingDataEmpty {
    return self.depositVC.totalCount == 0;
}

#pragma mark - Noti Handler
- (void)onNotiCheckingSelectCountChanged:(NSNotification *)noti {
    NSDictionary *userInfo = noti.object;
    NSInteger count = [userInfo[@"selectCount"] integerValue];
    NSInteger total = [userInfo[@"total"] integerValue];
    [self.panel setCurrentSelectNumber:count withTotal:total];
}

- (void)onNotiPanelVisibleChanged:(NSNotification *)noti {
    NSDictionary *userInfo = noti.object;
    BOOL visible = [userInfo[@"visible"] boolValue];
    [self showManagePanel:visible];
}

#pragma mark UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self.segmentControl selectTheSegment:scrollView.contentOffset.x/self.view.bounds.size.width];
}

#pragma mark - WwSegmentControlDelegate
-(void)segmentSelectionChange:(NSInteger)selection {
    if (self.segmentControl.selectSegment == 0) {
        [self showManagePanel:YES];
    }
    else {
        [self showManagePanel:NO];
    }
    [self.scrollBaseV setContentOffset:CGPointMake(selection*self.view.bounds.size.width, 0)];
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
        case ToyManagePanelAction_LeftAction:
            [self createOrder];
            break;
        case ToyManagePanelAction_RightAction:
            [self exchangeCoin];
            break;
        default:
            break;
    }
}

#pragma mark - Helper Methods
- (NSMutableArray *)columnTitleOfSections{
    NSMutableArray *titleArray = [NSMutableArray new];
    [titleArray addObject:@"寄存中"];
    [titleArray addObject:@"已发货"];
    [titleArray addObject:@"已兑换"];
    return titleArray;
}

- (void)selectDepositAll:(BOOL)select {
    [self.depositVC setAllSelect:select];
    [self.panel setAllSelect:select];
}

- (void)createOrder {
    NSArray <WwWawaDepositModel *>*toyList = [self.depositVC selectToyList];
    if (toyList.count == 0) {
        return;
    }
    
    WwToyOrderViewController *orderVC = [[WwToyOrderViewController alloc] initWithNibName:@"WwToyOrderViewController" bundle:[NSBundle mainBundle]];
    orderVC.wawaList = toyList;
    [self.navigationController pushViewController:orderVC animated:YES];
}

- (void)exchangeCoin {
    NSArray *toyList = [self.depositVC selectToyList];
    if (toyList.count == 0) {
        return;
    }
    
    NSDictionary *para = [self createExchangeParaWithList:toyList];
//    [WwUserInfoManager UserInfoMgrInstance] request
//    @weakify(self);
//    [ZXHttpTask POST:ZYUserWawaExchange parameters:para taskResponse:^(WwHttpResponse *response) {
//        @strongify(self);
//        if (!response.code) {
//            @"兑换成功";
//            [kZXUserModel fetchUserRichInfo];
//            [self.depositVC refreshList];
//            [self.exchangeVC refreshList];
//            [[WwShareAudioPlayer shareAudioPlayer] playResultAudioWithFile:@"exchange_success" ofType:@"mp3"];
//        }
//        else {
//           @"兑换失败";
//        }
//    }];
}

- (NSDictionary *)createExchangeParaWithList:(NSArray <WwWawaDepositModel *>*)list {
    NSMutableString *str = [@"" mutableCopy];
    for (int i=0; i<list.count; ++i) {
        WwWawaDepositModel *item = list[i];
        if (i==list.count -1) {
            [str appendString:[NSString stringWithFormat:@"%ld", item.ID]];
        }
        else {
            [str appendString:[NSString stringWithFormat:@"%ld,", item.ID]];
        }
    }
    NSMutableDictionary *para = [@{} mutableCopy];
    para[@"ids"] = str;
    return para;
}

@end

