//
//  WwLiveViewController.m
//  prizeClaw
//
//  Created by 刘昊 on 2017/10/1.
//  Copyright © 2017年 QuanMin.ShouYin. All rights reserved.
//

#import "WwLiveViewController.h"

#import "WwLiveInteractiveView.h"
#import "WwPopupsView.h"
#import <AVFoundation/AVFoundation.h>
#import "WwRoomToyExchangeView.h"
#import "WwShareAudioPlayer.h"

#import "NSTimer+EOCBlocksSupport.h"

static NSInteger kMaxRequestOrderCount = 5;


@interface WwLiveViewController ()
<WwWatchOperationViewDelegate,
WwPlayOperationViewDelegate,
WwAudienceStudioViewDelegate,
WwMessageBarDelegate,
WwCountDownViewDelegate,
WwGameResultViewDelegate,
WwGameManagerDelegate>

typedef struct {
    PlayDirection direction; // 方向
    PlayOperationType type; // 操作类型
    int index;  // 操作序号
}PlayOperationRecord;

@property (nonatomic, strong) UIView * rtcBaseV;                                    /**< 游戏流拉取底图*/

@property (nonatomic, strong) UIView *playerView;

@property (nonatomic, strong) UIImageView * statusImgV;                             /**< 补货中*/

@property (nonatomic, assign) PlayOperationRecord lastOperation;

@property (nonatomic, assign) BOOL didClickClose;                                   /**< 点击了关闭按钮*/

@property (nonatomic, assign) BOOL mPlayerOK;
@property (nonatomic, assign) BOOL sPlayerOK;

@property (nonatomic, assign) NSInteger orderRequestCount;                          /**< 延迟请求游戏订单号次数记录*/

@property (nonatomic, strong) NSTimer * delayTimer;                                 /**< 延迟请求订单号定时器*/

@property (nonatomic, strong) WwPopupsView * faultPopupsView;

@end

@implementation WwLiveViewController

- (void)dealloc
{
    [self removeObserver];
    [[WwShareAudioPlayer shareAudioPlayer] stopAllAudioPlayer];
    [[WawaSDK WawaSDKInstance].gameMgr destoryRoom];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    [UIApplication sharedApplication].idleTimerDisabled = YES;
    //进入最近抓中记录页面，打开视频，音乐停止，再次进入直播间，需要重新开启音乐
    if (![[WwShareAudioPlayer shareAudioPlayer] backPlayerIsPlaying]) {
        [self playBackGroundAudio];
    }
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
    [UIApplication sharedApplication].idleTimerDisabled = NO;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = kAppLabelColor;
    
    WwRoomModel *data = self.room;
    kShareM.curRoomM = data;
    kShareM.curRoomID = data.ID;
    self.statusImgV.hidden = data.state != 1;
    
    self.navigationController.navigationBarHidden = YES;
    [self customUI];
    
    self.interV.watchOperationBar.operationDisable = data.state != 2;
    self.interV.watchOperationBar.showTipBtn.hidden = !self.interV.watchOperationBar.operationDisable;
    
    [self playBackGroundAudio];
    [self addObserver];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)addObserver {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stopBackGroundAudio:) name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(startBackGroundAudio:) name:UIApplicationWillEnterForegroundNotification object:nil];

}

- (void)removeObserver {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Notification Handler

- (void)stopBackGroundAudio:(NSNotification *)notify
{
    [[WwShareAudioPlayer shareAudioPlayer] stopBackGroundPlayer];
}

- (void)startBackGroundAudio:(NSNotification *)notify
{
    [self playBackGroundAudio];
}

#pragma mark - Private

- (void)customUI {
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.interV];
    [self.interV.vScrollV insertSubview:self.rtcBaseV atIndex:0];
    [self.interV.vScrollV insertSubview:self.statusImgV aboveSubview:self.rtcBaseV];
    [self.view addSubview:self.interV.gameResultV];
    
    [self.interV.closeBtn addTarget:self action:@selector(closeAction:) forControlEvents:UIControlEventTouchUpInside];
    
    // 初始化rtc流
    [self configRtcPlayer];
    
    // 给游戏结果界面传入房间ID
    WwRoomModel *data = self.room;
    NSInteger owid = data.ID;
    self.interV.gameResultV.roomID = owid;
}


- (void)configRtcPlayer {
    [WwGameManager GameMgrInstance].delegate = self;
    
    
    WwRoomModel* model = (WwRoomModel *)self.room;
    WwRoomModel *roomModel = [WwRoomModel mj_objectWithKeyValues:[model mj_JSONData]];
    self.playerView = [[WwGameManager GameMgrInstance] enterRoomWith:roomModel];
    
    self.playerView.frame = self.rtcBaseV.bounds;
    if (![self.playerView superview]) {
        [self.rtcBaseV addSubview:self.playerView];
    }
}

#pragma mark - Action
- (void)closeAction:(UIButton *)sender {
    // 如果当前正在游戏中, 则提示用户(操作页显示 且 结果页没有在处理结果, 则认为是在游戏中)
    if (!self.interV.playOperationBar.hidden && !self.interV.gameResultV.isResultHandleing) {
        NSInteger owid = [(WwRoomModel *)self.room ID];
        UIAlertController * alertVC = [UIAlertController alertControllerWithTitle:nil message:@"退出房间后,游戏将自动结束" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            self.didClickClose = NO;
        }];
        UIAlertAction * confirm = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            self.didClickClose = YES;
            [self postPlayDirection:PlayDirection_Confirm withType:PlayOperationType_Click withHandler:nil];
            // 关闭当前页面
            [[WwShareAudioPlayer shareAudioPlayer] stopAllAudioPlayer];
            
            if (self.navigationController.presentingViewController) {
                [self.navigationController dismissViewControllerAnimated:YES completion:nil];
            } else {
                [self.navigationController popViewControllerAnimated:YES];
            }
        }];
        [alertVC addAction:cancel];
        [alertVC addAction:confirm];
        [self presentViewController:alertVC animated:YES completion:nil];
        kShareM.curRoomID = 0;
        return;
    }
    // 关闭当前页面
    [[WwShareAudioPlayer shareAudioPlayer] stopAllAudioPlayer];
    if (self.interV.gameResultV.isResultHandleing) {
        NSInteger owid = [(WwRoomModel *)self.room ID];
        [[WwGameManager GameMgrInstance] requestClawWithForceRelease:YES complete:nil];
    }
    
    if (self.navigationController.presentingViewController) {
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
    kShareM.curRoomID = 0;
    kShareM.curRoomM = nil;
}

- (void)rtcExchangeAction {
    BOOL isMaster = self.interV.rtcExchange.selected;
    [[WwGameManager GameMgrInstance] cameraSwitchIsFront:isMaster];
    // 状态记录
    self.interV.playOperationBar.cameraDir = isMaster?CameraDirection_Front: CameraDirection_Right;
    self.interV.rtcExchange.selected = !self.interV.rtcExchange.isSelected;
    
    [[WwShareAudioPlayer shareAudioPlayer] playClickAudioWithFile:@"exchange_push_view" ofType:@"mp3"];
}

#pragma mark - WwWatchOperationViewDelegate
- (void)onChatClicked:(UIButton *)button {
    // chat
    [self.interV openKeyboard];
}

- (void)onShareClicked:(UIButton *)button {
    @weakify(self);
    [[WwGameManager GameMgrInstance] requestSDKServerTime:^(NSTimeInterval timeInter) {
        @strongify(self);
        NSInteger time = timeInter;
        if (time == 0) {
            NSLog(@"请重新获取分享信息");
            return ;
        }
    }];
}


/**
 开始游戏

 @return YES，调用了 开始接口。 NO，根本没到 开始接口的 地方
 */
- (BOOL)onStartClicked:(UIButton *)button {
    // 检验主摄像头有没有 ready
    if (!self.mPlayerOK) {
        NSLog(@"摄像头还未准备好,请等待...");
        return NO;
    }
    // 检验副摄像头有没有 ready
    if (!self.sPlayerOK) {
        NSLog(@"侧面摄像头还未准备好,请等待...");
        return NO;
    }
    
    // start game
    WwRoomModel *data = self.room;
    @weakify(self);
    
    // 开始请求的时候, 先把开始按钮置为不可操作
    self.interV.watchOperationBar.operationDisable = YES;
    [[[WawaSDK WawaSDKInstance] gameMgr] requestOnBoard:data.ID complete:^(BOOL success, NSInteger code, NSString *msg, NSString * orderID) {
        @strongify(self);
        if (code == WwErrorCodeSuccess) {
            NSLog(@"game start success");
            NSString *orderId = [orderID copy];
            data.orderId = orderId;
            [self realStartGame:orderId];
        }
        else {
            if (code == 1) {
                NSLog(@"别的玩家抢先上机啦");
            }
            else {
                NSLog(@"%@",msg);
            }
            [self setHintLabelText:@"没抢到/(ㄒoㄒ)/~~"];
            [self.interV showPlayOperation:NO completion:nil];
            //强制关流
            [self.interV.playerInfoV freshDefaultUIIsSocketNotify:NO];
            // 逻辑处理完成之后再把操作视图置为可操作
            self.interV.watchOperationBar.operationDisable = NO;
        }
    }];
    
    return YES;
}

- (void)onExchangeClicked:(UIButton *)button {
    WwRoomToyExchangeView *view = [WwRoomToyExchangeView instanceToyExchangeView];
    [view showInstanceView];
}

- (void)onBalanceClicked:(UIButton *)button {
    //
}

#pragma mark - Delay orderId logic
- (void)realStartGame:(NSString *)orderId {
    
    if (!realString(orderId).length) {
        return;
    }
    
    WwRoomModel *data = self.room;
    
    if ([realString(data.orderId) isEqualToString:orderId] && !self.interV.playOperationBar.hidden) {
        // 已经处理了游戏开始逻辑, 返回
        return;
    }
    
    data.orderId = orderId;
    NSLog(@"开始上机");
    
    self.interV.playOperationBar.hidden = NO;
    self.interV.gameResultV.orderId = orderId;
    
    [self.interV showPlayOperation:YES completion:^{
        // 逻辑处理完成之后再把操作视图置为可操作
        self.interV.watchOperationBar.operationDisable = NO;
    }];
    self.interV.countDownV.hidden = NO;
    [self.interV.countDownV updateProgressTimer:30];
    
    @weakify(self);
    dispatch_async(dispatch_get_main_queue(), ^{
        @strongify(self);
        self.interV.playerInfoV.orderId = orderId;
//        [self.interV.playerInfoV freshPushStream:pushUrl];
    });
    
    [[WwShareAudioPlayer shareAudioPlayer] playResultAudioWithFile:@"start_game" ofType:@"mp3"];
}


#pragma mark - WwPlayOperationViewDelegate

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
        case PlayDirection_Up:
            [string appendString:@"方向 ↑"];
            break;
        case PlayDirection_Down:
            [string appendString:@"方向 ↓"];
            break;
        case PlayDirection_Left:
            [string appendString:@"方向 ←"];
            break;
        case PlayDirection_Right:
            [string appendString:@"方向 →"];
            break;
        case PlayDirection_Confirm: {
            [string appendString:@"下抓"];
        }
            break;
        default:
            break;
    }
    
    @weakify(self);
    [self postPlayDirection:direction withType:type withHandler:^(bool result, NSString *message, WwGameResultModel *resultModel) {
        @strongify(self);
        NSString *text = [NSString stringWithFormat:@"%@,%@,%@", string, result?@"操作成功":@"操作失败", message];
        [self setHintLabelText:text];
        
        if (direction == PlayDirection_Confirm) {
            WwGameResultModel *gr = [WwGameResultModel mj_objectWithKeyValues:[resultModel mj_JSONObject]];
            [self.interV.gameResultV handleGameResult:gr];
            if (!result) {
                [self endGameAndStopPush];
            }
        }
        
    }];
}

//下抓游戏结果
- (void)postPlayDirection:(PlayDirection)direction withType:(PlayOperationType)type withHandler:(void (^)(bool result, NSString *message, WwGameResultModel *resultModel))handler
{
    if (direction == PlayDirection_Confirm) {
        // 可能有点网络延迟问题
        //倒计时重置等待
        self.interV.countDownV.status = WwCountDownStatusRequestResultIng;
        // Note:如果下抓成功，按键置灰
        [self.interV.playOperationBar setOperationDisable:YES];
        // UI重置
        [self.interV.gameResultV startRequestResult];
        
        BOOL force = (self.didClickClose == YES);
        
        [[WwGameManager GameMgrInstance] requestClawWithForceRelease:force complete:^(BOOL requestSuccess, NSInteger code, WwGameResultModel *resultM) {
            //游戏结果回来了
            if (handler) {
                bool success = requestSuccess;
                handler(success, [NSString stringWithFormat:@"code %zi", code],resultM);
            }
        }];
    }
    else {
        //游戏操作
        [[WwGameManager GameMgrInstance] requestOperation:direction operationType:type complete:^(BOOL success, NSInteger code, NSString *msg) {
            if (handler) {
                handler(success, [NSString stringWithFormat:@"code %zi", code],nil);
            }
        }];
    }
}

- (NSInteger)mapPlayDirection:(PlayDirection)playDirection {
    NSInteger direction = -1;
    switch (playDirection) {
        case PlayDirection_Up:
            direction = 0;
            break;
        case PlayDirection_Down:
            direction = 1;
            break;
        case PlayDirection_Left:
            direction = 2;
            break;
        case PlayDirection_Right:
            direction = 3;
            break;
        case PlayDirection_Confirm:
            direction = 4;
            break;
        default:
            break;
    }
    return direction;
}

- (void)setHintLabelText:(NSString *)text {
    _interV.showLabel.hidden = NO;
    [_interV setHintText:text];
}

#pragma mark - WwAudienceDelegate
- (void)audienceDidSelect:(WwUserModel *)user {
    [self.interV showUserCardWithData:user];
}

- (void)updateAudienceCount:(NSInteger)count {
    if (count > self.interV.onLooksV.onLooks) {
        [self.interV.onLooksV updateOnLooksNum:count];
    }
}

#pragma mark - WwMessageBarDelegate
- (void)messageBar:(WwMessageBar *)bar sendMessage:(NSString *)message {
    [self.interV.groundManage sendBarrageText:message];
}

#pragma mark - WwGameManagerPlayerDelegate
- (void)onSlaveStreamReady {
    self.sPlayerOK = YES;
    if (self.interV.rtcExchange.left == ScreenWidth) {
        [UIView animateWithDuration:0.5 animations:^{
            self.interV.rtcExchange.right = ScreenWidth;
        }];
    }
}

- (void)onMasterStreamReady
{
    self.mPlayerOK = YES;
}

#pragma mark - WwGameManagerIMDelegate
- (void)reciveRemoteMsg:(WwChatModel *)chatM /**< 收到聊天回调*/
{
    // 弹幕
    WwUserModel *user = chatM.user;
    
    GrounderModel * grounderModel = [[GrounderModel alloc] init];
    grounderModel.name = user.nickname;
    grounderModel.message = chatM.msg;
    grounderModel.iconStr = user.portrait;
    grounderModel.gatewayRoomChatGet = nil;
    grounderModel.gender = user.gender;
    
    grounderModel.chatColor =  @"";
    [self.interV.groundManage reciveBarrage:grounderModel];
}
- (void)reciveWatchNumber:(NSInteger)number /**< 收到 观看人数*/
{
    [self.interV.onLooksV updateOnLooksNum:number];
}
- (void)reciveRoomUpdateData:(WwRoomLiveData *)notify /**< 收到 房间状态更新*/
{
    NSLog(@"AVT>>> %@",[notify mj_keyValues]);
    self.interV.watchOperationBar.roomState = notify.state;
    if (notify.state >= 3 && notify.state <= 6) {
        // 机器操作状态时禁止掉观众的开始按键
        safe_async_main((^{
            self.interV.watchOperationBar.showTipBtn.hidden = NO;
            self.interV.watchOperationBar.operationDisable = YES;
        }));
        
        //显示真实的列表
        WwUserModel *user = [self userFromPbUser:notify.user];
        [self.interV.playerInfoV freshPullStream:notify.streamPlayer andGameUser:user isSocketNotify:YES];
    }
    else {
        // 机器空闲状态时使能观众的开始按键
        if (notify.state == 2) {
            safe_async_main((^{
                self.interV.watchOperationBar.operationDisable = NO;
                self.interV.watchOperationBar.showTipBtn.hidden = YES;
            }));
        }
        //显示默认图像
        [self.interV.playerInfoV freshDefaultUIIsSocketNotify:YES];
    }
    
    safe_async_main(^{
        self.statusImgV.hidden = notify.state != 1;
    });
    
    //故障弹窗
    if (notify.state <= 0) {
        safe_async_main((^{
            [self faultViewAnchor:notify.user.uid];
        }));
    }
}

- (void)reciveClawResult:(WwClawResult *)notify /**< 房间内收到 抓娃娃结果通知*/
{
    BOOL success = notify.status == 2;
    safe_async_main((^{
        if (self.interV.vScrollV.contentOffset.y == 0) {
            WwPopupsView * popV = [WwPopupsView instancePopupsView:WwPopupsViewTypeCustom];
            
            UIImageView * imgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:success ? @"game_result_success" : @"game_result_fail"]];
            
            [popV customUI:imgV withFrame:imgV.frame];
            //            imgV.superview.center = CGPointMake(ScreenWidth/2.0, ScreenHeight/2.0-100);
            //            popV.frame = self.liveVC.view.bounds;
            //            [self.liveVC.view addSubview:popV];
            //修改键盘弹起时，遮挡住该图片
            [popV showWithHighLevel];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [popV removePopupsView];
            });
        }
    }));
}
- (void)reciveGlobleMessage:(WwGlobalNotify *)notify /**< 收到全平台 抓娃娃结果通知*/
{
    NSLog(@"%@",notify.message);
}

- (void)avatarTtlDidChanged:(NSInteger)ttl {
    [self.interV.onLooksV.pingV handlePingNum:ttl];
}

#pragma mark - 弹窗
- (WwPopupsView *)faultPopupsView {
    if (!_faultPopupsView) {
        _faultPopupsView = [WwPopupsView instancePopupsView:WwPopupsViewTypeNormal];
    }
    return _faultPopupsView;
}

- (void)faultViewAnchor:(NSInteger)uid {
    [self.faultPopupsView show];
    NSString *contentStr = @"哎呀~被玩坏啦！只好先去别的房间抓娃娃了";
    if (uid == kZXUid) {
        contentStr = @"哎呀~被玩坏啦！游戏结束，本局花费将返还至钱包中";
    }
    [self.faultPopupsView.contentLabel setText:contentStr];
    [self.faultPopupsView.sureButton setTitle:@"好吧~" forState:UIControlStateNormal];
    // TODO
//    [self.faultPopupsView.sureButton setBackgroundColor:];
    [self.faultPopupsView.sureButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.faultPopupsView.sureButton.layer.cornerRadius = self.faultPopupsView.sureButton.height * 0.5;
}



#pragma mark - Helper

- (WwUserModel *)userFromPbUser:(WwUserModel *)userModel
{
    WwUserModel *user = [[WwUserModel alloc] init];
    user.uid = userModel.uid;
    user.gender = userModel.gender;
    user.portrait = userModel.portrait;
    user.nickname = userModel.nickname;
    return user;
}

#pragma mark - WwCountDownViewDelegate
- (void)zyTimerFinish {
    [self.interV.gameResultV startRequestResult];
}

#pragma mark - WwGameResultDelegate
- (void)hadCompleteResultRequest {
    // 结果请求到了
    self.interV.countDownV.status = WwCountDownStatusRequestComplete;
}

- (void)playAgain {
    // 再来一次, 此处直接调用观众端开始游戏按钮的逻辑
    BOOL callApi = [self onStartClicked:nil];
    if (callApi == NO) {
        //当作 result 点击关闭处理。 消失操作栏、释放资源
        [self endGameAndStopPush];
        [self callReleaseLogic];
    }
}


- (void)gameResultShareResult:(WwGameResultModel *)result {
    // 成功：分享游戏结果 失败：引导查看大神战绩
    
    safe_async_main((^{
        if (result.state == 2) {
            
        } else {
            [self.interV.waWaRecordInfoVc selectIndex:1];
        }
        
    }));
}


- (void)endGameAndStopPush {
    [self.interV showPlayOperation:NO completion:nil];
    // 强制关流
    [self.interV.playerInfoV freshDefaultUIIsSocketNotify:NO];
}

- (void)callReleaseLogic {
    [self gameRelease:nil];
}

#pragma mark - 上报服务端, 资源释放
- (void)gameRelease:(void(^)(BOOL))block {
    // 房间ID
    NSInteger owid = [(WwRoomModel *)self.room ID];
    // TODO
//    [ZXHttpTask POST:WwGameLogicRelease parameters:@{@"id":@(owid)} taskResponse:^(DVLHttpResponse *response) {
//        if (block) {
//            block(!response.code);
//        }
//    }];
}

#pragma mark - Helper
- (void)playBackGroundAudio
{
    NSString * backAudio = [NSString stringWithFormat:@"game_background_%d",2];
    [[WwShareAudioPlayer shareAudioPlayer] playBackGroundAudioWithFile:backAudio ofType:@"mp3"];
}

#pragma mark - SetterAndGetter
- (UIView *)rtcBaseV {
    if (!_rtcBaseV) {
        // 拉取游戏视频流
        _rtcBaseV = [[UIView alloc] initWithFrame:self.view.bounds];
        _rtcBaseV.height = ScreenHeight - 170;
        _rtcBaseV.backgroundColor = [UIColor clearColor];
    }
    return _rtcBaseV;
}

- (WwLiveInteractiveView *)interV {
    if (!_interV) {
        // 交互视图
        WwRoomModel *recommend = self.room;
        _interV = [WwLiveInteractiveView zyInteractiveViewWithRoomData:recommend];
        _interV.watchOperationBar.delegate = self;
        _interV.playOperationBar.delegate = self;
        _interV.audienceCollectV.delegate = self;
        _interV.messageBar.delegate = self;
        _interV.countDownV.delegate = self;
        _interV.gameResultV.delegate = self;
        [_interV.rtcExchange addTarget:self action:@selector(rtcExchangeAction) forControlEvents:UIControlEventTouchUpInside];
        
        _interV.playerInfoV.liveVC = self;
        _interV.playerInfoV.roomData = self.room;
    }
    return _interV;
}


- (UIImageView *)statusImgV {
    if (!_statusImgV) {
        _statusImgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 170)];
        _statusImgV.hidden = YES;
        _statusImgV.backgroundColor = [UIColor clearColor];
        _statusImgV.image = [UIImage imageNamed:@"replenishment"];
        _statusImgV.contentMode = UIViewContentModeScaleAspectFill;
        _statusImgV.clipsToBounds = YES;
    }
    return _statusImgV;
}

@end
