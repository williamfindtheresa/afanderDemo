//
//  QuickSendGiftView.h
//  yuyou
//
//  Created by ganyanchao on 07/09/2017.
//  Copyright © 2017 Zhang Xiu Inc. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSUInteger, WwCountDownStatus)
{
    WwCountDownStatusCountDown,        /**< 正常倒计时。 自己显示*/
    
    WwCountDownStatusCountFinish,      /**< 倒计时结束了。显示 等待文字*/
    
    WwCountDownStatusRequestResultIng, /**< 去请求结果。  显示 等待文字*/
    
    WwCountDownStatusRequestComplete,  /**< 结果请求完成。 自己消失 */
};


@protocol WwCountDownViewDelegate <NSObject>

- (void)zyTimerFinish;

@end

//快捷送礼按钮
@interface WwCountDownView : UIView

@property (nonatomic, assign) NSTimeInterval totalTimer; //设置总时间 默认30s
@property (nonatomic, weak) id<WwCountDownViewDelegate> delegate;

/**< 0.0 - totalTimer, 当前剩余时间 */
- (void)updateProgressTimer:(NSTimeInterval)countDown;

@property (nonatomic, assign) WwCountDownStatus status;




@end
