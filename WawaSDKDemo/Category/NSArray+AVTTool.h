//
//  NSArray+AVTTool.h
//

#import <Foundation/Foundation.h>

@interface NSArray (AVTTool)

- (id)safeObjectAtIndex:(NSInteger)index;

- (NSInteger)safeIndexOfObject:(id)obj;


@end


@interface NSMutableArray (AVTTool)

- (void)safeRemoveObjectAtIndex:(NSInteger)index;

- (void)safeAddObject:(id)obj;

@end
