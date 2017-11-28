//
//  GrounderModel.h
//  yuyou
//
//  Created by liyang on 16/5/19.
//  Copyright © 2016年 李洋. All rights reserved.
//

#import <Foundation/Foundation.h>


#import "BRRendDataInterface.h"

@class GatewayRoomChatGet;

@interface GrounderModel : NSObject <BRRendDataInterface>

@property (nonatomic, strong) GatewayRoomChatGet *gatewayRoomChatGet;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *message;
@property (nonatomic, copy) NSString *iconStr;
@property (nonatomic, copy) NSString *chatColor;                      /**< 弹幕颜色*/
@property (nonatomic, assign) NSInteger gender;

#pragma mark - custom local
@property (nonatomic, assign) BOOL showTxtOnly; /**< 只显示文本*/

#pragma mark - BRRendDataInterface


@end
