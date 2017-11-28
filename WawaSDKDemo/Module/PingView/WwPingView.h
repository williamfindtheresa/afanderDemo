//
//  WwPingView.h
//  prizeClaw
//
//  Created by 刘昊 on 2017/10/12.
//  Copyright © 2017年 QuanMin.ShouYin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WwPingView;
@protocol WwPingViewDelegate <NSObject>

- (void)netStatusDidChangd:(WwPingView *)pingV;

@end

@interface WwPingView : UIView

@property (nonatomic, weak) id<WwPingViewDelegate> delegate;        /**< 代理*/

@property (nonatomic, assign) NSInteger ping;                       /**< 延迟*/

- (void)startPing;      /**< 开始ping*/

- (void)endPing;        /**< 结束ping*/

- (BOOL)isNetOK;

- (void)handlePingNum:(NSInteger)ping;


@end
