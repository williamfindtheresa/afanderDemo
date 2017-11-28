//
//  WwRoomVerticalScroll.h
//

#import "WwBaseScrollView.h"

@class WwLiveInteractiveView;

//房间竖直方向
@interface WwRoomVerticalScroll : WwBaseScrollView

@property (nonatomic, assign) BOOL needCheckTable;

@property (nonatomic, weak) WwLiveInteractiveView *interView;

@end
