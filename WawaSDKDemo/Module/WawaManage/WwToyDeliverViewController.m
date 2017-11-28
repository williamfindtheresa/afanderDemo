//
//  WWToyDeliverViewController.m
//  WawaSDKDemo
//
//

#import <Foundation/Foundation.h>
#import "WwToyDeliverViewController.h"
#import "WwToyOrderCell.h"
#import "WwToyDeliverFooter.h"
#import "WwToyDeliverHeader.h"
#import "WwToyManageViewController.h"
#import "WwToyCheckView.h"

#import "WwDataModel.h"
#import "WawaKitConstants.h"
#import "MJRefresh.h"

typedef NS_ENUM(NSInteger, ToyDeliverPopType) {
    ToyDeliverPop_Exchange,
    ToyDeliverPop_Confirm
};

@interface WwToyDeliverDataModel : WwDataModel

@end

@implementation WwToyDeliverDataModel

- (BOOL)emptyData {
    return self.count == 0;
}

- (void)asyncFetchListAtPage:(NSInteger)pageIndex isRefresh:(BOOL)isRefresh withComplete:(void (^)(BOOL, NSArray *, NSInteger, long long))complete {
    [[WwUserInfoManager UserInfoMgrInstance] requestUserWawaList:WawaList_Deliver withCompleteHandler:^(int code, NSString *message, WwUserWawaModel *model) {
        if (!code) {
            if (complete) {
                complete(YES, model.deliverList, model.deliverList.count, NSIntegerMax);
            }
        }
        else {
            if (complete) {
                complete(NO, nil, 0, 0);
            }
        }
        [self setValue:@(code) forKey:kWwDataModelFetchResult];
    }];
}
@end

#pragma mark - WwToyDeliverViewController

@interface WwToyDeliverViewController() <UITableViewDelegate, UITableViewDataSource, ToyDeliverFooterDelegate, WwDataModelDelegate>
@property (nonatomic, strong) WwToyDeliverDataModel *dataModel;
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation WwToyDeliverViewController

- (void)dealloc {
    [self removeObserver];
}


- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self initData];
    }
    return self;
}

- (void)initData {
    _dataModel = [[WwToyDeliverDataModel alloc] init];
    _dataModel.delegate = self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) style:UITableViewStyleGrouped];
    _tableView.backgroundColor = RGBCOLOR(250, 250, 250);
    [_tableView registerClass:[WwToyOrderCell class] forCellReuseIdentifier:kWwToyOrderCell];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    __weak __typeof(self) weakself = self;
    MJRefreshNormalHeader * header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakself refreshList];
    }];
    _tableView.mj_header = header;
    // set title
    [header setTitle:@"下拉翻页" forState:MJRefreshStateIdle];
    [header setTitle:@"松手翻页" forState:MJRefreshStatePulling];
    [header setTitle:@"Loading" forState:MJRefreshStateRefreshing];
    
    [self.view addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self addObserver];
    // 获取数据
    [self.dataModel refreshData];
}

#pragma mark - Public Methods
- (void)refreshList {
    [self.dataModel refreshData];
}

#pragma mark - Observer
- (void)removeObserver {
    [_dataModel removeObserver:self forKeyPath:kWwDataModelFetchResult context:nil];
}

- (void)addObserver {
    [_dataModel addObserver:self forKeyPath:kWwDataModelFetchResult options:NSKeyValueObservingOptionNew context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    
    if (object == _dataModel && [keyPath isEqualToString:kWwDataModelFetchResult]) {
        NSString *title;
        if (_dataModel.count) {
            title = [NSString stringWithFormat:@"已发货(%zi)", _dataModel.count];
        }
        else {
            title = [NSString stringWithFormat:@"已发货"];
        }
        
        NSDictionary *dict = @{@"index":@1, @"title":title};
        [[NSNotificationCenter defaultCenter] postNotificationName:NotiRefreshSegmentTitle object:dict];
    }
}

#pragma mark - WwDataModelDelegate
- (void)onDataModelRefresh:(WwDataModel *)dataModel {
    [_tableView.mj_header endRefreshing];
    [_tableView reloadData];
}

- (void)onDataModelFetchMore:(WwDataModel *)dataModel {
    if (_dataModel == dataModel) {
        if (_dataModel.addPageObjects.count > 0) {
            [_tableView reloadData];
        }
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _dataModel.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section >= 0 && section < _dataModel.count) {
        WwWawaOrderModel *model = [_dataModel objectAtIndex:section];
        return model.records.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WwToyOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:kWwToyOrderCell forIndexPath:indexPath];
    
    NSInteger realIndex = indexPath.row;
    WwWawaOrderModel *model = [_dataModel objectAtIndex:indexPath.section];
    
    if (realIndex < model.records.count) {
        [cell reloadDataWithModel:model.records[realIndex]];
    }
    
    if (indexPath.row == model.records.count - 1) {
        [cell setSeparatorVisible:NO];
    }
    
    [cell setNeedsUpdateConstraints];
    
    return cell;
}


#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section >= _dataModel.list.count) {
        return;
    }
    NSInteger realIndex = indexPath.row;
    WwWawaOrderModel *model = [_dataModel objectAtIndex:indexPath.section];
    WwWawaOrderItem *item;
    if (realIndex < model.records.count) {
        item = model.records[realIndex];
    }
    
    [WwToyCheckView showToyCheckViewWithWawa:item];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    return ToyOrderCellRowHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return HeightOfToyDeliverFooter;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    WwWawaOrderModel *model = [_dataModel objectAtIndex:section];
    WwToyDeliverFooter *view = [WwToyDeliverFooter createWithStyle:(ToyDeliverFooterStyle)model.status];
    view.section = section;
    view.delegate = self;
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return HeightOfToyDeliverHeader;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    WwWawaOrderModel *model = self.dataModel.list[section];
    WwToyDeliverHeader *view = [WwToyDeliverHeader createWithStyle:(ToyDeliverHeaderStyle)model.status];
    [view reloadWithData:model];
    return view;
}

#pragma mark - ToyDeliverFooterDelegate
- (void)onDeliverFooterAction:(DeliverFooterAction)action withSection:(NSInteger)section {
    if (action == DeliverFooterAction_LeftAction) {
        // TODO:
    }
    else if (action == DeliverFooterAction_RightAction) {
        WwWawaOrderModel *model = self.dataModel.list[section];
        if (model.status == 0) { // 准备中
            // Note:发货准备中使用orderIds
            NSDictionary *para = @{@"orderIds":[NSString stringWithFormat:@"%@", model.orderId]};
//            [ZXHttpTask POST:ZYUserWawaExchange parameters:para taskResponse:^(DVLHttpResponse *response) {
//                if (!response.code) {
//                    [self.dataModel fetchData];
//                    [[NSNotificationCenter defaultCenter] postNotificationName:NotiRefreshExchangeList object:nil];
//                }
//            }];
        }
        else if (model.status == 1) { // 运送中
            NSDictionary *para = @{@"orderId":[NSString stringWithFormat:@"%@", model.orderId]};
//            @strongify(self);
//            [ZXHttpTask POST:ZYUserWawaReceived parameters:para taskResponse:^(DVLHttpResponse *response) {
//                if (!response.code) {
//                    [self.dataModel fetchData];
//                }
//            }];
        }
    }
}
@end
