 //
//  WwGameResultView.m
//  prizeClaw
//
//  Created by 刘昊 on 2017/10/8.
//  Copyright © 2017年 QuanMin.ShouYin. All rights reserved.
//

#import "WwGameResultView.h"
#import "NSTimer+EOCBlocksSupport.h"
#import "WwShareAudioPlayer.h"


#define kAnimationDurtion 0.5

@interface WwGameResultView()

@property (weak, nonatomic) IBOutlet UIView *baseV;

@property (weak, nonatomic) IBOutlet UIImageView *wawaImgV;     /**< 娃娃图片*/

@property (weak, nonatomic) IBOutlet UIButton *leftBtn;         /**< 左边按钮*/

@property (weak, nonatomic) IBOutlet UIView *showBaseV;         /**< 赠送鱼丸底图*/

@property (weak, nonatomic) IBOutlet UILabel *showLeftLab;

@property (weak, nonatomic) IBOutlet UILabel *showRightLab;

@property (weak, nonatomic) IBOutlet UIButton *rightBtn;        /**< 右边按钮*/

@property (nonatomic, strong) NSTimer * timer;                  /**< 请求定时器*/

@property (nonatomic, assign) NSInteger requestCount;           /**< 请求次数*/

@property (nonatomic, strong) WwGameResultModel * resultM;      /**< 结果数据*/

@property (nonatomic, assign) NSInteger countDown;              /**< 倒计时*/

@property (nonatomic, strong) NSTimer * countDownTimer;         /**< 倒计时定时器*/

@end

@implementation WwGameResultView

- (void)awakeFromNib {
    [super awakeFromNib];
}

#pragma mark - Public
+ (instancetype)gameResultView {
    WwGameResultView * resultV = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil].lastObject;
    safe_async_main(^{
        resultV.hidden = YES;
        resultV.width = ScreenWidth;
        resultV.height = ScreenHeight;
    });
    return resultV;
}

- (void)show {
    [UIView animateWithDuration:kAnimationDurtion animations:^{
        self.hidden = NO;
    } completion:^(BOOL finished) {
        [[WwShareAudioPlayer shareAudioPlayer] playResultAudioWithFile:self.resultM.state == 2 ? @"game_result_success" : @"game_result_fail" ofType:@"mp3"];
    }];
}

- (void)dismissWithCompletion:(void(^)())block {
    self.isResultHandleing = NO;
    // 这个地方的调用为防止外界调用dismiss接口, 内部调用自己去调用结束倒计时接口, 逻辑会清晰一些
    [self endCountDownTimer];
    [UIView animateWithDuration:kAnimationDurtion animations:^{
        self.hidden = YES;
    } completion:^(BOOL finished) {
        [[WwShareAudioPlayer shareAudioPlayer] stopResultPlayer];
        if (block) {
            block();
        }
    }];
}

- (void)startRequestResult {
    // 标记当前处理状态
    self.isResultHandleing = YES;
    // 归零数据
    [self resetUIData];
   
}

#pragma mark - Private
// 重置界面元素
- (void)resetUIData {
    @weakify(self);
    safe_async_main(^{
        @strongify(self);
        self.wawaImgV.image = nil;
        self.hidden = YES;
    });
}

// 处理游戏结果
- (void)handleGameResult:(WwGameResultModel *)model {
    // step1 通知外界,获取到结果了
    if ([self.delegate respondsToSelector:@selector(hadCompleteResultRequest)]) {
        [self.delegate hadCompleteResultRequest];
    }
    // step2 记录游戏结果
    self.resultM = model;
    // step3 展示结果
    safe_async_main((^{
        NSString * countTime = [NSString stringWithFormat:@"用时%ld秒",(long)model.playTimes];
        NSString * coinStr = [NSString stringWithFormat:@"x%ld",(long)model.awardFishball];
        
        self.showLeftLab.text = countTime;
        self.showRightLab.text = coinStr;
        
        NSString * backImgStr = @"";
        if (model.state == 2) {
            // 抓取成功
            self.countDown = 8;
            [self.leftBtn setTitle:@"分享得金币" forState:UIControlStateNormal];
            backImgStr = @"game_result_back_success";
        }
        else {
            self.countDown = 8;
            [self.leftBtn setTitle:@"抓娃娃技巧" forState:UIControlStateNormal];
            backImgStr = @"game_result_back_fail";
        }
        
        self.wawaImgV.image = [UIImage imageNamed:backImgStr];
        [self startCountDownTimer];
        
        [self show];
    }));
}


// 倒计时正常结束了
- (void)countDownComplete {
    [self dismissWithCompletion:nil];
}


// 开启倒计时定时器
- (void)startCountDownTimer {
    [self endCountDownTimer];
    safe_async_main((^{
        UIButton * btn = self.rightBtn;
        NSString * headerStr = self.resultM.state == 2 ? @"再来一局" : @"再来一次";
        [btn setTitle:[NSString stringWithFormat:@"%@(%ld)",headerStr,self.countDown] forState:UIControlStateNormal];
        @weakify(self);
        self.countDownTimer = [NSTimer eoc_scheduledTimerWithTimeInterval:1 block:^{
            @strongify(self);
            self.countDown --;
            UIButton * button = self.rightBtn;
            [button setTitle:[NSString stringWithFormat:@"%@(%ld)",headerStr,self.countDown] forState:UIControlStateNormal];
            if (self.countDown <= 0) {
                // 停止倒计时
                [self endCountDownTimer];
                // 消失自己
                [self dismissWithCompletion:^{
                    // 自己已消失,为下机处理,通知外界做下机逻辑
                    if ([self.delegate respondsToSelector:@selector(endGameAndStopPush)]) {
                        [self.delegate endGameAndStopPush];
                    }
                    // 此时不用释放服务器资源, 客户端流程和服务端一致, 交给服务端自己处理就好
                }];
            }
        } repeats:YES];
    }));
}


// 结束倒计时定时器
- (void)endCountDownTimer {
    if ([self.countDownTimer isValid]) {
        [self.countDownTimer invalidate];
    }
    self.countDownTimer = nil;
}

// 结束请求定时器
- (void)endRequestTimer {
    if ([self.timer isValid]) {
        [self.timer invalidate];
    }
    self.timer = nil;
    self.requestCount = 0;
}

#pragma mark - Action
- (IBAction)closeAction:(id)sender {
    // 停止倒计时计时器
    [self endCountDownTimer];
    // 消失自己
    [self dismissWithCompletion:nil];
    // 自己已消失,默认为下机处理,通知外界做下机逻辑
    if ([self.delegate respondsToSelector:@selector(endGameAndStopPush)]) {
        [self.delegate endGameAndStopPush];
    }
    // 调用关闭逻辑
    if ([self.delegate respondsToSelector:@selector(callReleaseLogic)]) {
        [self.delegate callReleaseLogic];
    }
}

- (IBAction)leftAction:(id)sender {
    // 停止倒计时计时器
    [self endCountDownTimer];
    // 消失自己
    [self dismissWithCompletion:^{
        // 左边按钮是分享, 通知外界弹分享界面出来
        if ([self.delegate respondsToSelector:@selector(gameResultShareResult:)]) {
            [self.delegate gameResultShareResult:self.resultM];
        }
    }];
    
    // 自己已消失,默认为下机处理,通知外界做下机逻辑
    if ([self.delegate respondsToSelector:@selector(endGameAndStopPush)]) {
        [self.delegate endGameAndStopPush];
    }
    
    // 调用释放服务器资源的逻辑
    if ([self.delegate respondsToSelector:@selector(callReleaseLogic)]) {
        [self.delegate callReleaseLogic];
    }
}

- (IBAction)rightAction:(id)sender {
    // 右边按钮是再来一次, 通知外界处理逻辑
    if ([self.delegate respondsToSelector:@selector(playAgain)]) {
        [self.delegate playAgain];
    }
    // 停止倒计时
    [self endCountDownTimer];
    // 消失自己
    [self dismissWithCompletion:nil];
}

#pragma mark - TouchDelegate
//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    UITouch * touch = touches.anyObject;
//    CGPoint locationP = [touch locationInView:self];
//    if (!CGRectContainsPoint(self.baseV.frame, locationP)) {
//        // 点击空白区域和点击关闭按钮的逻辑一样
//        [self closeAction:nil];
//    }
//}


#pragma mark - Dealloc
- (void)dealloc {
    [self endRequestTimer];
    [self endCountDownTimer];
}

@end
