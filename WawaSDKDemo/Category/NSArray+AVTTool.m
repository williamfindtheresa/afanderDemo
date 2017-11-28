//
//  NSArray+AVTTool.m
//

#import "NSArray+AVTTool.h"

@implementation NSArray (AVTTool)

- (id)safeObjectAtIndex:(NSInteger)index {
    if (index >= self.count || index < 0) {
        return nil;
    }
    return self[index];
}

- (NSInteger)safeIndexOfObject:(id)obj {
    if (obj == nil) {
        return 0;
    }
    return [self indexOfObject:obj];
}


@end


@implementation NSMutableArray (AVTTool)

- (void)safeRemoveObjectAtIndex:(NSInteger)index {
    if (index >= self.count || index < 0) {
        return;
    }
    [self removeObjectAtIndex:index];
}

- (void)safeAddObject:(id)obj
{
    if (obj == nil) {
        return;
    }
    [self addObject:obj];
}

@end
