//
//  QuickSendGiftView.h
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSUInteger, ZYCountDownStatus)
{
    ZYCountDownStatusCountDown,        /**< 正常倒计时。 自己显示*/
    
    ZYCountDownStatusCountFinish,      /**< 倒计时结束了。显示 等待文字*/
    
    ZYCountDownStatusRequestResultIng, /**< 去请求结果。  显示 等待文字*/
    
    ZYCountDownStatusRequestComplete,  /**< 结果请求完成。 自己消失 */
};


@protocol ZYCountDownViewDelegate <NSObject>

- (void)zyTimerFinish;

@end

//快捷送礼按钮
@interface ZYCountDownView : UIView

@property (nonatomic, assign) NSTimeInterval totalTimer; //设置总时间 默认30s
@property (nonatomic, weak) id<ZYCountDownViewDelegate> delegate;

/**< 0.0 - totalTimer, 当前剩余时间 */
- (void)updateProgressTimer:(NSTimeInterval)countDown;

@property (nonatomic, assign) ZYCountDownStatus status;




@end
