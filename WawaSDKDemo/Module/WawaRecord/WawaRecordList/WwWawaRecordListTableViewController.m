//
//  WwWawaRecordListTableViewController.m
//  prizeClaw
//


#import "WwWawaRecordListTableViewController.h"
#import "WwWawaRecordListModel.h"
#import "WwWawaRecordListCell.h"
#import "DVLViewUtil.h"


@interface WwWawaRecordListTableViewController ()<UIScrollViewDelegate>

@property (nonatomic, strong) WwWawaRecordListModel *wawaRecordListModel;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) BOOL needMockLoad;


@end

@implementation WwWawaRecordListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.page = 1;
    self.tableView.bounces = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    UINib *cellNib = [UINib nibWithNibName:@"WwWawaRecordListCell" bundle:nil];
    [self.tableView registerNib:cellNib forCellReuseIdentifier:@"WwWawaRecordListCellReuseIdentifier"];
    UINib *bottomCellNib = [UINib nibWithNibName:@"WwBottomTableViewCell" bundle:nil];
    [self.tableView registerNib:bottomCellNib forCellReuseIdentifier:@"WwBottomTableViewCellReuseIdentifier"];
    [self.wawaRecordListModel fetchData];
}

#pragma mark - UIScrollViewDelegate
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    // 正在滑动 判断是否加载更多
    if (self.wawaRecordListModel.dataSouce.count <= 10) {
        return;
    }
    if (indexPath.row == (self.wawaRecordListModel.dataSouce.count - 5)) {

    }
}

#pragma mark - Tableviewdatasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.wawaRecordListModel.dataSouce.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WwWawaRecordListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WwWawaRecordListCellReuseIdentifier" forIndexPath:indexPath];
    NSInteger count = self.wawaRecordListModel.dataSouce.count;
    if (indexPath.row < count) {
        [cell wawaRecordListCellWith:self.wawaRecordListModel.dataSouce[indexPath.row]];
    }
    if (indexPath.row == self.wawaRecordListModel.dataSouce.count - 3) {
        [self fetMore];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 71;
}

- (void)wawaRecordListData:(id)dataModel {
    [self.tableView reloadData];
}

#pragma mark -
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}

#pragma mark - getter
- (WwWawaRecordListModel *)wawaRecordListModel {
    if (!_wawaRecordListModel) {
        _wawaRecordListModel = [[WwWawaRecordListModel alloc] init];
        _wawaRecordListModel.ownerVC = self;
    }
    return _wawaRecordListModel;
}

//第一次请求 和 下拉刷新数据返回
- (void)dataChange:(id)dataModel
{
    if (dataModel == self.wawaRecordListModel) {
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
        
        //针对数据控制loading状态
        
    }
    else if (dataModel == self.wawaRecordListModel) {
        [self.tableView reloadData];
        self.needMockLoad = YES;
    }
}

//加载更多数据返回
- (void)dataFetchMoreChange:(WwWawaRecordListModel * )dataModel
{
    if (dataModel == self.wawaRecordListModel) {
        if (!dataModel.addedArr.count) {
            return;
        }
        
        NSInteger sourceLen = dataModel.dataSouce.count;
        NSInteger addLen = dataModel.addedArr.count;
        NSInteger addLocation  = sourceLen - addLen;
        if (addLocation > 0) {
            [self.tableView reloadData];
        }
        
    }
}

#pragma mark - Helper
- (void)refreshData
{
    //下拉刷新
    [self.wawaRecordListModel  refreshData];
}

- (void)fetMore //下拉加在更多
{
    [self.wawaRecordListModel fetchMore];
}

- (void)onCustomTapInfoView
{
    [self.wawaRecordListModel fetchData];
}

@end
