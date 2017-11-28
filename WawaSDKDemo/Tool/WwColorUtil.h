//
//  WwColorUtil.h
//

#import <UIKit/UIKit.h>


/**
 *  color def
 */
#define WwColorGrayDisabled @"dd"
#define WwColorGreen @"17c360"
#define WwColorYellow @"ffdd22"
#define WwColorRed @"fa5968"
#define WwColorSeparateLine @"cc"
#define WwColorBackground @"ee"
#define WwColorLightWhite @"fa"
#define WwColorDarkBackground @"22"
#define WwColorAite @"6abffb"

@interface UIColor(WwUtil)

/**
 *  NSString -》 UIColor
 *
 *  @param aColorString normal:@“#AB12FF” or @“AB12FF” or gray: @"C7"
 *
 *  @return UIColor
 */
+ (UIColor *)colorFromString:(NSString *)aColorString;
/**
 *  NSString -》 UIColor with alpha
 *
 *  @param aColorString normal:@“#AB12FF” or @“AB12FF” or gray: @"C7"
 *  @param aAlpha       alpha 0-1.0
 *
 *  @return UIColor
 */
+ (UIColor *)colorFromString:(NSString *)aColorString alpha:(CGFloat)aAlpha;

/**
 *  UIColor -》 NSString
 *
 *  @param aColor UIColor
 *
 *  @return NSString（format: @“#AB12FF”）
 */
+ (NSString *)stringFromColor:(UIColor *)aColor;

@end
