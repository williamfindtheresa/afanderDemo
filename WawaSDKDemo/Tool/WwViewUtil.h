//
//  WwViewUtil.h
//

#import <Foundation/Foundation.h>


@interface UIView(WwUtil)

@property (nonatomic, assign) IBInspectable CGFloat cornerRadius;
@property (nonatomic, assign) IBInspectable CGFloat borderWidth;
@property (nonatomic, assign) IBInspectable UIColor *borderColor;

- (UITapGestureRecognizer *)addSingleTapGestureAtTarget:(id)target action:(SEL)action;

- (UISwipeGestureRecognizer *)addSwipeLeftGestureAtTarget:(id)target action:(SEL)action;
- (UISwipeGestureRecognizer *)addSwipeRightGestureAtTarget:(id)target action:(SEL)action;
- (UIImage *)convertToImage;

- (void)centerHorizontal;
- (void)centerVertical;
- (void)centerHorizontalAfterEditWidth:(CGFloat)width;
- (void)updateWidth:(CGFloat)width;
- (void)updateX:(CGFloat)x;

// 包含这个view 的 vc
- (UIViewController *)containerVC;

@end;


@interface WwViewUtil : NSObject

+ (CGFloat)screenWidth;
+ (CGFloat)screenHeight;

+ (CGFloat)updateWidthOfLabel:(UILabel *)label;

+ (CGFloat)updateWidthOfLabel:(UILabel *)label ofMaxWidth:(CGFloat)width;

+ (CGFloat)widthOfLabel:(UILabel *)aLabel;
+ (CGSize)sizeWithString:(NSString *)aString font:(UIFont *)aFont constrainedToSize:(CGSize)aSize lineBreakMode:(NSLineBreakMode)aLineBreakMode;

+ (CGPoint)centerOfView:(UIView *)aView;
+ (void)makeCenterOfView:(UIView *)aView;
@end

@interface WwTouchView : UIView

@end
