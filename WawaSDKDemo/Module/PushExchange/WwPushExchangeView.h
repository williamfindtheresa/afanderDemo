//
//  WwPushExchangeView.h
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSUInteger, WwPusherType)
{
    WwPusherTypeALl = 0, /**< 可推所有的 音频 + 视频*/
    
    WwPusherTypeDisableVIDEO = 1, /**< 不能推视频*/
    WwPusherTypeDisableAUDIO = 2, /**< 不能推音频*/
    WwPusherTypeDisableAll   = 3, /**< 视频、音频 都不能推*/
};

@protocol WwAnchorInfoProtocol <NSObject>

//刷新拉流
- (void)freshPullStream:(NSString *)playStream andGameUser:(WwUserModel *)gameUser isSocketNotify:(BOOL)isNotify; //socket 通知会使用gameuser

/**< //刷新拉流*/

//自己是游戏者，去推流
- (void)freshPushStream:(NSString *)pushUrl; /**< 自己是游戏者，去推流*/

//没有任何操作。显示默认的图像
- (void)freshDefaultUIIsSocketNotify:(BOOL)isNotify; /**< //没有其他人拉操作。显示默认的图像*/

@end


@class WwLiveViewController;


@interface WwPushExchangeView : UIView <WwAnchorInfoProtocol>

+ (instancetype)pushExchangeView;

@property (nonatomic, copy) NSString *orderId; //游戏开始的时候，订单id。 供游戏者点击翻转使用

@property (nonatomic, strong) WwRoomModel *roomData; //默认显示娃娃

@property (nonatomic, weak) WwLiveViewController *liveVC;

@property (nonatomic, assign, readonly) WwUserModel * watchPlayer; //玩家uid，可供分享使用

/**< 自己推流type。供 开始游戏 上传使用*/
@property (nonatomic, assign) WwPusherType pushType; /**< 推流类型*/


@end
