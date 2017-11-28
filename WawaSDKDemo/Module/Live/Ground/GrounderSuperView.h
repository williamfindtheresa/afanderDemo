//
//  GrounderSuperView.h
//  GrounderDemo
//
//  Created by 贾楠 on 16/3/10.
//  Copyright © 2016年 贾楠. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GrounderModel.h"

#import "BREngine.h"

/**< 弹幕画布*/

@interface GrounderSuperView : UIView <BRCanvasInterface>

@property(nonatomic, strong, readonly) BREngine *brengine;

- (void)newBarrageComing:(id)model; /**< 普通弹幕 横幅数据都调用这个*/

@end
