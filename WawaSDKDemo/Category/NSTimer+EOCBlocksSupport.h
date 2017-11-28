//
//  NSTimer+EOCBlocksSupport.h
//  yuyou
//
//  Created by LvBingru on 5/12/16.
//  Copyright © 2016 李洋. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSTimer(EOCBlocksSupport)

+ (NSTimer *)eoc_scheduledTimerWithTimeInterval:(NSTimeInterval)interval
                                          block:(void(^)())block
                                        repeats:(BOOL)repeats;
@end
