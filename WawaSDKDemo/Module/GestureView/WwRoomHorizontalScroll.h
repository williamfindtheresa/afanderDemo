//
//  WwRoomHorizontalScroll.h
//

#import <UIKit/UIKit.h>
#import "WwBaseScrollView.h"

@class WwLiveInteractiveView;

//房间内推水平方向滚动
@interface WwRoomHorizontalScroll : WwBaseScrollView

@property (nonatomic, weak) WwLiveInteractiveView *interView;

@end
