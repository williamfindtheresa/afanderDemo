//
//  WwSoundShockView.m
//

#import "WwSoundShockView.h"

@implementation WwSoundShockView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self customUI];
    }
    return self;
}


- (void)customUI
{
    CALayer *layer = [CALayer layer];
    layer.frame = self.bounds;
    layer.backgroundColor = [UIColor clearColor].CGColor;
    [self.layer addSublayer:layer];
    
    //设置一个
    for (int i = 0; i < 5; i++) {
     
        CALayer *bar = [CALayer layer];
        bar.backgroundColor = [UIColor whiteColor].CGColor;
        bar.frame = CGRectMake(i*6, 0, 3, self.height);
        bar.position = CGPointMake(i*6, self.height/2.0);
        bar.anchorPoint = CGPointMake(0.5, 0.5);
        [layer addSublayer:bar];
        
        CGFloat from  = 0.3;
        CGFloat toend = 1.0;
        if (i == 1) {
            from = 0.6;
            toend = 0.6;
        }
        else if (i == 2) {
            from = 1.0;
            toend = 0.3;
        }
        else if (i == 3) {
            from = 0.6;
            toend = 0.6;
        }
        else if (i == 4) {
            from = 0.3;
            toend = 1.0;
        }
        
        CAKeyframeAnimation * scaleAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale.y"];
        scaleAnimation.values = @[@(from),
                                  @(0.1),
                                  @(toend)];
        scaleAnimation.keyTimes = @[@(0),
                                    @(0.5),
                                    @(1.0)];
        
        
        //    scaleAnimation.fillMode = kCAFillModeForwards;
        scaleAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
        scaleAnimation.duration = 1;
        
        scaleAnimation.autoreverses = YES;
        scaleAnimation.repeatCount = MAXFLOAT;
        scaleAnimation.removedOnCompletion = NO;
        
        [bar addAnimation:scaleAnimation forKey:@"scaleAnimation"];
    }
}


@end
