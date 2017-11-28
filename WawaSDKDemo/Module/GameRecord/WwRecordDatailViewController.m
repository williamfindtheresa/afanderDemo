//
//  WwRecordDatailViewController.m
//  WawaSDKDemo
//

#import "WwRecordDatailViewController.h"
#import "WwDataModel.h"
#import "WwRecordPreviewCell.h"
#import "WawaKitConstants.h"

@interface WwRecordDatailViewController ()<UITableViewDelegate, UITableViewDataSource, WwRecordPreviewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) WwGameRecordModel *recordModel;
@end

@implementation WwRecordDatailViewController

- (instancetype)initWithGameRecordModel:(WwGameRecordModel *)record {
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        _recordModel = record;
    }
    return self;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.navigationController.tabBarController) {
        UITabBarController *tabVC = self.navigationController.tabBarController;
        tabVC.tabBar.hidden = YES;
    }
    [self.tableView reloadData];
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
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [_tableView registerClass:[WwRecordPreviewCell class] forCellReuseIdentifier:kWwRecordPreviewCell];
    [_tableView registerClass:[WwRecordDetailCell class] forCellReuseIdentifier:kWwRecordDetailCell];
    _tableView.backgroundColor = RGBCOLOR(250, 250, 250);
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    [self setTitle:@"游戏详情"];
    [self.view addSubview:_tableView];
}

#pragma mark - WwRecordPreviewDelegate
- (void)onRecordPreviewClickAction:(RecordPreviewAction)action {
    switch (action) {
        case RecordPreview_Share:
            // TODO: share
            break;
        case RecordPreview_Play:
            // TODO: play
            break;
        case RecordPreview_Appeal:
            // TODO: appeal
            break;
        default:
            break;
    }
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return HeightOfRecordDetailCell;
    }
    else if (indexPath.section == 1) {
        return HeightOfRecordPreviewCell;
    }
    return 0.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.1f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 0) {
        return 8.f;
    }
    return 0.1f;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    if (indexPath.section == 0) {
        WwRecordDetailCell *detailCell = [tableView dequeueReusableCellWithIdentifier:kWwRecordDetailCell];
        detailCell.delegate = self;
        cell = detailCell;
    }
    else if (indexPath.section == 1) {
        WwRecordPreviewCell *previewCell = [tableView dequeueReusableCellWithIdentifier:kWwRecordPreviewCell];
        previewCell.delegate = self;
        cell = previewCell;
    }
    
    if (indexPath.row == 0) {
        [cell setTag:indexPath.row];
        if ([cell respondsToSelector:@selector(reloadDataWithModel:)]) {
            [cell performSelector:@selector(reloadDataWithModel:) withObject:_recordModel afterDelay:0];
        }
    }
    [cell setNeedsUpdateConstraints];
    return cell;
}

@end
