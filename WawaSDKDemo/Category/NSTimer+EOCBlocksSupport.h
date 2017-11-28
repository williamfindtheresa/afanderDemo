//
//  NSTimer+EOCBlocksSupport.h
//

#import <Foundation/Foundation.h>

@interface NSTimer(EOCBlocksSupport)

+ (NSTimer *)eoc_scheduledTimerWithTimeInterval:(NSTimeInterval)interval
                                          block:(void(^)())block
                                        repeats:(BOOL)repeats;
@end
