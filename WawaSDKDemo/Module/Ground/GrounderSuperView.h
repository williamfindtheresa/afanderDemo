//
//  GrounderSuperView.h
//

#import <UIKit/UIKit.h>
#import "GrounderModel.h"

#import "BREngine.h"

/**< 弹幕画布*/

@interface GrounderSuperView : UIView <BRCanvasInterface>

@property(nonatomic, strong, readonly) BREngine *brengine;

- (void)newBarrageComing:(id)model; /**< 普通弹幕 横幅数据都调用这个*/

@end
