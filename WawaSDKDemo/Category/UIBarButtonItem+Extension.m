//
//  UIBarButtonItem+YFExtension.m
//

#import "UIBarButtonItem+Extension.h"

@implementation UIBarButtonItem (Extension)

+ (UIBarButtonItem *)rightBarButtonItemWithTitle:(NSString *)title AddTaget:(id)taget action:(SEL)action {
    UIButton *registerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [registerButton setFrame:CGRectMake(100, 100, 35, 30)];
    [registerButton setBackgroundColor:[UIColor clearColor]];
    [registerButton addTarget:taget action:action forControlEvents:UIControlEventTouchUpInside];
    [registerButton.titleLabel setFont:[UIFont systemFontOfSize:15.0f]];
    [registerButton setTitle:title forState:UIControlStateNormal];
    [registerButton setTitleColor:APP_COLOR_RED forState:UIControlStateNormal];
//    [registerButton.layer setCornerRadius:15.0];
//    [registerButton.layer setBorderWidth:2];
//    [registerButton.layer setBorderColor:APP_COLOR_RED.CGColor];
    UIBarButtonItem *registerBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:registerButton];
    return registerBarButtonItem;
}

+ (UIBarButtonItem *)closeBarButtonItemAddTaget:(id)target action:(SEL)action {
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeButton setFrame:CGRectMake(0, 0, 35, 35)];
    [closeButton setImageEdgeInsets:UIEdgeInsetsMake(0, -20, 0, 0)];
    [closeButton.titleLabel setFont:[UIFont systemFontOfSize:16.0f]];
    [closeButton setBackgroundColor:[UIColor clearColor]];
    [closeButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [closeButton setImage:[UIImage imageNamed:@"btn_nav_close"] forState:UIControlStateNormal];
    [closeButton setImage:[UIImage imageNamed:@"btn_nav_close_click"] forState:UIControlStateHighlighted];
    [closeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    UIBarButtonItem *closeBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:closeButton];
    return closeBarButtonItem;
}

+ (UIBarButtonItem *)backButtonWithImageNamed:(NSString *)named highlightedImageName:(NSString *)highlightedImageName target:(id)target action:(SEL)action {
    UIView *customView = [[UIView alloc] initWithFrame:CGRectMake(0, 20, 44, 44)];
    
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame = CGRectMake(-8, 0, 44, 44);//APPSIZE.size.width - 30, 30, 30, 30
    [leftButton setImage:[UIImage imageNamed:named] forState:UIControlStateNormal];
    [leftButton setImage:[UIImage imageNamed:highlightedImageName] forState:UIControlStateHighlighted];
    [leftButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [leftButton  setImageEdgeInsets : UIEdgeInsetsMake ( 0 , 0 , 0 , 0 )];
    [customView addSubview:leftButton];
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:customView];
    return leftBarButtonItem;
}
+ (UIBarButtonItem *)backButtonWithImageNamed:(NSString *)named target:(id)target action:(SEL)action {
    UIView *customView = [[UIView alloc] initWithFrame:CGRectMake(0, 20, 44, 44)];
    
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame = CGRectMake(0, 0, 44, 44);//APPSIZE.size.width - 30, 30, 30, 30
    [leftButton setBackgroundImage:[UIImage imageNamed:named] forState:UIControlStateNormal];
    [leftButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [leftButton  setImageEdgeInsets : UIEdgeInsetsMake ( 0 , -40 , 0 , 0 )];
    [customView addSubview:leftButton];
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:customView];
    return leftBarButtonItem;
}

+ (UIBarButtonItem *)backButtonAddTaget:(id)target action:(SEL)action {
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame = CGRectMake(0, 0, 44, 44);//APPSIZE.size.width - 30, 30, 30, 30
    [leftButton setImage:[UIImage imageNamed:@"btn_nav_back"] forState:UIControlStateNormal];
    [leftButton setImageEdgeInsets:UIEdgeInsetsMake (0, -20, 0, 0)];
    [leftButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    return leftBarButtonItem;
}

+ (UIBarButtonItem *)leftButtonAddTaget:(id)taget action:(SEL)action parentViewController:(UIViewController *)vc {
    UIButton *leftItemButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftItemButton addTarget:taget action:action forControlEvents:UIControlEventTouchUpInside];
    [leftItemButton setImageEdgeInsets:UIEdgeInsetsMake(0.0, -20.0, 0.0, 0.0)];
//    if ([vc isKindOfClass:[AppendNavigationController class]]) {
//        [leftItemButton setImage:[UIImage imageNamed:@"login_leftItemButton_closeIcon"] forState:UIControlStateNormal];
//        [leftItemButton setImage:[UIImage imageNamed:@"login_leftItemButton_closePressIcon"] forState:UIControlStateHighlighted];
//    }else{
//        [leftItemButton setImage:[UIImage imageNamed:@"btn_nav_profile_information_back"] forState:UIControlStateNormal];
////        [leftItemButton setImage:[UIImage imageNamed:@"btn_nav_hp_player_back_selected"] forState:UIControlStateHighlighted];
//    }
    [leftItemButton setImage:[UIImage imageNamed:@"btn_nav_back"] forState:UIControlStateNormal];
    [leftItemButton sizeToFit];
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftItemButton];
    return leftBarButtonItem;
}

+ (UIBarButtonItem *)registerBarButtonAddTaget:(id)taget action:(SEL)action {
    UIButton *registerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [registerButton setFrame:CGRectMake(100, 100, 35, 30)];
    [registerButton addTarget:taget action:action forControlEvents:UIControlEventTouchUpInside];
    [registerButton.titleLabel setFont:[UIFont systemFontOfSize:16.0f]];
    registerButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [registerButton setTitle:@"注册" forState:UIControlStateNormal];
    [registerButton setTitleColor:[UIColor colorWithRGB:0xf04442 alpha:1.0] forState:UIControlStateNormal];
//    [registerButton.layer setCornerRadius:15.0];
//    [registerButton.layer setBorderWidth:2.0];
//    [registerButton.layer setBorderColor:APP_BUTTON_COLOR_NORMAL_RED.CGColor];
    UIBarButtonItem *registerBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:registerButton];
    return registerBarButtonItem;
}

+ (NSArray *)searchButtonAddTaget:(id)target action:(SEL)action {
    //     self.navigationItem.rightBarButtonItems =
    UIButton *searchbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [searchbtn setFrame:CGRectMake(0, 0, 50, 50)];
    [searchbtn setBackgroundColor:[UIColor clearColor]];
    [searchbtn setImage:[UIImage imageNamed:@"navigationBar_searchButton_icon"] forState:UIControlStateNormal];
    [searchbtn setImage:[UIImage imageNamed:@"navigationBar_searchButton_pressIcon"] forState:UIControlStateHighlighted];
    [searchbtn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithCustomView:searchbtn];
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
//    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    negativeSpacer.width = -15;
    return  @[negativeSpacer, buttonItem];
}

+ (UIBarButtonItem *)searchButtonItemAddTaget:(id)target action:(SEL)action {
    UIButton *searchbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [searchbtn setBackgroundColor:[UIColor clearColor]];
    [searchbtn setImage:[UIImage imageNamed:@"btn_nav_search_normal"] forState:UIControlStateNormal];
    [searchbtn setImage:[UIImage imageNamed:@"btn_nav_search_selected"] forState:UIControlStateHighlighted];
    [searchbtn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [searchbtn sizeToFit];
    UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithCustomView:searchbtn];
    return buttonItem;
}



@end
