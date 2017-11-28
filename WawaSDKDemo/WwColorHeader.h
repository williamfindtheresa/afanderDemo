//
//  WwColorHeader.h
//  F_Sky
//

#ifndef WwColorHeader_h
#define WwColorHeader_h

#import "UIColor+WawaKit.h"

//qq手机  ===URLScheme 中的计算方法 == echo 'ibase=10;obase=16;1104058641'|bc====> 6058342 不足8位前面补0-》 41CE9911 ，此处是8 位不用补零 。
#pragma mark------颜色，字体等----------
#define APPBACK  RGBCOLOR(0xed, 0xed, 0xed)
#define APPCOLOR RGBCOLOR(0x22, 0x22, 0x22)
#define APP_COLOR_RED [UIColor colorWithRed:255/255.0 green:82/255.0 blue:83/255.0 alpha:1.0]

// APP的基础色(红)
#define kAppBaseColor  WwColorGen(@"#ff4f6a")
// APP内通用字体颜色
#define kAppTextColor RGBCOLOR(0xed, 0xed, 0xed)
// APP内通用控件颜色 蓝色
#define kAppLabelColor RGBCOLOR(54, 127, 255)
// 导航栏渐变
#define kAppNavGradientColors @[(id)RGBCOLORV(0xff5a5a).CGColor, (id)RGBCOLORV(0xef4266).CGColor]
// APP内其他地方渐变
#define kAppGradientColors @[(__bridge id)WwColorGen(@"#ff6167").CGColor, (__bridge id)WwColorGen(@"#ff4568").CGColor]

#define RGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]

#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]

//使用十六进制的颜色
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define font(size) [UIFont systemFontOfSize:(size)]
#define boldFont(size)  [UIFont boldSystemFontOfSize:(size)]

#define WwColorGen(aColorString) [UIColor colorFromString:aColorString]
#define WwColorGenAlpha(aColorString, aAlpha) [UIColor colorFromString:aColorString alpha:aAlpha]

//使用十六进制的颜色
#define RGBCOLORV(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0x00FF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0x0000FF))/255.0 \
alpha:1.0]

//使用十六进制的颜色
#define RGBCOLORVA(rgbValue, alphaValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0x00FF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0x0000FF))/255.0 \
alpha:alphaValue]


// 随机色
#define RandomColor [UIColor colorWithRed:arc4random_uniform(256)/255.0 green:arc4random_uniform(256)/255.0 blue:arc4random_uniform(256)/255.0 alpha:1.0]

#define DMRGBColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1]
#define DMRGBAColor(r, g, b ,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:a]
#define DMRandColor DMRGBColor(arc4random_uniform(255), arc4random_uniform(255), arc4random_uniform(255))

#define testColor [[UIColor blackColor] colorWithAlphaComponent:0.6]


#endif /* WwColorHeader_h */
