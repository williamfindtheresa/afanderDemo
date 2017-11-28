//
//  WwToyCheckingViewController.m
//  prizeClaw
//


#import <Foundation/Foundation.h>
#import "WwToyCheckingViewController.h"
#import "WwDataModel.h"
#import "WwToyCheckingCell.h"
#import "WwToyCheckView.h"
#import "WwToyManageViewController.h"
#import "WwToyManagePanel.h"
#import <WawaSDK/WawaSDK.h>
#import "WawaKitConstants.h"
#import "MJRefresh.h"


@interface WwToyCheckingDataModel : WwDataModel
@property (nonatomic, assign) NSInteger totalCount;
@end

@implementation WwToyCheckingDataModel
- (void)dealloc {

}

- (BOOL)emptyData {
    return _totalCount == 0;
}

- (void)asyncFetchListAtPage:(NSInteger)pageIndex isRefresh:(BOOL)isRefresh withComplete:(void (^)(BOOL, NSArray *, NSInteger, long long))complete {
    [[WwUserInfoManager UserInfoMgrInstance] requestUserWawaList:WawaList_Deposit withCompleteHandler:^(int code, NSString *message, WwUserWawaModel *model) {
        if (!code) {
            if (complete) {
                complete(YES, model.depositList, model.depositList.count, NSIntegerMax);
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


@interface WwToyCheckingViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) WwToyCheckingDataModel * dataModel;

@end

@implementation WwToyCheckingViewController

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
    _dataModel = [[WwToyCheckingDataModel alloc] init];
    _dataModel.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.backgroundColor = RGBCOLOR(250, 250, 250);
    [self.tableView registerClass:[WwToyCheckingCell class] forCellReuseIdentifier:kWwToyCheckingCell];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView setContentInset:UIEdgeInsetsMake(0, 0, HeightOfToyManagePanel, 0)];
    
    __weak __typeof(self) weakself = self;
    MJRefreshNormalHeader * header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakself refreshList];
    }];
    self.tableView.mj_header = header;
    // set title
    [header setTitle:@"下拉翻页" forState:MJRefreshStateIdle];
    [header setTitle:@"松手翻页" forState:MJRefreshStatePulling];
    [header setTitle:@"Loading" forState:MJRefreshStateRefreshing];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
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
        NSString *title;
        BOOL toyManageVisible = NO;
        if (self.dataModel.count) {
            title = [NSString stringWithFormat:@"寄存中(%zi)", self.dataModel.count];
            toyManageVisible = YES;
        }
        else {
            title = [NSString stringWithFormat:@"寄存中"];
        }
        NSDictionary *dict = @{@"index":@0, @"title":title};
        [[NSNotificationCenter defaultCenter] postNotificationName:NotiRefreshSegmentTitle object:dict];
        
        NSDictionary *visDict = @{@"visible":@(toyManageVisible)};
        [[NSNotificationCenter defaultCenter] postNotificationName:NotiToyManagePanelVisible object:visDict];
        self.selectCount = 0;
    }
}

#pragma mark - Public Methods
- (void)refreshList {
    [_dataModel refreshData];
}

- (void)fetchMore {
    [_dataModel fetchMore];
}

- (void)setAllSelect:(BOOL)select {
    NSArray *array = self.dataModel.list;
    NSInteger numOfSelected = 0;
    for (int i=0; i<array.count; ++i) {
        WwWawaDepositModel *item = array[i];
        if ([item isKindOfClass:[WwWawaDepositModel class]]) {
            item.selected = select;
            
            if (item.selected) {
                numOfSelected += 1;
            }
        }
    }
    self.selectCount = numOfSelected;
    [self.tableView reloadData];
}

- (NSArray <WwWawaDepositModel *> *)selectToyList {
    NSMutableArray *array = [@[] mutableCopy];
    for (int i=0; i<self.dataModel.count; ++i) {
        WwWawaDepositModel *model = [self.dataModel objectAtIndex:i];
        if (model.selected) {
            [array addObject:model];
        }
    }
    return array;
}

#pragma mark - WwDataModelDelegate
- (void)onDataModelRefresh:(WwDataModel *)dataModel {
    [self.tableView.mj_header endRefreshing];
    [self.tableView reloadData];
}

- (void)onDataModelFetchMore:(WwDataModel *)dataModel {
    if (_dataModel == dataModel) {
        if (_dataModel.addPageObjects.count > 0) {
            [self.tableView reloadData];
        }
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataModel.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WwToyCheckingCell *cell = [tableView dequeueReusableCellWithIdentifier:kWwToyCheckingCell forIndexPath:indexPath];
    
    NSInteger realIndex = indexPath.row;
    
    if (_dataModel.count > 0 && realIndex < _dataModel.count) {
        WwWawaDepositModel *data = [_dataModel objectAtIndex:indexPath.row];
        [cell setTag:indexPath.row];
        [cell reloadDataWithModel:data];
        
        @weakify(self);
        [cell cellSelectedWithBlock:^(BOOL select) {
            @strongify(self);
            if (select) {
                self.selectCount += 1;
            }
            else {
                self.selectCount -= 1;
            }
        }];
    }
    
    [cell setNeedsUpdateConstraints];
    
    return cell;
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
    return ToyCheckingCellRowHeight;
}

#pragma mark - Getter
- (NSInteger)totalCount {
    return _dataModel.count;
}

#pragma mark - Setter
- (void)setSelectCount:(NSInteger)count {
    _selectCount = count;
    NSInteger total = _dataModel.count;
    [[NSNotificationCenter defaultCenter] postNotificationName:NotiToyManagePanelSelectChange object:@{@"selectCount":@(count), @"total":@(total)}];
}

@end
