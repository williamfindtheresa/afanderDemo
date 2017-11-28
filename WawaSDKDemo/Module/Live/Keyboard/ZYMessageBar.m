//
//  ZYMessageBar.m
//  WawaSDKDemo
//
//

#import "ZYMessageBar.h"
#import "ZYHotWordsView.h"
#import "Masonry.h"

@interface ZYMessageBar () <UITextFieldDelegate>

@property (nonatomic, strong) UIButton * hotBtn;
@property (nonatomic, strong) UITextField * textField;
@property (nonatomic, strong) UIButton * sendBtn;
@property (nonatomic, strong) UIView *vSpeView;
@property (nonatomic, strong) UIView *hSpeView;


@property (nonatomic, assign) CGRect keyboardLastFrame;

@property (nonatomic, strong) ZYHotWordsView *hotWordView;

@property (nonatomic, strong) WwUserModel * beChatedUser; /**< 被@ 的人*/

@end

@implementation ZYMessageBar

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSLog(@"%s",__func__);
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self customUI];
        [self addObserve];
    }
    return self;
}


#pragma mark - Public
- (BOOL)isActive
{
    return [self.textField isFirstResponder];
}

- (void)showKeyboard
{
    self.hidden = NO;
    if (self.isActive) {
        return;
    }
    [self.textField becomeFirstResponder];
}

- (void)showKeyboardChatUser:(WwUserModel *)chatUser //@Ta 聊天区跟人说活
{
    _beChatedUser = chatUser;
    self.textField.text = [NSString stringWithFormat:@"@%@ ",chatUser.nickname];
    [self showKeyboard];

}

- (void)closeKeyboard
{
    [self.textField resignFirstResponder];
    self.hidden = YES;
    [self.hotWordView removeFromSuperview];
}

- (void)clearChatText
{
    [self clearChatUser];
}

- (void)hotwordClick:(NSString *)hotword
{
    if ([self.delegate respondsToSelector:@selector(messageBar:sendMessage:)]) {
        [self.delegate messageBar:self sendMessage:hotword];
    }
}

#pragma mark - Action
- (void)clickHot {
    self.hotBtn.selected = !self.hotBtn.selected;
    //将hotwordview 直接贴在底部
    UIWindow *keyboardWindow = [self keyboardWindow];
    CGRect windowFrame = [self.superview  convertRect:self.frame toView:keyboardWindow];
    //将热词贴在底部
    CGFloat  y = CGRectGetMaxY(windowFrame);
    CGRect hotFrame = (CGRect){0,y,ScreenWidth,ScreenHeight - y };
    if (!self.hotWordView) {
        self.hotWordView = [[ZYHotWordsView alloc] initWithFrame:hotFrame];
        self.hotWordView.bar = self;
    }
    
    if (!self.hotWordView.superview) {
        self.hotWordView.frame = hotFrame;
        [keyboardWindow addSubview:self.hotWordView];
    }
    else {
        [self.hotWordView removeFromSuperview];
    }
}

- (void)clickSend
{
    if (self.hotWordView.superview) {
        [self.hotWordView removeFromSuperview];
        return;
    }
    
    if ([self.delegate respondsToSelector:@selector(messageBar:sendMessage:)]) {
        [self.delegate messageBar:self sendMessage:self.textField.text];
    }
    // 发送后清空
    [self clearChatUser];
}

#pragma mark - Helper

- (void)clearChatUser
{
    _beChatedUser = nil;
    self.textField.text = @"";
}

- (void)customUI
{
    self.backgroundColor = DVLColorGen(@"#fafafa");
    [self hotBtn];
    [self textField];
    [self sendBtn];
    [self vSpeView];
}

- (void)addObserve
{
    [self removeObserve];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

- (void)removeObserve
{
   [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
}


- (UIWindow *)keyboardWindow
{
    NSArray *windows = [UIApplication sharedApplication].windows;
    windows = [[windows reverseObjectEnumerator] allObjects];
    
    for(UIView *window in windows) {
        if([window isKindOfClass:NSClassFromString(@"UIRemoteKeyboardWindow")] ||
           [window isKindOfClass:NSClassFromString(@"UITextEffectsWindow")]
           ) {
            //键盘window
            return window;
        }
    }
    return nil;
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    UIView *v = [super hitTest:point withEvent:event];
    if ([v isKindOfClass:[UITextField class]]) {
        [self.hotWordView removeFromSuperview];
    }
    return v;
}

- (NSInteger)maxInputLength
{
    //@123 你好
    NSInteger maxlen = self.beChatedUser?20+self.beChatedUser.nickname.length + 2:20;
    return maxlen;
}

#pragma mark -  UIKeyboardWillChangeFrameNotification
// 比如切换键盘 升起来 消失
- (void)keyBoardWillChangeFrame:(NSNotification *)notify
{
    NSDictionary *userInfo = notify.userInfo;
    CGRect keyBoardEndFrame = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    UIViewAnimationCurve curve = [userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue];
    self.keyboardLastFrame = keyBoardEndFrame;
    [self  keyboardEndFrame:keyBoardEndFrame duration:duration animationCurve:curve];
}

- (CGFloat)widthScreen
{
    return ScreenWidth;
}

- (CGFloat)heightScreen
{
    return ScreenHeight;
}

- (CGFloat)topDisY
{
    CGFloat yDis;
    if (self.mayFitView != nil) {
        yDis = [self heightScreen] - CGRectGetHeight(self.frame); //
    }
    else {
        CGFloat keyboardHeight = MIN(self.keyboardLastFrame.size.width, self.keyboardLastFrame.size.height);
        yDis = [self heightScreen] - keyboardHeight - CGRectGetHeight(self.frame);
    }
    return yDis;
}


- (void)keyboardEndFrame:(CGRect)endframe duration:(CGFloat)dura animationCurve:(UIViewAnimationCurve)curve
{
    NSLog(@"endframe %@",NSStringFromCGRect(endframe));
    
    //键盘智能在底部吧
    CGFloat keyboardHeight = MIN(endframe.size.width, endframe.size.height);
    CGFloat keyboardTopY   = MAX(endframe.origin.x, endframe.origin.y);
    
    if (keyboardTopY >= [self heightScreen]) {
        
        [self hiddenSelfAnimateDuration:dura andCurve:curve];
        
        //键盘消失 maychangeview 回到原先位置
        [self.hotWordView removeFromSuperview];
    }
    else {
        if (self.textField.isFirstResponder == NO) {
            return; //fix:出现的时候自己都不是焦点，不更新吧。
        }
        [self showSelfAnimateDuration:dura andCurve:curve];
        
        //键盘出现 maychangeview 改变frame
        
    }
}

- (void)showSelfAnimateDuration:(CGFloat)dura andCurve:(UIViewAnimationCurve)curve
{
    //展示的
    [UIView animateKeyframesWithDuration:dura delay:0 options:(curve << 16 | UIViewAnimationOptionBeginFromCurrentState)  animations:^{
        
        CGRect rect = self.frame;
        rect.origin.y = [self topDisY];
        self.frame = rect;
        
    } completion:nil];
    
}

- (void)hiddenSelfAnimateDuration:(CGFloat)dura andCurve:(UIViewAnimationCurve)curve
{
    [UIView animateKeyframesWithDuration:dura delay:0 options:(curve << 16 | UIViewAnimationOptionBeginFromCurrentState)  animations:^{
        CGRect rect = self.frame;
        rect.origin.y = [self heightScreen];
        self.frame = rect;
    } completion:nil];
}


#pragma mark - UITextViewDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (!textField.text || !textField.text.length) {
        [self clearChatUser];
    }
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [textField becomeFirstResponder];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [textField resignFirstResponder];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self clickSend];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *tobeString = [textField.text  stringByReplacingCharactersInRange:range withString:string];
    //@ 切
    if (self.beChatedUser && tobeString.length <= self.beChatedUser.nickname.length + 1) {
        
        [self clearChatUser];
        return NO;
    }
    
    NSInteger maxlen = [self maxInputLength];
    if (tobeString.length > maxlen) {
        textField.text = [tobeString substringToIndex:maxlen];
        return NO;
    }
    return YES;
}


#pragma mark - Getter Setter
- (UIButton *)hotBtn
{
    if (!_hotBtn) {
        _hotBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:_hotBtn];
        [_hotBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self);
            make.centerY.equalTo(self);
            make.width.equalTo(@(48));
            make.height.equalTo(self);
        }];
        [_hotBtn setImage:[UIImage imageNamed:@"hot_bg_unselect"] forState:UIControlStateNormal];
        [_hotBtn setImage:[UIImage imageNamed:@"hot_bg_select"] forState:UIControlStateSelected];
        [_hotBtn addTarget:self action:@selector(clickHot) forControlEvents:UIControlEventTouchUpInside];
    }
    return _hotBtn;
}


- (UIButton *)sendBtn
{
    if (!_sendBtn) {
        _sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:_sendBtn];
        [_sendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self);
            make.centerY.equalTo(self);
            make.width.equalTo(@(58));
            make.height.equalTo(self);
        }];
        [_sendBtn setTitle:@"发送" forState:UIControlStateNormal];
        [_sendBtn setTitleColor:DVLColorGen(@"#4c4c4c") forState:UIControlStateNormal];
        [_sendBtn addTarget:self action:@selector(clickSend) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sendBtn;
}


- (UITextField *)textField
{
    if (!_textField) {
        _textField = [[UITextField alloc] init];
        _textField.backgroundColor = [UIColor clearColor];
        _textField.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        NSString * text = @"来一发试试";
        NSMutableAttributedString * atrr = [[NSMutableAttributedString alloc] initWithString:text];
        [atrr addAttribute:NSForegroundColorAttributeName value:DVLColorGen(@"#AEAEAE") range:NSMakeRange(0, text.length)];
//        _textField.placeholder = @"来一发试试";
        _textField.attributedPlaceholder = atrr;
        _textField.returnKeyType = UIReturnKeySend;
        _textField.delegate = self;
        _textField.font = [UIFont systemFontOfSize:17.0];
        _textField.textColor = DVLColorGen(@"#4c4c4c");
        [self addSubview:_textField];
        @weakify(self);
        [_textField mas_makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.centerY.equalTo(self);
            CGFloat left = 64;
            make.left.equalTo(self).offset(left);
            make.right.equalTo(self.sendBtn.mas_left).offset(-10);
            make.height.equalTo(@(30));
        }];
    }
    return _textField;
}

- (UIView *)vSpeView
{
    if (!_vSpeView) {
        _vSpeView = [[UIView alloc] init];
        [self addSubview:_vSpeView];
        _vSpeView.backgroundColor = DVLColorGen(@"#aeaeae");
        [_vSpeView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).offset(-55);
            make.width.equalTo(@(1));
            make.top.equalTo(self).offset(9);
            make.bottom.equalTo(self).offset(-9);
        }];
    }
    return _vSpeView;
}

- (UIView *)hSpeView
{
    return nil;
    if (!_hSpeView) {
        _hSpeView = [[UIView alloc] init];
        [self addSubview:_hSpeView];
        _hSpeView.backgroundColor = DVLColorGen(@"#aeaeae");
        [_hSpeView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self);
            make.height.equalTo(@(1));
            make.bottom.equalTo(self);
        }];
    }
    return _hSpeView;
}

- (BOOL)isFirstResponder {
    return self.textField.isFirstResponder;
}

@end
