//
//  DVLColorUtil.h
//  DVL
//
//  Created by lvbingru on 2/2/15.
//  Copyright (c) 2015 forthblue. All rights reserved.
//

#import <UIKit/UIKit.h>


/**
 *  color def
 */
#define ZXColorGrayDisabled @"dd"
#define ZXColorGreen @"17c360"
#define ZXColorYellow @"ffdd22"
#define ZXColorRed @"fa5968"
#define ZXColorSeparateLine @"cc"
#define ZXColorBackground @"ee"
#define ZXColorLightWhite @"fa"
#define ZXColorDarkBackground @"22"
#define ZXColorAite @"6abffb"

//守护聊天区颜色
#define kGuardColor  RGBCOLORV(0x77a1e7)
#define kGodColor  DVLColorGen(@"#fbd972")

@interface UIColor(DVLUtil)

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
