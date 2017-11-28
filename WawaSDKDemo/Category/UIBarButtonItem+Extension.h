//
//  UIBarButtonItem+YFExtension.h
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (Extension)
+ (UIBarButtonItem *)rightBarButtonItemWithTitle:(NSString *)title AddTaget:(id)taget action:(SEL)action;
+ (UIBarButtonItem *)closeBarButtonItemAddTaget:(id)target action:(SEL)action;


+ (UIBarButtonItem *)backButtonWithImageNamed:(NSString *)named highlightedImageName:(NSString *)highlightedImageName target:(id)target action:(SEL)action;
+ (UIBarButtonItem *)backButtonWithImageNamed:(NSString *)named target:(id)target action:(SEL)action;

+ (UIBarButtonItem *)backButtonAddTaget:(id)target action:(SEL)action;
+ (UIBarButtonItem *)registerBarButtonAddTaget:(id)taget action:(SEL)action;
+ (NSArray *)searchButtonAddTaget:(id)target action:(SEL)action;
+ (UIBarButtonItem *)leftButtonAddTaget:(id)taget action:(SEL)action parentViewController:(UIViewController *)vc;
+ (UIBarButtonItem *)searchButtonItemAddTaget:(id)target action:(SEL)action;
@end
