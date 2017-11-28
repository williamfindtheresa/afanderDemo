//
//  WwLiveInteractiveView.m
//  prizeClaw
//
//  Created by 刘昊 on 2017/10/1.
//  Copyright © 2017年 QuanMin.ShouYin. All rights reserved.
//

#import "WwLiveInteractiveView.h"
#import "WwBaseScrollView.h"
#import "WwPushExchangeView.h"
#import "WwWatchOperationView.h"
#import "NSTimer+EOCBlocksSupport.h"
#import "GrounderModel.h"
#import "WwViewUtil.h"


// 谨慎改动, 垂直滑动视图的可滑动高度, 涉及到娃娃详情漏一点的处理
#define kVScrollV_H (1290 * (ScreenHeight / 667.0))

@interface WwLiveInteractiveView()
<WwAudienceStudioViewDelegate,
UIScrollViewDelegate,
UIGestureRecognizerDelegate>

@property (nonatomic, weak) NSTimer *showTimer;
@property (nonatomic, copy) NSString *wawaId;
@property (nonatomic, strong) UIImageView * bottomBackImgV;                     /**< 底部背景视图*/


@property (nonatomic, assign, readonly) NSInteger roomId; //机器id
@property (nonatomic, assign) CGFloat lastAlpa;


@end

@implementation WwLiveInteractiveView

#pragma mark - Pubilic
+ (instancetype)zyInteractiveViewWithRoomData:(WwRoomModel *)roomData {
    
    WwLiveInteractiveView * activeV = [[WwLiveInteractiveView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    activeV.roomData = roomData;
    NSInteger wawaid = roomData.wawa.ID;
    [activeV customUIWawaId:[@(wawaid) stringValue]];
    [activeV firstJoinRoomhttpRequest];
    
    activeV.tapGesture = [activeV addSingleTapGestureAtTarget:activeV action:@selector(userDidClickSelfByTap:)];
    activeV.tapGesture.delegate = activeV;
    return activeV;
}

//弹出用户卡片
- (void)showUserCardWithData:(id)data {
    NSMutableDictionary *dictM = [NSMutableDictionary dictionary];
    dictM[@"roomInfo"] = self.roomData;
    dictM[@"userInfo"] = data;
    
    [self closeKeyboard];
}

//键盘操作
- (void)openKeyboard
{
    [self.messageBar showKeyboard];
    [self configScrollViewEnalbe:NO];
    [self.hScrollV scrollToRightAnimated:NO];
}

- (void)closeKeyboard
{
    [self.messageBar closeKeyboard];
    [self configScrollViewEnalbe:YES];
}

- (void)showKeyboardChatUser:(WwUserModel *)chatUser //@Ta 聊天区跟人说活
{
    [self.messageBar showKeyboardChatUser:chatUser];
    [self configScrollViewEnalbe:NO];
    [self.hScrollV scrollToRightAnimated:NO];
}

#pragma mark - Private
- (void)customUIWawaId:(NSString *)wawaId {
    self.wawaId = wawaId;
    self.backgroundColor = [UIColor clearColor];
    // 在横向滑动的滑动视图上添加业务视图模块
    [self customHScrollView];
    // 在添加垂直方向滑动的视图上添加横向滑动的视图
    [self.vScrollV addSubview:self.hScrollV];
    // 在垂直方向滑动的视图上添加下半部分背景色
    [self.vScrollV addSubview:self.bottomBackImgV];
    // 在垂直方向滑动的视图上添加流翻转按钮
    [self.vScrollV addSubview:self.rtcExchange];
    // 在垂直方向滑动的视图上添加倒计时视图
    [self.vScrollV addSubview:self.countDownV];
    // 在垂直方向滑动的视图上添加操作按钮
    [self.vScrollV addSubview:self.watchOperationBar];
    [self.vScrollV addSubview:self.showOperationView];
    // 在垂直方向滑动的视图上添加娃娃详情和最近抓中
    [self.vScrollV addSubview:self.waWaRecordInfoVc.view];
    // 在垂直滑动的视图上添加操作按钮
    [self.vScrollV addSubview:self.playOperationBar];
    // 在垂直方向滑动的视图上添加关闭按钮
    [self.vScrollV addSubview:self.closeBtn];
    // 在水平方向添加聊天
    [self.hScrollV addSubview:self.messageBar];
    // 在水平方向滑动的视图上添加围观人数视图
    [self.hScrollV addSubview:self.onLooksV];
    [self.onLooksV.pingV startPing];
    
    _showLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetHeight(self.frame)/2, CGRectGetWidth(self.frame), 30)];
    _showLabel.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:0];
    _showLabel.textColor = [UIColor grayColor];
    _showLabel.textAlignment = NSTextAlignmentCenter;
    _showLabel.text = @"暂无点击事件";
    _showLabel.hidden = YES;
    
    [self addSubview:_showLabel];
    
    [self addSubview:self.vScrollV];
    
    [self addSubview:self.reClearScreenBtn];
    
    [self.playOperationBar addObserver:self forKeyPath:@"hidden" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    [self.gameResultV addObserver:self forKeyPath:@"hidden" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
}

// add interactive views
- (void)customHScrollView {
    NSArray * arr = @[self.barrageV,
                      self.audienceCollectV,
                      self.playerInfoV];
    for (UIView * subV in arr) {
        subV.left += ScreenWidth;
        [self.hScrollV addSubview:subV];
    }
    self.hScrollV.contentOffset = CGPointMake(ScreenWidth, 0);
    
    self.audienceCollectV.left = self.playerInfoV.right + 10;
    self.audienceCollectV.width = self.hScrollV.contentSize.width - 80 - self.audienceCollectV.left;
}

- (void)setHintText:(NSString *)text {
    if ([_showTimer isValid]) {
        [_showTimer invalidate];
        _showTimer = nil;
    }
    _showLabel.text = text;
    _showTimer = [NSTimer eoc_scheduledTimerWithTimeInterval:2.f block:^{
        _showLabel.hidden = YES;
    } repeats:NO];
}

#pragma mark - Action
- (void)reClearScreenAction:(UIButton *)sender {
    [self.hScrollV scrollToRightAnimated:YES];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.hScrollV) {
        CGFloat x = scrollView.contentOffset.x / ScreenWidth;
        CGFloat alpha = 0;
        if (x < 0) {
            alpha = 1;
        } else if (x <= 1) {
            alpha = 1 - x;
        } else {
            alpha = 0;
        }
        self.reClearScreenBtn.alpha = alpha;
        self.lastAlpa = alpha;
    }
    else if (scrollView == self.vScrollV) {
        if (self.lastAlpa <= 0) {
            
        }
        else {
            CGFloat x = scrollView.contentOffset.y / ScreenHeight;
            CGFloat toalpa = fabs(1 - x);
            self.reClearScreenBtn.alpha = toalpa;
            if (x <= 0) {
                self.reClearScreenBtn.alpha = self.lastAlpa;
            }
            else if (toalpa <= 0.2) {
                self.reClearScreenBtn.alpha = 0;
            }
            
        }
    }
}

#pragma mark - WwAudienceStudioViewDelegate
- (void)audienceDidSelect:(WwUserModel *)user {
    
}


#pragma mark - Helper
- (void)firstJoinRoomhttpRequest
{
    
}

- (void)showPlayOperation:(BOOL)isShow completion:(void(^)())block {
    safe_async_main((^{
        if (isShow) {
            // Note: 默认在展示按键时enable
            self.playOperationBar.operationDisable = NO;
            
            self.playOperationBar.hidden = NO;
            [UIView animateWithDuration:0.2 animations:^{
                self.playOperationBar.bottom = self.bottom;
            } completion:^(BOOL finished) {
                if (block) {
                    block();
                }
            }];
        }
        else {
            [UIView animateWithDuration:0.2 animations:^{
                self.playOperationBar.top = self.bottom;
            } completion:^(BOOL finished) {
                self.playOperationBar.hidden = YES;
                if (block) {
                    block();
                }
            }];
        }
    }));
}


- (void)userDidClickSelfByTap:(UITapGestureRecognizer *)tap
{
    CGPoint point =  [tap locationInView:self];
    [self userDidClickSelf:point];
}


- (void)userDidClickSelf:(CGPoint)point
{
    CGRect messageFrame = [self.messageBar.superview  convertRect:self.messageBar.frame toView:self];
    //+ - 上下考虑 10 距离的误差，附近也不消失
    messageFrame.origin.y -= 10;
    messageFrame.size.height += 20;
    if (CGRectContainsPoint(messageFrame, point) == NO) {
        if (self.messageBar.isActive) {
            [self closeKeyboard];
        }
    }
}

- (void)configScrollViewEnalbe:(BOOL)enable
{
    self.vScrollV.scrollEnabled = enable;
    self.hScrollV.scrollEnabled = enable;
}


#pragma mark - UIGestureDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([touch.view.superview isKindOfClass:[UICollectionViewCell class]]) {
        return NO;
    }
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

#pragma mark - SetterAndGetter
- (UIButton *)closeBtn {
    if (!_closeBtn) {
        // 关闭按钮
        _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _closeBtn.size = CGSizeMake(44, 44);
        _closeBtn.right = self.width - 5;
        _closeBtn.top = IS_IPhone_X ? 44 : 30 ;
        
        [_closeBtn setImage:[UIImage imageNamed:@"live_close"] forState:UIControlStateNormal];
        [_closeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    return _closeBtn;
}

// 垂直方向的滑动视图
- (WwBaseScrollView *)vScrollV {
    if (!_vScrollV) {
        _vScrollV = [[WwRoomVerticalScroll alloc] initWithFrame:self.bounds];
        // 高度计算
        _vScrollV.contentSize = CGSizeMake(self.width, kVScrollV_H);
        _vScrollV.bounces = NO;
        _vScrollV.needCheckTable = YES;
        _vScrollV.interView = self;
        _vScrollV.delegate = self;
        _vScrollV.backgroundColor = [UIColor clearColor];
    }
    return _vScrollV;
}

// 水平方向的滑动视图
- (WwBaseScrollView *)hScrollV {
    if (!_hScrollV) {
        _hScrollV = [[WwRoomHorizontalScroll alloc] initWithFrame:self.bounds];
        _hScrollV.contentSize = CGSizeMake(2*self.width, self.height);
        _hScrollV.alwaysBounceVertical = NO;
        _hScrollV.interView = self;
        _hScrollV.delegate = self;
        _hScrollV.backgroundColor = [UIColor clearColor];
    }
    return _hScrollV;
}

// 恢复清屏的按钮
- (UIButton *)reClearScreenBtn {
    if (!_reClearScreenBtn) {
        _reClearScreenBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _reClearScreenBtn.size = CGSizeMake(32, 32);
        _reClearScreenBtn.layer.cornerRadius = 16;
        _reClearScreenBtn.clipsToBounds = YES;
        _reClearScreenBtn.backgroundColor = [UIColor clearColor];
        _reClearScreenBtn.left = 10;
        _reClearScreenBtn.bottom = ScreenWidth * (4/3.0) - 30;
        if (IS_IPhone_X) {
            _reClearScreenBtn.bottom = ScreenHeight - 200;
        }
        _reClearScreenBtn.alpha = 0;
        [_reClearScreenBtn addTarget:self action:@selector(reClearScreenAction:) forControlEvents:UIControlEventTouchUpInside];
        
        UIImageView * imgV = [[UIImageView alloc] initWithFrame:_reClearScreenBtn.bounds];
        imgV.image = [UIImage imageNamed:@"game_reclearscreen"];
        [_reClearScreenBtn addSubview:imgV];
    }
    return _reClearScreenBtn;
}

// 弹幕
- (UIView *)barrageV {
    UIView *view = [self.groundManage barrageSuperView];
    view.frame = CGRectMake(0, self.onLooksV.bottom, ScreenWidth, 90);
    view.backgroundColor = [UIColor clearColor];
    view.clipsToBounds = YES;
    return view;
}
- (WwGroundManager *)groundManage {
    if (!_groundManage) {
        _groundManage = [[WwGroundManager alloc] init];
        _groundManage.interView = self;
    }
    return _groundManage;
}
// 观众列表
- (WwAudienceStudioView *)audienceCollectV {
    if (!_audienceCollectV) {
        _audienceCollectV = [WwAudienceStudioView zyAudienceView];
        _audienceCollectV.frame = CGRectMake(172, (IS_IPhone_X ? 44 : 26), ScreenWidth - 80 - 172, kCellWidth);
        _audienceCollectV.delegate = self;
        _audienceCollectV.roomID = self.roomId;
    }
    return _audienceCollectV;
}

// 玩家信息
- (WwPushExchangeView *)playerInfoV {
    if (!_playerInfoV) {
        _playerInfoV = [WwPushExchangeView pushExchangeView];
        _playerInfoV.top = kStatusBarHeight + (IS_IPhone_X ? 0 : 5);
        _playerInfoV.left = 11;
    }
    return _playerInfoV;
}

// 流切换
- (UIButton *)rtcExchange {
    if (!_rtcExchange) {
        _rtcExchange = [UIButton buttonWithType:UIButtonTypeCustom];
        _rtcExchange.size = CGSizeMake(38, 49);
        _rtcExchange.centerY = (ScreenWidth * (4/3.0)) / 2.0;
        _rtcExchange.left = ScreenWidth;
        _rtcExchange.backgroundColor = [UIColor clearColor];
        
        UIImageView * imgV = [[UIImageView alloc] initWithFrame:_rtcExchange.bounds];
        imgV.image = [UIImage imageNamed:@"interactive_rtcExchange"];
        imgV.contentMode = UIViewContentModeRight;
        [_rtcExchange addSubview:imgV];
    }
    return _rtcExchange;
}

// 倒计时
- (UIView *)countDownV {
    if (!_countDownV) {
        _countDownV = [[WwCountDownView alloc] init];
        _countDownV.size = CGSizeMake(40, 40);
        _countDownV.bottom = ScreenHeight - 188;
        _countDownV.right = ScreenWidth - 12;
        _countDownV.backgroundColor = [UIColor clearColor];
        _countDownV.hidden = YES;
    }
    return _countDownV;
}

// 观众操作视图
- (WwWatchOperationView *)watchOperationBar {
    if (!_watchOperationBar) {
        _watchOperationBar = [WwWatchOperationView watchOperationView];
        _watchOperationBar.width = self.width;
        _watchOperationBar.bottom = self.height;
        _watchOperationBar.wawa = self.roomData.wawa;
    }
    return _watchOperationBar;
}

//
- (WwPlayOperationView *)playOperationBar {
    if (!_playOperationBar) {
        _playOperationBar = [WwPlayOperationView operationView];
        _playOperationBar.width = self.width;
        _playOperationBar.top = self.height;
        _playOperationBar.hidden = YES;
    }
    return _playOperationBar;
}


//娃娃详情和最近抓中
- (WwWaWaRecordInfoViewController *)waWaRecordInfoVc {
    if (!_waWaRecordInfoVc) {
        _waWaRecordInfoVc = [[WwWaWaRecordInfoViewController alloc] init];
        _waWaRecordInfoVc.view.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight - 37*(ScreenHeight/667.0));
        _waWaRecordInfoVc.view.bottom = kVScrollV_H;
    }
    return _waWaRecordInfoVc;
}

- (UIButton *)showOperationView {
    if (!_showOperationView) {
        return nil;
        _showOperationView = [UIButton buttonWithType:UIButtonTypeCustom];
        [_showOperationView setTitle:@"打开操作和飘屏" forState:UIControlStateNormal];
        _showOperationView.size = CGSizeMake(80, 44);
        _showOperationView.bottom = ScreenHeight - 258;
        _showOperationView.right = ScreenWidth - 60;
        _showOperationView.hidden = NO;
        _showOperationView.backgroundColor = [UIColor clearColor];
        [_showOperationView addTarget:self action:@selector(onShowButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _showOperationView;
}

- (void)onShowButtonClicked:(UIButton *)sender {
    [self.groundManage sendBarrageText:@"飘屏测试数据"];
//    _playOperationBar.operationDisable = !(_playOperationBar.operationDisable);
    if (self.playOperationBar.hidden) {
        [self.showOperationView setTitle:@"关闭操作" forState:UIControlStateNormal];
        self.playOperationBar.hidden = NO;
        [UIView animateWithDuration:0.2 animations:^{
            self.playOperationBar.bottom = self.bottom;
        }];
    }
    else {
        [self.showOperationView setTitle:@"打开操作" forState:UIControlStateNormal];
        [UIView animateWithDuration:0.2 animations:^{
            self.playOperationBar.top = self.bottom;
        } completion:^(BOOL finished) {
            self.playOperationBar.hidden = YES;
        }];
    }
}

- (WwMessageBar *)messageBar
{
    if (!_messageBar) {
        CGRect rect = (CGRect){ScreenWidth,ScreenHeight,ScreenWidth,47};
        _messageBar = [[WwMessageBar alloc] initWithFrame:rect];
        _messageBar.hidden = YES;
    }
    return _messageBar;
}

- (WwGameResultView *)gameResultV {
    if (!_gameResultV) {
        _gameResultV = [WwGameResultView gameResultView];
    }
    return _gameResultV;
}

- (UIImageView *)bottomBackImgV {
    // 底部背景色
    if (!_bottomBackImgV) {
        _bottomBackImgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, ScreenHeight, ScreenWidth, ScreenHeight)];
        _bottomBackImgV.image = [UIImage imageNamed:@"wawaParticularBg"];
    }
    return _bottomBackImgV;
}

- (WwOnLooksView *)onLooksV {
    if (!_onLooksV) {
        _onLooksV = [WwOnLooksView onlooksView];
        _onLooksV.top = self.audienceCollectV.bottom + 10;
        _onLooksV.right = 2*ScreenWidth - 11;
    }
    return _onLooksV;
}

- (NSInteger)roomId {
    return kShareM.curRoomID;
}

#pragma mark - Observe
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if (object == self.playOperationBar) {
        self.vScrollV.scrollEnabled = self.playOperationBar.hidden;
        self.countDownV.hidden = self.playOperationBar.hidden || !self.gameResultV.hidden;
    } else if (object == self.gameResultV) {
        self.countDownV.hidden = self.playOperationBar.hidden || !self.gameResultV.hidden;
    }
}

- (void)dealloc
{
    [self.playOperationBar removeObserver:self forKeyPath:@"hidden"];
    [self.gameResultV removeObserver:self forKeyPath:@"hidden"];
}

@end
