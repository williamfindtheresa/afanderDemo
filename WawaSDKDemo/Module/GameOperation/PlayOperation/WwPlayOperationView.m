//
//  WwPlayOperationView.m
//  prizeClaw
//
//  Created by GrayLocus on 2017/10/2.
//  Copyright © 2017年 QuanMin.ShouYin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WwPlayOperationView.h"
#import "WwShareAudioPlayer.h"


static NSTimeInterval LPressTimerInteraval = 0.1f; // 秒
static NSTimeInterval RPressTimerInteraval = 0.05f; // 秒

@interface WwPlayOperationView () {
    BOOL _operationDisable;
}

@property (nonatomic, copy) NSArray *directionArray;
@property (nonatomic, copy) NSArray *currDirs;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *confirmBtn_trailing;

@end

@implementation WwPlayOperationView

+ (instancetype)operationView {
    WwPlayOperationView * view = [[NSBundle mainBundle] loadNibNamed:@"WwPlayOperationView" owner:nil options:nil].lastObject;

    [view initUI];
    [view initData];
    
    return view;
}

- (void)initUI {
    // 添加Disable图标
    [_upBtn setImage:[UIImage imageNamed:@"op_disable_up"] forState:UIControlStateDisabled];
    [_downBtn setImage:[UIImage imageNamed:@"op_disable_down"] forState:UIControlStateDisabled];
    [_leftBtn setImage:[UIImage imageNamed:@"op_disable_left"] forState:UIControlStateDisabled];
    [_rightBtn setImage:[UIImage imageNamed:@"op_disable_right"] forState:UIControlStateDisabled];
    [_confirmBtn setImage:[UIImage imageNamed:@"op_disable_confirm"] forState:UIControlStateDisabled];
    
    if (ScreenWidth < 370) {
        for (UIButton * btn in @[_upBtn,_downBtn,_leftBtn,_rightBtn]) {
            btn.left -= 18;
        }
        self.confirmBtn_trailing.constant = 10;
    }
    
    // 添加Target-Action
    // 上
    [_upBtn addTarget:self action:@selector(onButtonPressed:) forControlEvents:UIControlEventTouchDown];
    [_upBtn addTarget:self action:@selector(onButtonTouchInside:) forControlEvents:UIControlEventTouchUpInside];
    
    // 下
    [_downBtn addTarget:self action:@selector(onButtonPressed:) forControlEvents:UIControlEventTouchDown];
    [_downBtn addTarget:self action:@selector(onButtonTouchInside:) forControlEvents:UIControlEventTouchUpInside];
    
    // 左
    [_leftBtn addTarget:self action:@selector(onButtonPressed:) forControlEvents:UIControlEventTouchDown];
    [_leftBtn addTarget:self action:@selector(onButtonTouchInside:) forControlEvents:UIControlEventTouchUpInside];
    
    // 右
    [_rightBtn addTarget:self action:@selector(onButtonPressed:) forControlEvents:UIControlEventTouchDown];
    [_rightBtn addTarget:self action:@selector(onButtonTouchInside:) forControlEvents:UIControlEventTouchUpInside];
    
    [_confirmBtn addTarget:self action:@selector(onButtonPressed:) forControlEvents:UIControlEventTouchDown];
    [_confirmBtn addTarget:self action:@selector(onButtonTouchInside:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)initData {
    _directionArray = @[
                        @[@(PlayDirection_Up), @(PlayDirection_Left), @(PlayDirection_Down), @(PlayDirection_Right)], // 上，左，下，右
                        @[@(PlayDirection_Right), @(PlayDirection_Up), @(PlayDirection_Left), @(PlayDirection_Down)], // 右，上，左，下
                        @[@(PlayDirection_Left), @(PlayDirection_Down), @(PlayDirection_Right), @(PlayDirection_Up)]  // 左，下，右，上
                        ];
    _currDirs = _directionArray[CameraDirection_Front];
}

#pragma mark - Public Methods
- (BOOL)operationDisable {
    return _operationDisable;
}

- (void)setOperationDisable:(BOOL)operationDisable {
    if (_operationDisable != operationDisable) {
        _operationDisable = operationDisable;
        _upBtn.enabled = !operationDisable;
        _downBtn.enabled = !operationDisable;
        _leftBtn.enabled = !operationDisable;
        _rightBtn.enabled = !operationDisable;
        _confirmBtn.enabled = !operationDisable;
    }
}

- (void)setCameraDir:(CameraDirection)cameraDir {
    if (_cameraDir != cameraDir) {
        _cameraDir = cameraDir;
        _currDirs = _directionArray[cameraDir];
    }
}

- (PlayDirection)mapRelativeDirection:(PlayDirection)btnDir {
    PlayDirection dir = [_currDirs[btnDir] integerValue];
    return dir;
}

- (IBAction)onUpButtonClicked:(UIButton *)sender {
    [self onButtonClicked:sender];
}

- (IBAction)onLeftButtonClicked:(UIButton *)sender {
    [self onButtonClicked:sender];
}

- (IBAction)onDownButtonClicked:(UIButton *)sender {
    [self onButtonClicked:sender];
}


- (IBAction)onRightButtonClicked:(UIButton *)sender {
    [self onButtonClicked:sender];
}

- (IBAction)onConfirmButtonClicked:(UIButton *)sender {
    [self onButtonClicked:sender];
}

- (void)onButtonPressed:(UIButton *)sender {
    OBShapedButton *button = (OBShapedButton *)sender;
    BOOL startLongPress = YES;
    if (button == self.upBtn) {
        NSLog(@"%s: up", __PRETTY_FUNCTION__);
        [button setImage:[UIImage imageNamed:@"op_press_up"] forState:UIControlStateHighlighted];
    }
    else if (button == self.downBtn) {
        NSLog(@"%s: down", __PRETTY_FUNCTION__);
        [button setImage:[UIImage imageNamed:@"op_press_down"] forState:UIControlStateHighlighted];
    }
    else if (button == self.leftBtn) {
        NSLog(@"%s: left", __PRETTY_FUNCTION__);
        [button setImage:[UIImage imageNamed:@"op_press_left"] forState:UIControlStateHighlighted];
    }
    else if (button == self.rightBtn) {
        NSLog(@"%s: right", __PRETTY_FUNCTION__);
        [button setImage:[UIImage imageNamed:@"op_press_right"] forState:UIControlStateHighlighted];
    }
    else if (button == self.confirmBtn) {
        NSLog(@"%s: confirm", __PRETTY_FUNCTION__);
        startLongPress = NO;
        [button setImage:[UIImage imageNamed:@"op_press_confirm"] forState:UIControlStateHighlighted];
    }
    
    [self invalidTimerByButton:button clearTimer:YES];
    // 开始长压timer
    if (startLongPress) {
        button.longPTimer = [NSTimer scheduledTimerWithTimeInterval:LPressTimerInteraval target:self selector:@selector(longPressTimeOut:) userInfo:@{@"btn":button} repeats:NO];
    }
    // 播放音效
    [self playSoundWithButton:button];
}

- (void)onButtonClicked:(UIButton *)sender {
    NSLog(@"%s: up", __PRETTY_FUNCTION__);
    OBShapedButton *button = (OBShapedButton *)sender;
    if ([button.longPTimer isValid]) {
        // 1.清空timer
        [button.longPTimer invalidate];
        button.longPTimer = nil;
    }
    else {
        if (button != self.confirmBtn) {
            // 下抓按钮没有长压
            return;
        }
    }
    
    if (button == self.upBtn) {
        NSLog(@"%s: up", __PRETTY_FUNCTION__);
        [button setImage:[UIImage imageNamed:@"op_press_up"] forState:UIControlStateFocused];
        if ([self.delegate respondsToSelector:@selector(onPlayDirection:operationType:)]) {
            [self.delegate onPlayDirection:[self mapRelativeDirection:PlayDirection_Up] operationType:PlayOperationType_Click];
        }
    }
    else if (button == self.downBtn) {
        NSLog(@"%s: down", __PRETTY_FUNCTION__);
        [button setImage:[UIImage imageNamed:@"op_press_down"] forState:UIControlStateSelected];
        if ([self.delegate respondsToSelector:@selector(onPlayDirection:operationType:)]) {
            [self.delegate onPlayDirection:[self mapRelativeDirection:PlayDirection_Down] operationType:PlayOperationType_Click];
        }
    }
    else if (button == self.leftBtn) {
        NSLog(@"%s: left", __PRETTY_FUNCTION__);
        [button setImage:[UIImage imageNamed:@"op_press_left"] forState:UIControlStateFocused];
        if ([self.delegate respondsToSelector:@selector(onPlayDirection:operationType:)]) {
            [self.delegate onPlayDirection:[self mapRelativeDirection:PlayDirection_Left] operationType:PlayOperationType_Click];
        }
    }
    else if (button == self.rightBtn) {
        NSLog(@"%s: right", __PRETTY_FUNCTION__);
        [button setImage:[UIImage imageNamed:@"op_press_right"] forState:UIControlStateFocused];
        if ([self.delegate respondsToSelector:@selector(onPlayDirection:operationType:)]) {
            [self.delegate onPlayDirection:[self mapRelativeDirection:PlayDirection_Right] operationType:PlayOperationType_Click];
        }
    }
    else if (button == self.confirmBtn) {
        NSLog(@"%s: confirm", __PRETTY_FUNCTION__);
        [button setImage:[UIImage imageNamed:@"op_press_confirm"] forState:UIControlStateFocused];
        if ([self.delegate respondsToSelector:@selector(onPlayDirection:operationType:)]) {
            [self.delegate onPlayDirection:PlayDirection_Confirm operationType:PlayOperationType_Click];
        }
    }
    // 播放音效
    [self playSoundWithButton:button];
}

- (void)onButtonTouchInside:(UIButton *)sender {
    OBShapedButton *button = (OBShapedButton *)sender;
    BOOL sendRelease = YES;
    if (!button.longPTimer) {
        // timer 被置空，不发送release事件
        sendRelease = NO;
    }
    // 2.清空timer
    button.longPTimer = nil;
    
    PlayDirection direction = PlayDirection_None;
    if (button == self.upBtn) {
        NSLog(@"%s: up", __PRETTY_FUNCTION__);
        direction = [self mapRelativeDirection:PlayDirection_Up];
    }
    else if (button == self.downBtn) {
        NSLog(@"%s: down", __PRETTY_FUNCTION__);
        direction = [self mapRelativeDirection:PlayDirection_Down];
    }
    else if (button == self.leftBtn) {
        NSLog(@"%s: left", __PRETTY_FUNCTION__);
        direction = [self mapRelativeDirection:PlayDirection_Left];
    }
    else if (button == self.rightBtn) {
        NSLog(@"%s: right", __PRETTY_FUNCTION__);
        direction = [self mapRelativeDirection:PlayDirection_Right];
    }
    else if (button == self.confirmBtn) {
        NSLog(@"%s: confirm", __PRETTY_FUNCTION__);
        direction = PlayDirection_Confirm;
    }
    
    if (sendRelease) {
        PlayOperationType opType = PlayOperationType_Release;
        if ([button.reversePTimer isValid]) {
            // Note: 如果未超时，发送一个reverse事件
            opType = PlayOperationType_Reverse;
        }
        
        if ([self.delegate respondsToSelector:@selector(onPlayDirection:operationType:)]) {
            [self.delegate onPlayDirection:direction operationType:opType];
        }
    }
    // 播放音效
    [self playSoundWithButton:button];
}

- (void)invalidTimerByButton:(OBShapedButton *)button clearTimer:(BOOL)clear{
    // 清空timer
    if (button && [button.longPTimer isValid]) {
        [button.longPTimer invalidate];
        if (clear) {
            button.longPTimer = nil;
        }
    }
}

- (void)longPressTimeOut:(NSTimer *)timer {
    NSDictionary *userInfo = [timer userInfo];
    UIButton *sender = userInfo[@"btn"];
    OBShapedButton *button = (OBShapedButton *)sender;
    
    if (button == self.upBtn) {
        NSLog(@"%s: up", __PRETTY_FUNCTION__);
    }
    else if (button == self.downBtn) {
        NSLog(@"%s: down", __PRETTY_FUNCTION__);
    }
    else if (button == self.leftBtn) {
        NSLog(@"%s: left", __PRETTY_FUNCTION__);
    }
    else if (button == self.rightBtn) {
        NSLog(@"%s: right", __PRETTY_FUNCTION__);
    }
    [self onButtonLongPressed:sender];
    
    // 开始校验reverse的timer
    [self startReverseTimerByButton:button];
}

- (void)reverseLongPressTimeOut:(NSTimer *)timer {
    NSDictionary *userInfo = [timer userInfo];
    UIButton *button = userInfo[@"btn"];
    if (button == self.upBtn) {
        NSLog(@"%s: up", __PRETTY_FUNCTION__);
    }
    else if (button == self.downBtn) {
        NSLog(@"%s: down", __PRETTY_FUNCTION__);
    }
    else if (button == self.leftBtn) {
        NSLog(@"%s: left", __PRETTY_FUNCTION__);
    }
    else if (button == self.rightBtn) {
        NSLog(@"%s: right", __PRETTY_FUNCTION__);
    }
}

- (void)startReverseTimerByButton:(OBShapedButton *)button {
    if ([button.reversePTimer isValid]) {
        [button.reversePTimer invalidate];
        button.reversePTimer = nil;
    }
    
    button.reversePTimer = [NSTimer scheduledTimerWithTimeInterval:RPressTimerInteraval target:self selector:@selector(reverseLongPressTimeOut:) userInfo:@{@"btn":button} repeats:NO];
}

- (void)onButtonLongPressed:(UIButton *)sender {
    PlayDirection direction = PlayDirection_None;
    if (sender == self.upBtn) {
        NSLog(@"%s: up", __PRETTY_FUNCTION__);
        direction = [self mapRelativeDirection:PlayDirection_Up];
    }
    else if (sender == self.downBtn) {
        NSLog(@"%s: down", __PRETTY_FUNCTION__);
        direction = [self mapRelativeDirection:PlayDirection_Down];
    }
    else if (sender == self.leftBtn) {
        NSLog(@"%s: left", __PRETTY_FUNCTION__);
        direction = [self mapRelativeDirection:PlayDirection_Left];
    }
    else if (sender == self.rightBtn) {
        NSLog(@"%s: right", __PRETTY_FUNCTION__);
        direction = [self mapRelativeDirection:PlayDirection_Right];
    }
    
    if ([self.delegate respondsToSelector:@selector(onPlayDirection:operationType:)]) {
        [self.delegate onPlayDirection:direction operationType:PlayOperationType_LongPress];
    }
    // 播放音效
    [self playSoundWithButton:sender];
}

#pragma mark - PlaySound
- (void)playSoundWithButton:(UIButton *)button {
    NSString * soundName = @"music_touch_operation";
//    if (button == self.upBtn) {
//        soundName = @"music_touch_up";
//    }
//    else if (button == self.downBtn) {
//        soundName = @"music_touch_down";
//    }
//    else if (button == self.leftBtn) {
//        soundName = @"music_touch_left";
//    }
//    else if (button == self.rightBtn) {
//        soundName = @"music_touch_right";
//    }
//    else if (button == self.confirmBtn) {
//        soundName = @"music_touch_confirm";
//    }
    if (!soundName.length) {
        return;
    }
    NSString * filePath = [[NSBundle mainBundle] pathForResource:soundName ofType:@"mp3"];
    if (filePath.length) {
        [[WwShareAudioPlayer shareAudioPlayer] playClickAudioWithFile:soundName ofType:@"mp3"];
    }
}

@end
