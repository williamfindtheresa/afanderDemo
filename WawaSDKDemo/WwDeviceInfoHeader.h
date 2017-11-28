//
//  WwDeviceInfoHeader.h
//

#ifndef WwDeviceInfoHeader_h
#define WwDeviceInfoHeader_h

// 包含热点栏的状态栏高度  普通机型为20，iPhone X为44，连接热点时都增加20
#define kStatusBarHeight [[UIApplication sharedApplication] statusBarFrame].size.height
//系统状态栏高度：普通机型为20，iPhone X为44
#define kSysStatusBarHeight (IS_IPhone_X?44:20)
//热点栏高度20
#define kHotspotStatusBarHeight  20
//是否开启了热点
#define KIsHotspotConnected   (kStatusBarHeight==(kSysStatusBarHeight+kHotspotStatusBarHeight)?YES:NO)

// 导航栏高度
#define kNavBarHeight 44.0
// tabbar高度
#define kTabBarHeight (IS_IPhone_X?83:49)
// 状态栏+导航栏高度 如果开启了热点，需要减去热点栏高度20
#define kTopHeight  (KIsHotspotConnected?(kStatusBarHeight+kNavBarHeight-kHotspotStatusBarHeight):(kStatusBarHeight + kNavBarHeight))

// 自定义NavBar高度
#define kCustomNavBarHeight (IS_IPhone_X?88:64)
// 自定义tabbar高度
#define kCustomTabBarHeight (IS_IPhone_X?104:70)
// 快速开始距离底部间距
#define kQuickStartBottomMargin (IS_IPhone_X?-31:7)
// 个人中心距离顶部距离
#define kMineStatusMargin (IS_IPhone_X?24:0)

/**
 *  屏幕高度
 */
#define ScreenHeight [UIScreen mainScreen].bounds.size.height

#define screenViewHeight (ScreenHeight-kTopHeight) 

/**
 *  屏幕宽度
 */
#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenScale [UIScreen mainScreen].scale

//按iPhone6尺寸适配
#define ADAPTATION_Six_W(w)  (float)(w)*ScreenWidth/375
#define ADAPTATION_Six_H(h) (float)ScreenHeight*(h)/667

//如果是iOS7以及之后的版本
#define NLSystemVersionGreaterOrEqualThan(version) ([[[UIDevice currentDevice] systemVersion] floatValue] >= version)
#define IOS7_OR_LATER NLSystemVersionGreaterOrEqualThan(7.0)
//ios8
#define IOS8_OR_LATER NLSystemVersionGreaterOrEqualThan(8.0)
//ios9
#define IOS9_OR_LATER NLSystemVersionGreaterOrEqualThan(9.0)
//ios10
#define IOS10_OR_LATER NLSystemVersionGreaterOrEqualThan(10.0)

#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_RETINA ([[UIScreen mainScreen] scale] >= 2.0)

#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define SCREEN_MIN_LENGTH (MIN(SCREEN_WIDTH, SCREEN_HEIGHT))

#define IS_IPHONE_4_OR_LESS (IS_IPHONE && SCREEN_MAX_LENGTH < 568.0)
#define IS_IPHONE_5_OR_LESS (IS_IPHONE && SCREEN_MAX_LENGTH <= 568.0)
#define IS_IPHONE_5 (IS_IPHONE && SCREEN_MAX_LENGTH == 568.0)
#define IS_IPHONE_6 (IS_IPHONE && SCREEN_MAX_LENGTH == 667.0)
#define IS_IPHONE_6P (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)
#define IS_IPhone_X  (IS_IPHONE && SCREEN_MAX_LENGTH == 812.0)

#endif /* WwDeviceInfoHeader_h */
