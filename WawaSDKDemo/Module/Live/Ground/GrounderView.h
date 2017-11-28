//
//  GrounderView.h
//  GrounderDemo
//
//  Created by 贾楠 on 16/3/8.
//  Copyright © 2016年 贾楠. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "GrounderModel.h"

#import "BREngine.h"

@class GrounderView;


typedef NS_ENUM(NSInteger, GrounderType) {
    GrounderTypeDefault = 0,    /**< 默认*/
    GrounderTypePublic,          /**< 全站广播,banner ,一些 ui 需要隐藏*/
    GrounderTypeText,           /**< 纯文本*/
};

@interface GrounderView : UIView <BRElementInterface>

@property (nonatomic, strong) WwChatModel *chatModel;

@property (nonatomic, assign) NSTimeInterval durtion; /**< 动画时间长度*/


@property (nonatomic, assign) GrounderType type;/**< 类型*/

- (void)setContent:(GrounderModel*)model;       /**< 普通弹幕*/

- (void)userClickAction;


@end
