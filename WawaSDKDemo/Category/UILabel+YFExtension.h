//
//  UILabel+YFExtension.h
//  QMPlayground
//
//  Created by 谢宇锋 on 16/3/30.
//  Copyright © 2016年 QMTV. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (YFExtension)
+ (UILabel *)titleLabel:(NSString *)titleStr;
/**
                                              UILabel文字的渐变颜色
                                              
                                              @param colors 渐变颜色（必须是id类型）
                                              @param startPoint 渐变开始
                                              @param endPoint 渐变结束
                                              */
- (void)addGradientRampWithColors:(NSArray *)colors rect:(CGRect)rect startPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint;
/**
 设置UILabel文字富文本
 @param labelText text
 @param color 颜色
 @param font 字体大小
 */
+ (NSAttributedString *)labelStyleWithString:(NSString *)labelText color:(UIColor *)color font:(UIFont *)font;

/**
 UILabel带有图片的富文本
 
 @param string 拼接文本
 @param spec 文本或者间接站位
 @param imgName 拼接文本图片
 @param front 图片是否在文本之前

 @return 带有图片的富文本
 */
+ (NSMutableAttributedString *)labelAttributedString:(NSString *)string spec:(NSString *)spec imageName:(NSString *)imgName point:(CGPoint)point imgFrontString:(BOOL)front;


+ (NSMutableAttributedString *)labelAttributedString:(NSString *)string spec:(NSString *)spec imageName:(NSString *)imgName imageSize:(CGSize)imgsize point:(CGPoint)point imgFrontString:(BOOL)front;

@end
