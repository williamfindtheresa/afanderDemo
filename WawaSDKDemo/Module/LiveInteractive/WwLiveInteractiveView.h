//
//  WwLiveInteractiveView.h
//  prizeClaw
//
//  Created by 刘昊 on 2017/10/1.
//  Copyright © 2017年 QuanMin.ShouYin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WwBaseScrollView.h"
#import "WwPushExchangeView.h"
#import "WwAudienceStudioView.h"
#import "WwWatchOperationView.h"
#import "WwPlayOperationView.h"
#import "WwCountDownView.h"
#import "GrounderSuperView.h"
#import "WwMessageBar.h"
#import "WwGroundManager.h"

#import "WwRoomHorizontalScroll.h"
#import "WwRoomVerticalScroll.h"
#import "WwGameResultView.h"
#import "WwWaWaRecordInfoViewController.h"
#import "WwOnLooksView.h"

@interface WwLiveInteractiveView : UIView

@property (nonatomic, strong) WwRoomModel *roomData;

+ (instancetype)zyInteractiveViewWithRoomData:(WwRoomModel *)roomData;

@property (nonatomic, strong) UIButton * closeBtn;                              /**< 关闭按钮*/

@property (nonatomic, strong) WwRoomVerticalScroll * vScrollV;                      /**< 上下 scrollview*/

@property (nonatomic, strong) WwRoomHorizontalScroll * hScrollV;                      /**< 左右 scrollview*/

@property (nonatomic, strong) UIButton * reClearScreenBtn;                      /**< 恢复清屏按钮*/

@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;

@property (nonatomic, strong) GrounderSuperView * barrageV;                                /**< 弹幕视图*/

@property (nonatomic, strong) WwAudienceStudioView * audienceCollectV;          /**< 观众栏*/

@property (nonatomic, strong) WwOnLooksView * onLooksV;                         /**< 围观数展示视图*/

@property (nonatomic, strong) WwPushExchangeView * playerInfoV;                 /**< 游戏者信息*/

@property (nonatomic, strong) UIButton * rtcExchange;                           /**< 流切换*/

@property (nonatomic, strong) WwCountDownView * countDownV;                     /**< 倒计时视图*/

@property (nonatomic, strong) WwWatchOperationView * watchOperationBar;         /**< 观众操作视图*/

@property (nonatomic, strong) WwPlayOperationView * playOperationBar;           /**< 玩家操作视图*/

@property (nonatomic, strong) WwMessageBar *messageBar;                         /**< 消息工具条*/

@property (nonatomic, strong) WwGroundManager *groundManage;                    /**< 弹幕*/

@property (nonatomic, strong) WwGameResultView * gameResultV;                   /**< 游戏结果*/

@property (nonatomic, strong) WwWaWaRecordInfoViewController * waWaRecordInfoVc;/**< 娃娃详情和最近抓中*/

@property (nonatomic, strong) UILabel *showLabel;

@property (nonatomic, strong) UIButton *showOperationView;

- (void)setHintText:(NSString *)text;

- (void)showUserCardWithData:(id)data;

// 键盘操作
- (void)openKeyboard;
- (void)closeKeyboard;
- (void)showKeyboardChatUser:(WwUserModel *)chatUser; //@Ta 聊天区跟人说活

// 游戏操作视图控制
- (void)showPlayOperation:(BOOL)isShow completion:(void(^)())block;

@end
