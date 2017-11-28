//
//  NSString+WawaKit.h
//  F_Sky
//

#import <Foundation/Foundation.h>

@interface NSString (WawaKit)

NSString * realString(id str);


+ (BOOL)isBlankString:(NSString *)string;

#pragma mark - file mananger helper methods
- (instancetype)cacheDir;
- (instancetype)documentDir;
- (instancetype)temDir;

- (NSString *)extStringUsePara:(NSString *)para;
- (CGSize)sizeWithFont:(UIFont*)font andMaxSize:(CGSize)size;

- (BOOL)isBlankString;

/**
 设置UILabel文字富文本
 @param color 颜色
 @param font 字体大小
 */
- (NSAttributedString *)labelStyleWithColor:(UIColor *)color font:(UIFont *)font;


/**
 * 是否符合手机号的格式
 */
- (BOOL)validateMobile;


/**
 * 是否为纯数字
 */
- (BOOL)validateNumber;

@end
