//
//  WwHomeViewController.m
//  F_Sky
//

#import "WwHomeViewController.h"

#import "WwLatestLiveCell.h"
#import "WwLiveViewController.h"
#import "RoomListDataModel.h"
#import "MJRefresh.h"

@interface WwHomeViewController ()
<UICollectionViewDelegate,
UICollectionViewDataSource,
WwDataModelDelegate>

@property (nonatomic, strong) WwRoomListManager *roomMgr;
@property (nonatomic, strong) RoomListDataModel *dataModel;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, assign) BOOL passValidity;
@end

@implementation WwHomeViewController

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
        
    }
    return self;
}

- (void)initData {
    _roomMgr = [WawaSDK WawaSDKInstance].roomListMgr;
    _dataModel = [[RoomListDataModel alloc] init];
    self.dataModel = [RoomListDataModel new];
    self.dataModel.delegate = self;
}

- (void)initUI {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    _collectionView = [[UICollectionView alloc] initWithFrame:(CGRect){0,0,ScreenWidth,ScreenHeight} collectionViewLayout:layout];
    _collectionView.backgroundColor = [UIColor whiteColor];
    
    layout.itemSize = CGSizeMake(ScreenWidth/2.0,182);
    layout.estimatedItemSize = CGSizeZero;
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;

    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    
    UINib *cellNib = [UINib nibWithNibName:@"WwLatestLiveCell" bundle:nil];
    [_collectionView registerNib:cellNib forCellWithReuseIdentifier:@"WwLatestLiveCell"];
    
    __weak __typeof(self) weakself = self;
    MJRefreshNormalHeader * header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakself refreshData];
    }];
    _collectionView.mj_header = header;
    // set title
    [header setTitle:@"下拉翻页" forState:MJRefreshStateIdle];
    [header setTitle:@"松手翻页" forState:MJRefreshStatePulling];
    [header setTitle:@"Loading" forState:MJRefreshStateRefreshing];
    
    [self setTitle:@"房间列表"];
    [self.view addSubview:_collectionView];
}

#pragma mark - Life Cycles

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    [self refreshData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sdkPassValidity) name:kSDKNotifyKey object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

#pragma mark - Public

- (void)sdkPassValidity
{
    self.passValidity = YES;
    [self.dataModel refreshData];
    
    //may be you can login
    [self loginUser];
}

- (void)loginUser
{
    if (self.passValidity == NO) {
        return;
    }
    //必须等到鉴权成功之后调用
    [[WawaSDK WawaSDKInstance].userInfoMgr loginUserWithCompleteHandler:^(int code, NSString *message) {
        
    }];
}

#pragma mark - WwDataModelDelegate
- (void)onDataModelRefresh:(WwDataModel *)dataModel {
    [_collectionView.mj_header endRefreshing];
    [_collectionView reloadData];
}

- (void)onDataModelFetchMore:(WwDataModel *)dataModel {
    if (_dataModel == dataModel) {
        if (_dataModel.addPageObjects.count > 0) {
            [self.collectionView reloadData];
        }
    }
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    // 进入游戏房间
    WwRoomModel * model = [_dataModel objectAtIndex:indexPath.row];
    WwLiveViewController *wwVC = [WwLiveViewController new];
    wwVC.room = model;
    UINavigationController * navVC = [[UINavigationController alloc] initWithRootViewController:wwVC];
    [self.navigationController presentViewController:navVC animated:YES completion:nil];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _dataModel.list.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    WwLatestLiveCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"WwLatestLiveCell" forIndexPath:indexPath];
    
    id data = [_dataModel objectAtIndex:indexPath.row];
    [cell loadWithData:data itemIndex:indexPath.row];
    
    return cell;
}


#pragma mark - Action
- (IBAction)onLoginBtnAction:(UIButton *)sender {
    
}

#pragma mark - Private Methods
- (void)refreshData {
    [_dataModel refreshData];
}

- (void)fetchMore {
    [_dataModel fetchMore];
}

@end
