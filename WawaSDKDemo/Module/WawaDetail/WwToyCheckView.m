//
//  WwToyCheckView.m
//  WawaSDKDemo
//

#import "WwToyCheckView.h"
#import "WwToyDetailViewController.h"

@interface WwToyCheckView ()
//背景View
@property (weak, nonatomic) IBOutlet UIView *backgroundView;
//内容View
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (nonatomic, strong) WwToyDetailViewController *detailVC;
@property (nonatomic, strong) WwWawaItem *wawa;

@end

@implementation WwToyCheckView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(toyCheckRemoveFromSuperview)];
    [self.backgroundView addGestureRecognizer:gesture];
}

+ (void)showToyCheckViewWithWawa:(WwWawaItem *)wawa {
    WwToyCheckView *view = [[[NSBundle mainBundle] loadNibNamed:@"WwToyCheckView" owner:nil options:nil] lastObject];
    if (view) {
        [view initWithToyId:wawa];
        [view showWithAnimation];
    }
}

- (void)showWithAnimation {
    [UIView animateWithDuration:0.2 animations:^{
        CGRect frame = self.frame;
        frame.origin.y = 0;
        self.frame = frame;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.1 animations:^{
            self.backgroundView.alpha = 0.2;
        }];
    }];
}

- (void)initWithToyId:(WwWawaItem *)wawa {
    self.wawa = wawa;
    
    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    self.frame = window.bounds;
    [window addSubview:self];
    [self.contentView addSubview:self.detailVC.view];
    
    CGRect frame = self.frame;
    frame.origin.y = ScreenHeight;
    self.frame = frame;
    
    self.backgroundView.alpha = 0.f;
}

- (void)toyCheckRemoveFromSuperview {
    [self colseButtonClick:nil];
    self.detailVC = nil;
}

- (IBAction)colseButtonClick:(UIButton *)btn {
    CGRect frame = self.frame;
    frame.origin.y = 0;
    self.frame = frame;
    self.backgroundView.alpha = 0.0;
    [UIView animateWithDuration:0.3 animations:^{
        CGRect frame = self.frame;
        frame.origin.y = ScreenHeight;
        self.frame = frame;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (WwToyDetailViewController *)detailVC {
    if (!_detailVC) {
        _detailVC = [[WwToyDetailViewController alloc] init];
        _detailVC.wawa = self.wawa;
        _detailVC.view.frame = self.contentView.bounds;
    }
    return _detailVC;
}
@end
