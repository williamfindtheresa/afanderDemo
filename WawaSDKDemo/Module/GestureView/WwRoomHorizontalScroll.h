//
//  WwRoomHorizontalScroll.h
//  prizeClaw
//
//  Created by ganyanchao on 08/10/2017.
//  Copyright © 2017 QuanMin.ShouYin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WwBaseScrollView.h"

@class WwLiveInteractiveView;

//房间内推水平方向滚动
@interface WwRoomHorizontalScroll : WwBaseScrollView

@property (nonatomic, weak) WwLiveInteractiveView *interView;

@end
