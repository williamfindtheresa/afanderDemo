//
//  UILabel+WawaKit.h
//  WawaSDKDemo
//

#import <UIKit/UIKit.h>

@interface UILabel (WawaKit)

/**
 * 富文本UILabel
 * @param string 文本
 * @param imgName 图片
 * @param before 图片与文本的位置
 * @param point 图片位置
 */
+ (NSMutableAttributedString *)attributedString:(NSString *)string withImage:(NSString *)imgName beforeString:(BOOL)before atPoint:(CGPoint)point;


@end
