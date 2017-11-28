//
//  WwViewUtil.m
//

#import "WwViewUtil.h"


@implementation UIView(Ww)

- (CGFloat)cornerRadius
{
    return self.layer.cornerRadius;
}

- (void)setCornerRadius:(CGFloat)cornerRadius
{
    self.layer.cornerRadius = cornerRadius;
    self.clipsToBounds = YES;
}

- (CGFloat)borderWidth
{
    return self.layer.borderWidth;
}

- (void)setBorderWidth:(CGFloat)borderWidth
{
    self.layer.borderWidth = borderWidth;
}

- (UIColor *)borderColor
{
    return [UIColor colorWithCGColor:self.layer.borderColor];
}

- (void)setBorderColor:(UIColor *)borderColor
{
    self.layer.borderColor = borderColor.CGColor;
}

- (UITapGestureRecognizer *)addSingleTapGestureAtTarget:(id)target action:(SEL)action
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:target action:action];
    [self addGestureRecognizer:tap];
    [self setUserInteractionEnabled:YES];
    return tap;
}

- (UISwipeGestureRecognizer *)addSwipeLeftGestureAtTarget:(id)target action:(SEL)action
{
    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:target action:action];
    [swipe setDirection:UISwipeGestureRecognizerDirectionLeft];
    [self addGestureRecognizer:swipe];
    [self setUserInteractionEnabled:YES];
    return swipe;
}

- (UISwipeGestureRecognizer *)addSwipeRightGestureAtTarget:(id)target action:(SEL)action
{
    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:target action:action];
    [swipe setDirection:UISwipeGestureRecognizerDirectionRight];
    [self addGestureRecognizer:swipe];
    [self setUserInteractionEnabled:YES];
    return swipe;
}

- (UIImage *)convertToImageAtScale:(CGFloat)aScale
{
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, self.opaque, aScale);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (UIImage *)convertToImage
{
    UIImage *image = [self convertToImageAtScale:0.0f];
    return image;
}

- (void)centerHorizontal
{
    CGPoint center = self.center;
    center.x = self.superview.bounds.size.width/2;
    [self setCenter:center];
}

- (void)centerVertical
{
    CGPoint center = self.center;
    center.y = self.superview.bounds.size.height/2;
    [self setCenter:center];
}

- (void)centerHorizontalAfterEditWidth:(CGFloat)width
{
    [self updateWidth:width];
    [self centerHorizontal];
}

- (void)updateWidth:(CGFloat)width
{
    CGRect frame = self.frame;
    frame.size.width = width;
    [self setFrame:frame];
}

- (void)updateX:(CGFloat)x
{
    CGRect frame = self.frame;
    frame.origin.x = x;
    [self setFrame:frame];
}

- (UIViewController *)containerVC{
    
    id object = [(UIView *)self nextResponder];
    while (![object isKindOfClass:[UIViewController class]] &&
           object != nil) {
        object = [object nextResponder];
    }
    return (UIViewController*)object;
}

@end


@implementation WwViewUtil

+ (CGFloat)screenWidth
{
    return [UIScreen mainScreen].bounds.size.width;
}

+ (CGFloat)screenHeight
{
    return [UIScreen mainScreen].bounds.size.height;
}

+ (CGSize)updateLabel:(UILabel *)label withText:(NSString *)string
{
    return [self updateLabel:label withText:string contstrainedSize:CGSizeMake(label.frame.size.width,MAXFLOAT)];
}

+ (CGSize)updateLabel:(UILabel *)label withText:(NSString *)string contstrainedSize:(CGSize)constrainedSize
{
    if (string!=nil) label.text = string;
    CGFloat width = constrainedSize.width;
    CGSize size = [self sizeWithString:label.text font:label.font constrainedToSize:constrainedSize lineBreakMode:label.lineBreakMode];
    CGFloat height = ceil(size.height);
    if(label.text==nil||[label.text isEqualToString:@""])
        height=0.f;
    label.frame = CGRectMake(label.frame.origin.x, label.frame.origin.y, ceil(width), ceil(height));
    return size;
}

+ (CGFloat)updateWidthOfLabel:(UILabel *)label
{
    return [self updateWidthOfLabel:label ofMaxWidth:CGFLOAT_MAX];
}

+ (CGFloat)updateWidthOfLabel:(UILabel *)label ofMaxWidth:(CGFloat)maxWidth{
    CGRect frame = label.frame;
    CGFloat width = [self widthOfLabel:label];
    width = MIN(width, maxWidth);
    frame.size.width = width;
    [label setFrame:frame];
    return width;
}



+ (CGFloat)widthOfLabel:(UILabel *)aLabel
{
    if (aLabel.text.length <= 0) {
        return 0.0f;
    }
    CGSize size = [self sizeWithString:aLabel.text font:aLabel.font constrainedToSize:CGSizeMake(MAXFLOAT, 0.0f) lineBreakMode:aLabel.lineBreakMode];
    return size.width;
}

+ (CGSize)sizeWithString:(NSString *)aString font:(UIFont *)aFont constrainedToSize:(CGSize)aSize lineBreakMode:(NSLineBreakMode)aLineBreakMode
{
    CGSize returnSize = CGSizeZero;
    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
    paragraphStyle.lineBreakMode = aLineBreakMode;
    CGSize boundedSize = [aString boundingRectWithSize:aSize options: NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:aFont, NSParagraphStyleAttributeName:paragraphStyle.copy} context:nil].size;
    returnSize.width = ceilf(boundedSize.width);
    returnSize.height = ceilf(boundedSize.height);
    return returnSize;
}

+ (CGPoint)centerOfView:(UIView *)aView
{
    return CGPointMake(aView.bounds.size.width/2.0f, aView.bounds.size.height/2.0f);
}

+ (void)makeCenterOfView:(UIView *)aView
{
    CGPoint center = [self centerOfView:aView.superview];
    [aView setCenter:center];
}


@end


@implementation WwTouchView

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    [self endEditing:YES];
    [self.superview endEditing:YES];
}

@end
