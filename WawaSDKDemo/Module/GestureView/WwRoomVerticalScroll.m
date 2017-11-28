//
//  WwRoomVerticalScroll.m
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
