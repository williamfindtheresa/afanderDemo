//
//  WwBaseScrollView.m
//

#import "WwBaseScrollView.h"

@implementation WwBaseScrollView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        self.pagingEnabled = YES;
        self.directionalLockEnabled = YES;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    // 判断 otherGestureRecognizer 是不是系统 POP 手势
    if ([otherGestureRecognizer.view isKindOfClass:NSClassFromString(@"UILayoutContainerView")]) {
        // 判断 POP 手势的状态是 begin 还是 fail，同时判断 scrollView 的 ContentOffset.x 是不是在最左边
        // otherGestureRecognizer.state == UIGestureRecognizerStateBegan &&
        if (self.contentOffset.x == 0) {
            return YES;
        }
    }
    return NO;
}
@end
