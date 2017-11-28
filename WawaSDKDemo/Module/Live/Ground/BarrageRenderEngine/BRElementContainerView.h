//
//  BRElementContainerView.h
//

#import <UIKit/UIKit.h>

/**
 动画元素 承载体。
 
 private
 */
@interface BRElementContainerView : UIView

@property (nonatomic, assign) NSInteger lineNum;
@property (nonatomic, weak) UIView *elementView;

@end
