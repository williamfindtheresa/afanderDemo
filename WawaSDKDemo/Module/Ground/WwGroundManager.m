//
//  WwGroundManager.m
//  prizeClaw
//
//  Created by yuyou on 2017/10/3.
//  Copyright © 2017年 QuanMin.ShouYin. All rights reserved.
//

#import "WwGroundManager.h"
#import "GrounderModel.h"
#import "GrounderSuperView.h"
#import "WwLiveInteractiveView.h"

@interface WwGroundManager ()

@property (nonatomic, strong) GrounderSuperView *barrageSuperView;

@property (nonatomic, assign) NSInteger roomID;

@end

@implementation WwGroundManager

#pragma mark - Public
- (void)reciveBarrage:(GrounderModel *)grounderModel /**< 发送票屏弹幕*/
{
    [self sendbarrage:grounderModel];
}

- (void)sendBarrageText:(NSString *)barrageText  /**< 发送聊天或者弹幕*/
{
    //如果全是空格 做处理
    if([self isBlankString:barrageText]) {
        
        return;
    }
    
    //上行聊天
    [[WwGameManager GameMgrInstance] sendDamuMsg:barrageText];
}


#pragma mark  User Action
- (void)sendbarrage:(GrounderModel *)grounderModel /**< 发送票屏弹幕*/
{
    [(GrounderSuperView *)self.barrageSuperView newBarrageComing:grounderModel];
}

//如果全是空格 做处理
- (BOOL)isBlankString:(NSString *)string{
    if (string == nil) {
        return YES;
    }
    if (string == NULL) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length]==0) {
        
        return YES;
    }
    return NO;
}

#pragma mark - getter

- (GrounderSuperView *)barrageSuperView {
    if (!_barrageSuperView) {
        _barrageSuperView = [[GrounderSuperView alloc] init];
    }
    return _barrageSuperView;
}

- (NSInteger)roomID
{
    return self.interView.roomData.ID;
}

@end
