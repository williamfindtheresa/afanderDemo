//
//  WwLogisticsView.m
//

#import "WwLogisticsView.h"
#import "WwLogisticsViewController.h"

static WwLogisticsView * _tmpView;
static WwLogisticsViewController * _logistVC;


@interface WwLogisticsView ()

@property (nonatomic, strong) UIButton *closeBtn;

@end

@implementation WwLogisticsView

- (void)dealloc
{
    NSLog(@"%s",__func__);
}

- (void)addChilderVc
{
    
}

- (void)removeChildVc
{
    [_logistVC removeFromParentViewController];
}



+ (void)showWithOrderModel:(WwWawaOrderModel *)orderModel
{
    if (!_tmpView) {
        
        _tmpView = [[WwLogisticsView alloc] initWithFrame:(CGRect){0,0,ScreenWidth,ScreenHeight}];
        [[UIApplication sharedApplication].keyWindow addSubview:_tmpView];
        _logistVC = [[WwLogisticsViewController alloc] init];
        // TODO
//        [_logistVC setDVL_InitData:orderModel];
        
        _logistVC.view.frame = (CGRect){0,ScreenHeight,ScreenWidth,ScreenHeight - 100};
        [_tmpView addSubview:_logistVC.view];
        [_tmpView  addChilderVc];
        
        [self animateShow];
    }
    else {
        [self dismiss];
    }
}

+ (void)dismiss
{
    if (_tmpView) {
        [self animateDismiss];
    }
    else {
        [self realDismiss];
    }
}


+ (void)realDismiss
{
    [_tmpView removeChildVc];
    [_tmpView removeFromSuperview];
    [_logistVC.view removeFromSuperview];
    _logistVC = nil;
    _tmpView = nil;


}


+ (void)animateShow
{
    CGFloat _height = _logistVC.view.height;
    [UIView animateWithDuration:0.3 animations:^{
        _logistVC.view.frame = (CGRect){0,ScreenHeight - _height,ScreenWidth,_height};
    }];
}

+ (void)animateDismiss
{
    CGFloat _height = _logistVC.view.height;
    [UIView animateWithDuration:0.3 animations:^{
        _logistVC.view.frame = (CGRect){0,ScreenHeight,ScreenWidth,_height};
    }
            completion:^(BOOL finished) {
                [self realDismiss];
    } ];
}

#pragma mark - Layout

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

        _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _closeBtn.frame = self.bounds;
        [self addSubview:_closeBtn];
        [_closeBtn addTarget:[self class] action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
        _closeBtn.backgroundColor = DVLColorGenAlpha(@"#000000", 0.3);
        
    }
    return self;
}

@end
