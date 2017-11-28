//
//  ZYWawaRecordListTableViewController.m
//  WawaSDKDemo
//
//

#import "ZYWawaRecordListTableViewController.h"
#import "ZYWawaRecordListModel.h"
#import "ZYWawaRecordListCell.h"


@interface ZYWawaRecordListTableViewController ()<UIScrollViewDelegate>

@property (nonatomic, strong) ZYWawaRecordListModel *wawaRecordListModel;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) BOOL needMockLoad;


@end

@implementation ZYWawaRecordListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.page = 1;
    self.tableView.bounces = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    UINib *cellNib = [UINib nibWithNibName:@"ZYWawaRecordListCell" bundle:nil];
    [self.tableView registerNib:cellNib forCellReuseIdentifier:@"ZYWawaRecordListCellReuseIdentifier"];
    UINib *bottomCellNib = [UINib nibWithNibName:@"ZYBottomTableViewCell" bundle:nil];
    [self.tableView registerNib:bottomCellNib forCellReuseIdentifier:@"ZYBottomTableViewCellReuseIdentifier"];
    
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
    ZYWawaRecordListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZYWawaRecordListCellReuseIdentifier" forIndexPath:indexPath];
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
- (ZYWawaRecordListModel *)wawaRecordListModel {
    if (!_wawaRecordListModel) {
        _wawaRecordListModel = [[ZYWawaRecordListModel alloc] init];
        _wawaRecordListModel.ownerVC = self;
    }
    return _wawaRecordListModel;
}

//第一次请求 和 下拉刷新数据返回
- (void)dataChange:(id)dataModel
{
    if (dataModel == self.wawaRecordListModel) {
        [self.tableView reloadData];
//        [self.tableView.mj_header endRefreshing];
        
        //针对数据控制loading状态
        
        if (self.wawaRecordListModel.responseCode == 0) {
            
        }
        else {
            
        }
    }
    else if (dataModel == self.wawaRecordListModel) {
        [self.tableView reloadData];
        self.needMockLoad = YES;
    }
}

//加载更多数据返回
- (void)dataFetchMoreChange:(ZYWawaRecordListModel * )dataModel
{
    if (dataModel == self.wawaRecordListModel) {
        if (!dataModel.addedArr || [dataModel.addedArr isKindOfClass:[NSArray class]]) {
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


#pragma mark - DVL
- (void)onCustomTapInfoView
{
    
}

@end
