//
//  WwRoomVerticalScroll.m
//  prizeClaw
//
//  Created by ganyanchao on 08/10/2017.
//  Copyright © 2017 QuanMin.ShouYin. All rights reserved.
//

#import "WwRoomVerticalScroll.h"

#import "WwLiveInteractiveView.h"

@implementation WwRoomVerticalScroll

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    BOOL result =  [super gestureRecognizer:gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:otherGestureRecognizer];
    
    if (result) {
        return result;
    }
    
    if (self.needCheckTable && [otherGestureRecognizer.view isKindOfClass:[UITableView class]]) {
        UITableView *table = otherGestureRecognizer.view;
        if (CGPointEqualToPoint(table.contentOffset, CGPointZero) ) {
            return YES;
        }
    }
    return NO;
}

@end
