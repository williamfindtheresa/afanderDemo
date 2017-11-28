//
//  WwToyDepositViewController.m
//  WawaSDKDemo
//
//

#import <Foundation/Foundation.h>
#import "WwToyDepositViewController.h"
#import "WwDataModel.h"
#import "WwToyDepositCell.h"
#import "WwToyManageViewController.h"
#import "WwToyManagePanel.h"
#import "WawaKitConstants.h"
#import "MJRefresh.h"

@interface WwToyDepositDataModel : WwDataModel
@property (nonatomic, assign) NSInteger totalCount;
@end

@implementation WwToyDepositDataModel

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


@interface WwToyDepositViewController () <UITableViewDelegate,UITableViewDataSource, WwDataModelDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) WwToyDepositDataModel * dataModel;
@end

@implementation WwToyDepositViewController

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
    _dataModel = [[WwToyDepositDataModel alloc] init];
    _dataModel.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [_tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.backgroundColor = RGBCOLOR(250, 250, 250);
    [_tableView registerClass:[WwToyDepositCell class] forCellReuseIdentifier:kWwToyDepositCell];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView setContentInset:UIEdgeInsetsMake(0, 0, HeightOfToyManagePanel, 0)];
    
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

#pragma mark - Observer
- (void)removeObserver {
    [self.dataModel removeObserver:self forKeyPath:kWwDataModelFetchResult];
}

- (void)addObserver {
    [self.dataModel addObserver:self forKeyPath:kWwDataModelFetchResult options:NSKeyValueObservingOptionNew context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
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
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataModel.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WwToyDepositCell *cell = [tableView dequeueReusableCellWithIdentifier:kWwToyDepositCell forIndexPath:indexPath];
    
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
    WwToyDepositCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell) {
        self.selectCount += (cell.isSelected? -1: 1);
        
        [cell setCellSelected:!cell.isSelected];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    return ToyDepositCellRowHeight;
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
