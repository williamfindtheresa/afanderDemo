//
//  WwBaseScrollView.h
//  WawaSDKDemo
//
//

#import <UIKit/UIKit.h>


@interface WwBaseScrollView : UIScrollView

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer;

@end
