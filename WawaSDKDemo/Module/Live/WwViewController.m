//
//  WwViewController.m
//  WawaSDKDemo
//

#import "WwViewController.h"
#import "WwAudienceCell.h"
#import "ZYPlayOperationView.h"
#import "ZYCountDownView.h"
#import "ZYMessageBar.h"
#import "ZYGroundManager.h"
#import "WwToyCheckView.h"
#import "ZYWawaRecordListSuperViewController.h"

#define kCellWidth 40

@interface WwViewController () <WwGameManagerDelegate, UICollectionViewDataSource, UICollectionViewDelegate, ZYPlayOperationViewDelegate, ZYMessageBarDelegate>

@property (weak, nonatomic) IBOutlet UIView *streamBaseV;           /**< 视频流播放视图父视图*/

@property (weak, nonatomic) IBOutlet UIView *watchBaseV;            /**< 观众上机父视图*/

@property (weak, nonatomic) IBOutlet UIButton *startBtn;            /**< 开始游戏按钮*/

@property (nonatomic, strong) ZYPlayOperationView *playOperationBar;/**< 游戏操作视图*/

@property (nonatomic, strong) ZYCountDownView *countDownV;          /**< 倒计时视图*/

@property (nonatomic, strong) ZYMessageBar * messageBar;            /**< 聊天*/

@property (nonatomic, strong) ZYGroundManager *groundManage;        /**< 弹幕*/

@property (nonatomic, strong) UIView *playerV;                      /**< 播放视图*/

@property (nonatomic, strong) UICollectionView *collectV;           /**< 围观列表*/

@property (nonatomic, strong) NSMutableArray *mUsers;               /**< 围观人数据列表*/

@end

@implementation WwViewController

#pragma mark - Life Cycles
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.navigationController.tabBarController) {
        UITabBarController *tabVC = self.navigationController.tabBarController;
        tabVC.tabBar.hidden = YES;
    }
    self.navigationController.navigationBarHidden = YES;
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
    // Do any additional setup after loading the view from its nib.
    self.navigationController.navigationBarHidden = YES;
    
    // 添加倒计时视图
    [self.view addSubview:self.countDownV];
    
    [WwGameManager GameMgrInstance].delegate = self;
    
    self.playerV = [[WwGameManager GameMgrInstance] enterRoomWith:self.model];
    if (self.playerV) {
        [self.playerV setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin];
        [self.streamBaseV insertSubview:self.playerV atIndex:0];
    } else {
        // 进入房间失败了
        UIAlertController * alertVC = [UIAlertController alertControllerWithTitle:nil message:@"进入房间失败" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self closeAction:nil];
        }];
        [alertVC addAction:action];
        [self.navigationController presentViewController:alertVC animated:YES completion:nil];
    }
    
    [self.view addSubview:self.messageBar];
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [self.streamBaseV addGestureRecognizer:tap];
    
    [self.streamBaseV addSubview:[self barrageV]];
    
    [[WwGameManager GameMgrInstance] enablePing:YES];
}


#pragma mark - Action
- (void)tapAction:(UITapGestureRecognizer *)sender {
    if (self.messageBar.isFirstResponder) {
        [self.messageBar closeKeyboard];
    }
}

- (IBAction)startAction:(id)sender {
    if (!self.playOperationBar.superview) {
        [self.view addSubview:self.playOperationBar];
    }
    self.playOperationBar.hidden = YES;
    // 上机按钮
    @weakify(self);
    [[WwGameManager GameMgrInstance] requestOnBoard:self.model.ID complete:^(BOOL success, NSInteger code, NSString *msg, NSString * orderID) {
        dispatch_async(dispatch_get_main_queue(), ^{
            @strongify(self);
            self.watchBaseV.hidden = success;
            self.playOperationBar.hidden = !success;
            
            if (success) {
                self.countDownV.hidden = NO;
                [self.countDownV updateProgressTimer:30];
            } else {
                UIAlertController * alertVC = [UIAlertController alertControllerWithTitle:@"上机结果"
                                                                                  message:msg
                                                                           preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction * action = [UIAlertAction actionWithTitle:@"确定"
                                                                  style:UIAlertActionStyleDefault
                                                                handler:nil];
                [alertVC addAction:action];
                [self.navigationController presentViewController:alertVC
                                                        animated:YES
                                                      completion:nil];
            }
        });
    }];
}

- (IBAction)exchangeStreamAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    [[WwGameManager GameMgrInstance] cameraSwitchIsFront:!sender.selected];
    self.playOperationBar.cameraDir = sender.selected ? CameraDirection_Right : CameraDirection_Front;
}

- (IBAction)closeAction:(id)sender {
    [[WwGameManager GameMgrInstance] destoryRoom];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)chatAction:(id)sender {
    [self.messageBar showKeyboard];
}

- (IBAction)detailAction:(id)sender {
    [WwToyCheckView showToyCheckViewWithWawa:self.model.wawa];
}

- (IBAction)historyAction:(id)sender {
    ZYWawaRecordListSuperViewController * recordListVC = [[ZYWawaRecordListSuperViewController alloc] init];
    recordListVC.wawaRecordListVc.roomID = self.model.ID;
    [self.navigationController pushViewController:recordListVC animated:YES];
}

#pragma mark - GameManagerDelegate
- (void)onGameManagerError:(UserInfoError)error {
    NSLog(@"Avatar delegate %s",__FUNCTION__);
}

/**< 房间观众列表变更回调*/
- (void)audienceListDidChanged:(NSArray <WwUserModel *>*)array {
    NSLog(@"Avatar delegate %s",__FUNCTION__);
}

/**< 远端聊天回调*/
- (void)reciveRemoteMsg:(WwChatModel *)chatM {
    NSLog(@"Avatar delegate %s",__FUNCTION__);
    GrounderModel * model = [GrounderModel new];
    model.chatModel = chatM;
    model.name = chatM.user.nickname;
    model.message = chatM.msg;
    [self.groundManage reciveBarrage:model];
}

- (void)onMasterStreamReady {
    NSLog(@"Avatar delegate %s",__FUNCTION__);
//    CGFloat width = CGRectGetWidth(self.playerV.frame);
//    width *= 0.5;
//    CGFloat height = width * (4/3.0);
//    safe_async_main(^{
//        self.playerV.frame = CGRectMake(0, 0, width, height);
//    });
}

- (void)onSlaveStreamReady {
    NSLog(@"Avatar delegate %s",__FUNCTION__);
}

- (void)reciveWatchNumber:(NSInteger)number {
    NSLog(@"Avatar delegate %s",__FUNCTION__);
}

- (void)reciveRoomUpdateData:(WwRoomLiveData *)liveData {
    NSLog(@"Avatar delegate %s",__FUNCTION__);
}

- (void)reciveClawResult:(WwClawResult *)result {
    NSLog(@"Avatar delegate %s",__FUNCTION__);
}

- (void)reciveGlobleMessage:(WwGlobalNotify *)notify {
    NSLog(@"Avatar delegate %s",__FUNCTION__);
}

- (void)avatarTtlDidChanged:(NSInteger)ttl {
    NSLog(@"Avatar delegate %s",__FUNCTION__);
}

#pragma mark - ZYPlayOperationViewDelegate
- (void)onPlayDirection:(PlayDirection)direction operationType:(PlayOperationType)type {
    NSMutableString *string = [NSMutableString stringWithFormat:@"单击事件，"];
    switch (type) {
        case PlayOperationType_LongPress:
            string = [NSMutableString stringWithFormat:@"长压事件，"];
            break;
        case PlayOperationType_Click:
            string = [NSMutableString stringWithFormat:@"单击事件，"];
            break;
        case PlayOperationType_Release:
            string = [NSMutableString stringWithFormat:@"释放事件，"];
            break;
        case PlayOperationType_Reverse:
            string = [NSMutableString stringWithFormat:@"撤销事件，"];
            break;
        default:
            break;
    }
    
    switch (direction) {
        case PlayDirection_Up: {
            [string appendString:@"方向 ↑"];
        }
            break;
        case PlayDirection_Down: {
            [string appendString:@"方向 ↓"];
        }
            break;
        case PlayDirection_Left: {
            [string appendString:@"方向 ←"];
        }
            break;
        case PlayDirection_Right: {
            [string appendString:@"方向 →"];
        }
            break;
        case PlayDirection_Confirm: {
            [string appendString:@"下抓"];
        }
            break;
        default:
            break;
    }
    
    if (direction == PlayDirection_Confirm) {
        [self clawAction];
    } else {
        [[WwGameManager GameMgrInstance] requestOperation:direction
                                            operationType:type
                                                 complete:^(BOOL success, NSInteger code, NSString *msg) {
                                                     NSString * result = [NSString stringWithFormat:@"%@ %@",string,success ? @"成功" : @"失败"];
                                                     NSLog(@"WwSDKOperation:%@",result);
                                                     
                                                 }];
    }
}

- (void)clawAction {
    self.countDownV.status = ZYCountDownStatusRequestResultIng;
    [[WwGameManager GameMgrInstance] requestClawWithForceRelease:NO
                                                        complete:^(BOOL requestSuccess, NSInteger code, WwGameResultModel *resultM) {
                                                            NSString * str;
                                                            if (resultM.state == 2) {
                                                                str = [NSString stringWithFormat:@"您抓中了%@,恭喜!",resultM.wawa.name];
                                                            } else {
                                                                str = [NSString stringWithFormat:@"没有抓中心爱的%@,下次好运",resultM.wawa.name];
                                                            }
                                                            UIAlertController * alertVC = [UIAlertController alertControllerWithTitle:@"抓取结果"
                                                                                                                              message:str
                                                                                                                       preferredStyle:UIAlertControllerStyleAlert];
                                                            UIAlertAction * action = [UIAlertAction actionWithTitle:@"确定"
                                                                                                              style:UIAlertActionStyleDefault
                                                                                                            handler:nil];
                                                            [alertVC addAction:action];
                                                            [self.navigationController presentViewController:alertVC
                                                                                                    animated:YES
                                                                                                  completion:nil];
                                                            safe_async_main((^{
                                                                self.countDownV.status = ZYCountDownStatusCountDown;
                                                                self.countDownV.hidden = YES;
                                                                self.watchBaseV.hidden = NO;
                                                                self.playOperationBar.hidden = YES;
                                                            }));
                                                        }];
}

#pragma mark - ZYCountDownViewDelegate
- (void)zyTimerFinish {
    [self clawAction];
}

#pragma mark - ZYMessageBarDelegate
- (void)messageBar:(ZYMessageBar *)bar sendMessage:(NSString *)message {
    [[WwGameManager GameMgrInstance] sendDamuMsg:message];
}

#pragma mark - UICollectionView
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.mUsers.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    WwAudienceCell * cell = [collectionView  dequeueReusableCellWithReuseIdentifier:@"WwAudienceCell" forIndexPath:indexPath];
    cell.tag = indexPath.row+1001;
    
    WwUserModel *user;
    if (indexPath.row < self.mUsers.count) {
        user = [self.mUsers objectAtIndex:indexPath.row];
    }
    
    cell.user = user;
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark - Setter
- (void)setModel:(WwRoomModel *)model {
    if (_model == model) {
        return;
    }
    _model = model;
    self.groundManage.roomID = model.ID;
}

#pragma mark - Getter
- (UICollectionView *)collectV {
    if (!_collectV) {
        UICollectionViewFlowLayout * flowlayout = [[UICollectionViewFlowLayout alloc] init];
        flowlayout.itemSize = (CGSize){kCellWidth,kCellWidth};
        flowlayout.minimumLineSpacing = 5;
        flowlayout.minimumInteritemSpacing = 1;
        [flowlayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        
        _collectV = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, 100, kCellWidth) collectionViewLayout:flowlayout];
        _collectV.dataSource = self;
        _collectV.delegate = self;
        _collectV.backgroundView = nil;
        _collectV.backgroundColor = [UIColor clearColor];
        _collectV.showsHorizontalScrollIndicator = NO;
        [_collectV registerClass:[WwAudienceCell class] forCellWithReuseIdentifier:@"ZYAudienceCell"];
    }
    return _collectV;
}

- (ZYPlayOperationView *)playOperationBar {
    if (!_playOperationBar) {
        _playOperationBar = [ZYPlayOperationView operationView];
        _playOperationBar.hidden = NO;
        CGFloat height = ScreenHeight - ScreenWidth*(4/3.0) + 10;
        _playOperationBar.backgroundColor = [UIColor clearColor];
        CGRect rect = CGRectMake(0, ScreenHeight - height, ScreenWidth, height);
        _playOperationBar.frame = rect;
        _playOperationBar.delegate = self;
    }
    return _playOperationBar;
}

// 倒计时
- (UIView *)countDownV {
    if (!_countDownV) {
        _countDownV = [[ZYCountDownView alloc] init];
        CGRect rect;
        rect.size = CGSizeMake(40, 40);
        rect.origin.y = ScreenHeight - 188 - CGRectGetHeight(rect);
        rect.origin.x = ScreenWidth - 12 - CGRectGetWidth(rect);
        _countDownV.frame = rect;
        _countDownV.backgroundColor = [UIColor clearColor];
        _countDownV.hidden = YES;
    }
    return _countDownV;
}

- (ZYMessageBar *)messageBar
{
    if (!_messageBar) {
        CGRect rect = (CGRect){0,ScreenHeight,ScreenWidth,47};
        _messageBar = [[ZYMessageBar alloc] initWithFrame:rect];
        _messageBar.hidden = YES;
        _messageBar.delegate = self;
    }
    return _messageBar;
}

- (ZYGroundManager *)groundManage {
    if (!_groundManage) {
        _groundManage = [[ZYGroundManager alloc] init];
    }
    return _groundManage;
}

#pragma mark - Getter Helper
// 弹幕
- (UIView *)barrageV {
    UIView *view = [self.groundManage barrageSuperView];
    view.frame = CGRectMake(0, 100, ScreenWidth, 90);
    view.backgroundColor = [UIColor clearColor];
    view.clipsToBounds = YES;
    return view;
}

@end
