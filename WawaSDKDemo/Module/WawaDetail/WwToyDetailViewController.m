//
//  WwToyDetailViewController.m
//  F_Sky
//

#import "WwToyDetailViewController.h"
#import "WwToyDetailCell.h"
#import "WwToyDetailHeaderView.h"

#import "WwDataModel.h"
#import <WawaSDK/WwDataDef.h>

@interface WwToyDetailDataModel : WwDataModel
@property (nonatomic, strong) WwWaWaDetailInfo *detailInfo;
@property (nonatomic, assign) NSInteger wid;                      /**< 娃娃id*/
@end

@implementation WwToyDetailDataModel

- (void)asyncFetchListAtPage:(NSInteger)pageIndex isRefresh:(BOOL)isRefresh withComplete:(void (^)(BOOL, NSArray *, NSInteger, long long))complete {
    [[WwGameManager GameMgrInstance] requestWawaInfo:self.wid complete:^(BOOL success, NSInteger code, WwWaWaDetailInfo *waInfo) {
        if (!code) {
            NSMutableArray *array = [@[] mutableCopy];
            if (waInfo) {
                [array addObject:waInfo];
            }
            if (complete) {
                complete(YES, array, 1, NSIntegerMax);
            }
        }
        else {
            if (complete) {
                complete(NO, nil, 0, 0);
            }
        }
        self.detailInfo = waInfo;
        [self setValue:@(code) forKey:kWwDataModelFetchResult];
    }];
}

@end

@interface WwToyDetailViewController ()
@property (nonatomic, strong) WwToyDetailDataModel *dataModel;
@property (nonatomic, strong) WwToyDetailHeaderView *headerView;
@end

@implementation WwToyDetailViewController

- (void)dealloc {
    [self removeObserver];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    [self createHeaderView];

    self.tableView.bounces = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    UINib *cellNib = [UINib nibWithNibName:@"WwToyDetailCell" bundle:nil];
    [self.tableView registerNib:cellNib forCellReuseIdentifier:kToyDetailCellIdentifier];
    
    [self addObserver];
    
    
    // 获取数据
    [self.dataModel refreshData];
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

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self rowCountByDetailInfo:_dataModel.list.firstObject].count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 192;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WwToyDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:kToyDetailCellIdentifier forIndexPath:indexPath];
    
    NSArray *contents = [self rowCountByDetailInfo:_dataModel.list.firstObject];
    if (indexPath.row < contents.count) {
        [cell reloadCellWithImage:contents[indexPath.row]];
    }
    return cell;
}

- (void)createHeaderView {
    CGFloat height = HeightOfDetailHeader;
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(12, 0, ScreenWidth - 24, height)];
    headerView.backgroundColor = [UIColor clearColor];
    self.headerView.frame = headerView.bounds;
    [headerView addSubview:self.headerView];
    
    self.tableView.tableHeaderView = headerView;
}

- (void)wawaParticularsData:(id)dataModel {
    [self.headerView reloadHeaderWithDetailInfo:_dataModel.list.firstObject];
    [self.tableView reloadData];
}

- (NSArray *)rowCountByDetailInfo:(WwWaWaDetailInfo *) info {
    if (!info) {
        return @[];
    }
    return [info.detailPics componentsSeparatedByString:@","];
}

#pragma mark - Getter 
- (WwToyDetailDataModel *)dataModel {
    if (!_dataModel) {
        _dataModel = [[WwToyDetailDataModel alloc] init];
        _dataModel.wid = self.wawa.ID;
    }
    return _dataModel;
}

- (WwToyDetailHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [WwToyDetailHeaderView shared];
    }
    return _headerView;
}

@end
