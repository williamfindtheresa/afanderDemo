//
//  WwOnLooksView.m
//  prizeClaw
//
//  Created by 刘昊 on 2017/10/12.
//  Copyright © 2017年 QuanMin.ShouYin. All rights reserved.
//

#import "WwOnLooksView.h"
#import "NSString+WawaKit.h"
#import "NSTimer+EOCBlocksSupport.h"

static NSString * kGoodNetTips = @"网络极好,可畅玩游戏";
static NSString * kWarnNetTips = @"网络波动,略影响体验";
static NSString * kErrorNetTips = @"网络较差,请谨慎上机";

@interface WwOnLooksView() <WwPingViewDelegate>

@property (nonatomic, strong) NSTimer * showTimer;                  /**< 展示定时器*/

@property (nonatomic, strong) UIButton * btn;                       /**< 按钮*/

@end

@implementation WwOnLooksView

#pragma mark - Public
+ (instancetype)onlooksView {
    WwOnLooksView * onlooksV = [[WwOnLooksView alloc] initWithFrame:CGRectMake(0, 0, 150, 20)];
    [onlooksV customUI];
    return onlooksV;
}

- (void)updateOnLooksNum:(NSInteger)num {
    self.onLooks = num;
    if (![self.showTimer isValid]) {
        [self handleOnLooks];
    }
}

#pragma mark - Private
- (void)customUI {
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
    self.layer.cornerRadius = self.height / 2.0;
    self.clipsToBounds = YES;
    self.userInteractionEnabled = YES;
    [self addSubview:self.looksLab];
    [self addSubview:self.pingV];
    [self addSubview:self.btn];
        
    [self calculateSize];
}

// 开启展示定时器
- (void)startShowTimer {
    [self stopShowTimer];
    @weakify(self);
    self.showTimer = [NSTimer eoc_scheduledTimerWithTimeInterval:2 block:^{
        @strongify(self);
        // 置空定时器
        [self stopShowTimer];
        // 展示人数
        [self handleOnLooks];
    } repeats:NO];
}

// 停止展示定时器
- (void)stopShowTimer {
    if ([self.showTimer isValid]) {
        [self.showTimer invalidate];
    }
    self.showTimer = nil;
}

// 计算尺寸
- (void)calculateSize {
    safe_async_main(^{
        CGFloat labWidth = [self.looksLab.text sizeWithFont:self.looksLab.font andMaxSize:CGSizeMake(200, self.looksLab.height)].width + 2;
        
        self.pingV.centerY = self.height / 2.0;
        self.looksLab.centerY = self.pingV.centerY;
        
        CGFloat right = self.right;
        
        [UIView animateWithDuration:0.3 animations:^{
            self.width = labWidth + 30 + 5 + self.pingV.width;
            self.right = right;
            
            self.pingV.right = self.width - 15;
            self.looksLab.width = labWidth;
            self.looksLab.left = 15;
        } completion:^(BOOL finished) {
            self.btn.frame = self.bounds;
        }];
    });
}

// 处理围观人数
- (void)handleOnLooks {
    safe_async_main((^{
        self.looksLab.text = [NSString stringWithFormat:@"%ld人围观",(long)MAX(self.onLooks, 0)];
        [self calculateSize];
        self.btn.enabled = YES;
    }));
}

// 处理网络提醒
- (void)handleNetTips {
    NSInteger ping = self.pingV.ping;
    NSString * netTip = @"";
    if (ping <= 100) {
        netTip = kGoodNetTips;
    } else if (ping <= 300) {
        netTip = kWarnNetTips;
    } else {
        netTip = kErrorNetTips;
    }
    safe_async_main((^{
        self.looksLab.text = netTip;
        if (![self.showTimer isValid]) {
            [self calculateSize];
        }
        [self startShowTimer];
        self.btn.enabled = NO;
    }));
}

#pragma mark - Action
- (void)clickAction {
    [self handleNetTips];
}

#pragma mark - WwPingViewDelegate
- (void)netStatusDidChangd:(WwPingView *)pingV {
    // 判断当前网络延迟多少
    NSInteger ping = pingV.ping;
    if (ping <= 100) {
//        if (![self.looksLab.text isEqualToString:kGoodNetTips]) {
//            [self handleNetTips];
//        }
        [self handleOnLooks];
    } else if (ping <= 300) {
        [self handleOnLooks];
    } else {
        [self handleNetTips];
    }
}


#pragma mark - SetterAndGetter
- (UILabel *)looksLab {
    if (!_looksLab) {
        _looksLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 20)];
        _looksLab.font = [UIFont systemFontOfSize:12.f];
        _looksLab.clipsToBounds = YES;
        _looksLab.text = @"0人围观";
        _looksLab.textColor = [UIColor whiteColor];
    }
    return _looksLab;
}

- (WwPingView *)pingV {
    if (!_pingV) {
        _pingV = [[WwPingView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
        _pingV.layer.cornerRadius = 5;
        _pingV.delegate = self;
        _pingV.clipsToBounds = YES;
    }
    return _pingV;
}

- (UIButton *)btn {
    if (!_btn) {
        _btn = [UIButton buttonWithType:UIButtonTypeCustom];
        _btn.backgroundColor = [UIColor clearColor];
        [_btn addTarget:self action:@selector(clickAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btn;
}

#pragma mark - Dealloc
- (void)dealloc {
    [_showTimer invalidate];
    [_pingV endPing];
}

@end
