//
//  WwWawaParticularsTableViewController.m
//  prizeClaw
//


#import "WwWawaParticularsTableViewController.h"
#import "WwWawaParticularsModel.h"
#import "WwWawaParticularsCell.h"
#import "WwWawaParticularsHeaderView.h"
#import "WwWawaParticularsInfo.h"
#import "SDPhotoBrowser.h"

static CGFloat tableViewHeade = 130;
@interface WwWawaParticularsTableViewController ()<SDPhotoBrowserDelegate>
@property (nonatomic, strong) WwWawaParticularsModel *wawaRecordListModel;
@property (nonatomic, strong) WwWawaParticularsHeaderView *wawaParticularsHeaderView;
@end

@implementation WwWawaParticularsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    [self createHeaderView];
    [self.wawaRecordListModel fetchDataWithWawaId:kShareM.curRoomM.wawa.ID];
    self.tableView.bounces = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    UINib *cellNib = [UINib nibWithNibName:@"WwWawaParticularsCell" bundle:nil];
    [self.tableView registerNib:cellNib forCellReuseIdentifier:@"WwWawaParticularsCellReuseIdentifier"];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self countWithData:self.wawaRecordListModel.dataSouce.lastObject].count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 192;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WwWawaParticularsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WwWawaParticularsCellReuseIdentifier" forIndexPath:indexPath];
    
    NSArray *contents = [self countWithData:self.wawaRecordListModel.dataSouce.lastObject];
    if (indexPath.row < contents.count) {
        [cell wawaParticularsCellImageName:contents[indexPath.row]];
        
        __weak typeof(self) weakSelf = self;
        cell.tapClick = ^{
            [weakSelf showPhotoBrowserWithIndex:indexPath.row];
        };
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}
- (void)showPhotoBrowserWithIndex:(NSInteger)index {
    NSArray *contents = [self countWithData:self.wawaRecordListModel.dataSouce.lastObject];
    
    SDPhotoBrowser *photoBrowser = [SDPhotoBrowser new];
    photoBrowser.delegate = self;
    photoBrowser.currentImageIndex = index;
    photoBrowser.imageCount = contents.count;
    photoBrowser.sourceImagesContainerView = self.tableView;
    [photoBrowser show];
}
// 返回高质量图片的url
- (NSURL *)photoBrowser:(SDPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index {
    
    NSArray *contents = [self countWithData:self.wawaRecordListModel.dataSouce.lastObject];
    NSString *urlStr = [contents safeObjectAtIndex:index];
    return [NSURL URLWithString:realString(urlStr)];
}

- (void)createHeaderView {
    CGFloat height = tableViewHeade;
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(12, 0, ScreenWidth - 24, height)];
    headerView.backgroundColor = [UIColor clearColor];
    self.wawaParticularsHeaderView.frame = headerView.bounds;
    [headerView addSubview:self.wawaParticularsHeaderView];
    self.tableView.tableHeaderView = headerView;
}

- (void)wawaParticularsData:(id)dataModel {
    [self.wawaParticularsHeaderView wawaParticularsHeaderViewWithData:[[dataModel dataSouce] lastObject]];
    [self.tableView reloadData];
}

- (NSArray *)countWithData:(WwWawaParticularsInfo *) info {
    if (!info) {
        return @[];
    }
    return [info.detailPics componentsSeparatedByString:@","];
}

- (WwWawaParticularsModel *)wawaRecordListModel {
    if (!_wawaRecordListModel) {
        _wawaRecordListModel = [[WwWawaParticularsModel alloc] init];
        _wawaRecordListModel.ownerVC = self;
    }
    return _wawaRecordListModel;
}

- (WwWawaParticularsHeaderView *)wawaParticularsHeaderView {
    if (!_wawaParticularsHeaderView) {
        _wawaParticularsHeaderView = [WwWawaParticularsHeaderView shared];
    }
    return _wawaParticularsHeaderView;
}

@end
