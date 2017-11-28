//
//  WwGameRecordViewController.m
//  WawaSDKDemo
//

#import <Foundation/Foundation.h>
#import "WwGameRecordViewController.h"
#import "WwGameRecordDataModel.h"
#import "MJRefresh.h"
#import "WwGameRecordCell.h"
#import "WwRecordDatailViewController.h"

@interface WwGameRecordViewController () <UITableViewDelegate, UITableViewDataSource, WwDataModelDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) WwGameRecordDataModel *dataModel;
@end

@implementation WwGameRecordViewController

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initData];
    }
    return self;
}


- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self initData];
    }
    return self;
}

- (void)initData {
    _dataModel = [[WwGameRecordDataModel alloc] init];
    _dataModel.delegate = self;
}

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
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [_tableView registerClass:[WwGameRecordCell class] forCellReuseIdentifier:kWwGameRecordCell];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    __weak __typeof(self) weakself = self;
    MJRefreshNormalHeader * header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakself refreshData];
    }];
    _tableView.mj_header = header;
    // set title
    [header setTitle:@"下拉翻页" forState:MJRefreshStateIdle];
    [header setTitle:@"松手翻页" forState:MJRefreshStatePulling];
    [header setTitle:@"Loading" forState:MJRefreshStateRefreshing];
    
    [self setTitle:@"游戏记录"];
    [self.view addSubview:_tableView];
    
    // 获取数据
    [self.dataModel refreshData];
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

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    WwGameRecordModel * data = (WwGameRecordModel *)[_dataModel objectAtIndex:indexPath.row];
    WwRecordDatailViewController *detailVC = [[WwRecordDatailViewController alloc] initWithGameRecordModel:data];
    [self.navigationController pushViewController:detailVC animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    return HeightOfGameRecordCellWithIndicator;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.1f;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataModel.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WwGameRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:kWwGameRecordCell forIndexPath:indexPath];
    
    NSInteger realIndex = indexPath.row;
    
    if (_dataModel.count > 0 && realIndex < _dataModel.count) {
        id data = [_dataModel objectAtIndex:indexPath.row];
        [cell setTag:indexPath.row];
        [cell reloadDataWithModel:data];
        
        // 触发自动加载
        if (indexPath.row >= _dataModel.count - 7) {
            [self fetchMore];
        }
    }
    cell.indicatorVisible = YES;
    [cell setNeedsUpdateConstraints];
    
    return cell;
}


#pragma mark - Private Methods
- (void)refreshData {
    [_dataModel refreshData];
}

- (void)fetchMore {
    [_dataModel fetchMore];
}


@end
