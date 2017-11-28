//
//  WwWatchOperationView.m
//

#import "WwWatchOperationView.h"

#define  FontSizeNumber 15

@interface WwWatchOperationView () {
    BOOL _operationDisable;
}

@property (weak, nonatomic) IBOutlet UIView *payContainerView;

@end


@implementation WwWatchOperationView

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self.rechargeBtn setTitleEdgeInsets:UIEdgeInsetsMake(-1, 0, 0, 0)];
    

    [self adjustExchangeBtnArrowPos];
    
    [_startBtn setImage:[UIImage imageNamed:@"start_game_disable"] forState:UIControlStateDisabled];
    [_startBtn addTarget:self action:@selector(onButtonPressed:) forControlEvents:UIControlEventTouchDown];
    
    //按钮外界抬起
    [_startBtn addTarget:self action:@selector(onButtonTouchInside:) forControlEvents:UIControlEventTouchUpOutside];
    
    [_startBtn addTarget:self action:@selector(onButtonTouchInside:) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)adjustExchangeBtnArrowPos {
    UIImage *arrowImg = [UIImage imageNamed:@"start_arrow"];
    CGFloat imageWidth = arrowImg.size.width;
    [_exchangeBtn.titleLabel sizeToFit];
    CGFloat titleWidth = _exchangeBtn.titleLabel.frame.size.width;
    [_exchangeBtn setImageEdgeInsets:UIEdgeInsetsMake(0,titleWidth+2,0,-titleWidth)];
    [_exchangeBtn setTitleEdgeInsets:UIEdgeInsetsMake(0,-imageWidth,0,imageWidth)];
}

- (BOOL)operationDisable {
    return _operationDisable;
}

- (void)setOperationDisable:(BOOL)operationDisable {
    if (_operationDisable != operationDisable) {
        _operationDisable = operationDisable;
        _startBtn.enabled = !operationDisable;
    }
}


#pragma mark - Public

+ (instancetype)watchOperationView {
    WwWatchOperationView * view = [[NSBundle mainBundle] loadNibNamed:@"WwWatchOperationView" owner:nil options:nil].lastObject;
    return view;
}


#pragma mark - Action
- (void)onButtonPressed:(UIButton *)button {
    if (button == _startBtn) {
        NSLog(@"start pressed, %s", __PRETTY_FUNCTION__);
        [button setImage:[UIImage imageNamed:@"start_game_press"] forState:UIControlStateHighlighted];
        CGRect frame = _wawaPriceLabel.frame;
        _wawaPriceLabel.frame = CGRectMake(frame.origin.x, frame.origin.y+3, frame.size.width, frame.size.height);
    }
}

- (void)onButtonTouchInside:(UIButton *)button {
    if (button == _startBtn) {
        NSLog(@"start released, %s", __PRETTY_FUNCTION__);
        CGRect frame = _wawaPriceLabel.frame;
        _wawaPriceLabel.frame = CGRectMake(frame.origin.x, frame.origin.y-3, frame.size.width, frame.size.height);
    }
}

- (IBAction)onExchangeButtonClicked:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(onExchangeClicked:)]) {
        [self.delegate onExchangeClicked:sender];
    }
}

- (IBAction)onBalanceButtonClicked:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(onBalanceClicked:)]) {
        [self.delegate onBalanceClicked:sender];
    }
}

- (IBAction)onChatButtonClicked:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(onChatClicked:)]) {
        [self.delegate onChatClicked:_chatButton];
    }
}

- (IBAction)onStartButtonClicked:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(onStartClicked:)]) {
        [self.delegate onStartClicked:_startBtn];
    }
}

- (IBAction)showTipAction:(id)sender {
    NSString *toastPreparing = @"娃娃正在补货中,请稍候…";
    NSString *toastPlaying = @"别的玩家正在游戏中";
    
    NSString * resultStr = self.roomState == 1 ? toastPreparing : toastPlaying;
}

- (IBAction)onShareButtonClicked:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(onShareClicked:)]) {
        [self.delegate onShareClicked:_shareBtn];
    }
}

- (IBAction)onChargeClicked:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(onRechargeClicked:)]) {
        [self.delegate onRechargeClicked:_rechargeBtn];
    }
}


@end
