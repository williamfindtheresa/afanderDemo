//
//  WwRoomVerticalScroll.h
//  prizeClaw
//
//  Created by ganyanchao on 08/10/2017.
//  Copyright © 2017 QuanMin.ShouYin. All rights reserved.
//

#import "WwBaseScrollView.h"

@class WwLiveInteractiveView;

//房间竖直方向
@interface WwRoomVerticalScroll : WwBaseScrollView

@property (nonatomic, assign) BOOL needCheckTable;

@property (nonatomic, weak) WwLiveInteractiveView *interView;

@end
