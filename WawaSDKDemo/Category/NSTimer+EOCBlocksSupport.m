//
//  NSTimer+EOCBlocksSupport.m
//  yuyou
//
//  Created by LvBingru on 5/12/16.
//  Copyright © 2016 李洋. All rights reserved.
//

#import "NSTimer+EOCBlocksSupport.h"

@implementation NSTimer(EOCBlocksSupport)

+ (NSTimer *)eoc_scheduledTimerWithTimeInterval:(NSTimeInterval)interval
                                          block:(void(^)())block
                                        repeats:(BOOL)repeats
{
    return [self scheduledTimerWithTimeInterval:interval
                                         target:self
                                       selector:@selector(eoc_blockInvoke:)
                                       userInfo:[block copy]
                                        repeats:repeats];
}

+ (void)eoc_blockInvoke:(NSTimer*)timer {
    void (^block)() = timer.userInfo;
    if (block) {
        block();
    }
}

@end
