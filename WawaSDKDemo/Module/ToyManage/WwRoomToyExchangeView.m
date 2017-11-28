//
//  WwRoomToyExchangeView.m
//  prizeClaw
//


#import <Foundation/Foundation.h>
#import "WwRoomToyExchangeView.h"
#import "WwRoomWawaExchangeViewController.h"

@interface WwRoomToyExchangeView ()
//背景View
@property (weak, nonatomic) IBOutlet UIView *backgroundView;
//内容View
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (nonatomic, strong) WwRoomWawaExchangeViewController *exchangeVC;

@end

@implementation WwRoomToyExchangeView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(toyCheckRemoveFromSuperview)];
    [self.backgroundView addGestureRecognizer:gesture];
}

+ (instancetype)instanceToyExchangeView {
    return [[[NSBundle mainBundle] loadNibNamed:@"WwRoomToyExchangeView" owner:nil options:nil] lastObject];
}

- (void)showInstanceView {
    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    self.frame = window.bounds;
    [window addSubview:self];
    [self.contentView addSubview:self.exchangeVC.view];
    self.y = ScreenHeight;
    self.backgroundView.alpha = 0.f;
    self.contentView.backgroundColor = RGBCOLOR(250, 250, 250);
    [UIView animateWithDuration:0.2 animations:^{
        self.y = 0;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.1 animations:^{
            self.backgroundView.alpha = 0.2;
        }];
    }];
}

- (void)toyCheckRemoveFromSuperview {
    [self colseButtonClick:nil];
    self.exchangeVC = nil;
}

- (IBAction)colseButtonClick:(UIButton *)btn {
    self.y = 0;
    self.backgroundView.alpha = 0.0;
    [UIView animateWithDuration:0.3 animations:^{
        self.y = ScreenHeight;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (WwRoomWawaExchangeViewController *)exchangeVC {
    if (!_exchangeVC) {
        _exchangeVC = [[WwRoomWawaExchangeViewController alloc] init];
        _exchangeVC.view.frame = self.contentView.bounds;
    }
    return _exchangeVC;
}
@end
