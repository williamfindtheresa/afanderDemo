//
//  WwGroundManager.h
//  prizeClaw
//
//  Created by yuyou on 2017/10/3.
//  Copyright © 2017年 QuanMin.ShouYin. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WwLiveInteractiveView;

@class GrounderModel;

@interface WwGroundManager : NSObject

@property (nonatomic, strong, readonly) UIView *barrageSuperView;

@property (nonatomic, weak) WwLiveInteractiveView *interView;

//自己发送
- (void)sendBarrageText:(NSString *)barrageText;  /**< 发送聊天或者弹幕*/
//收到
- (void)reciveBarrage:(GrounderModel *)grounderModel; /**< 发送票屏弹幕*/

@end
