//
//  WwSelectAddressTableViewController.m
//  F_Sky
//

#import "WwSelectAddressTableViewController.h"
#import "WwAddressTableViewCell.h"
#import "WwUserAddressDataModel.h"

@interface WwSelectAddressTableViewController ()
@property (nonatomic, strong) WwUserAddressDataModel *dataModel;
@end

@implementation WwSelectAddressTableViewController

- (void)dealloc {
    [self removeObserver];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"WwAddressTableViewCell" bundle:nil] forCellReuseIdentifier:kWwAddressTableViewCellIdentifier];
    
    [self customNavigationUI];
    
    [self addObserver];
    // 请求数据
    [self requestAddressList];
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

#pragma mark - Private
- (void)requestAddressList {
    [self.dataModel refreshData];
}

- (void)customNavigationUI {
    self.navigationController.navigationBarHidden = NO;
    self.title = @"选择收货地址";
    
    UIButton * rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setTitle:@"管理" forState:UIControlStateNormal];
    [rightBtn setTitleColor:RGBCOLOR(135, 135, 135) forState:UIControlStateNormal];
    
    CGSize btnSize = CGSizeMake(44, 44);
    CGRect frame = CGRectZero;
    frame.size = btnSize;
    rightBtn.frame = frame;
    
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:15.f];
    [rightBtn addTarget:self action:@selector(managerAddress:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem * rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    [self.navigationItem setRightBarButtonItem:rightItem];
}

#pragma mark - Action
- (void)managerAddress:(id)sender {
//    [ZXRouter pushPage:ZXPageAddressList];
}

- (void)RightBtn {
//    [ZXRouter pushPage:ZXPageAddressList];
}


#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataModel.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 116;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WwAddressTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kWwAddressTableViewCellIdentifier forIndexPath:indexPath];
    cell.operationBaseV.hidden = YES;
    WwAddressModel * model = [self.dataModel objectAtIndex:indexPath.row];
    cell.isDefault = YES;
    cell.model = model;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    WwAddressModel * model = [self.dataModel objectAtIndex:indexPath.row];
//    if ([self.Ww_InitData objectForKey:@"block"]) {
//        void (^block) (ZYUserAddressModel *) = [self.Ww_InitData objectForKey:@"block"];
//        block(model);
//    }
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Getter 
- (WwUserAddressDataModel *)dataModel {
    if (!_dataModel) {
        _dataModel = [[WwUserAddressDataModel alloc] init];
    }
    return _dataModel;
}

@end
