//
//  WwRoomHorizontalScroll.m
//  prizeClaw
//
//  Created by ganyanchao on 08/10/2017.
//  Copyright © 2017 QuanMin.ShouYin. All rights reserved.
//

#import "WwRoomHorizontalScroll.h"
#import "WwLiveInteractiveView.h"

@interface WwRoomHorizontalScroll ()

@end

@implementation WwRoomHorizontalScroll

////没什么用，效果不大
//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
//{
//    [super touchesBegan:touches withEvent:event];
//    
//    
//}


- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
  BOOL result =  [super gestureRecognizer:gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:otherGestureRecognizer];
    
    if (result) {
        return result;
    }
    return NO;
}


@end