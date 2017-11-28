//
//  UILabel+YFExtension.m
//

#import "UILabel+YFExtension.h"

@implementation UILabel (YFExtension)
+ (UILabel *)titleLabel:(NSString *)titleStr {
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = titleStr;
    titleLabel.textAlignment = 1;
    titleLabel.font = [UIFont systemFontOfSize:17.0];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = [UIColor colorWithRGB:0x3e3e3e alpha:1.0];
    [titleLabel sizeToFit];
    return titleLabel;
}
/**
 UILabel文字的渐变颜色
 
 @param colors 渐变颜色（必须是id类型）
 @param startPoint 渐变开始
 @param endPoint 渐变结束
 */
- (void)addGradientRampWithColors:(NSArray *)colors rect:(CGRect)rect startPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint {
    //这个label是和上面的label是对齐的哦，之前都不好对齐，用这样的方法设置frame就好了
    // UILabel *infoTextLabel = [[UILabel alloc] init];
    // infoTextLabel.frame = CGRectMake(label.center.x - CGRectGetWidth(label.bounds)/2 ,point.y + 30, 220, 50);
    // infoTextLabel.text = @"你说的是哦";
    // infoTextLabel.font = [UIFont systemFontOfSize:20];
    // infoTextLabel.backgroundColor =[UIColor redColor];
    // infoTextLabel.numberOfLines = 0;
    // infoTextLabel.textAlignment = NSTextAlignmentLeft;
    // infoTextLabel.textColor = [UIColor blueColor];
    // [infoTextLabel sizeToFit];
    // [self.view addSubview:infoTextLabel];
    //在后面添加渐变图层
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = rect;
    gradientLayer.colors = colors;
    //渐变的方向（0，0） （0，1） （1，0）（1，1）为四个顶点方向
    //(I.e. [0,0] is the bottom-left
    // corner of the layer, [1,1] is the top-right corner.) The default values
    // are [.5,0] and [.5,1]
    gradientLayer.startPoint = startPoint;
    gradientLayer.endPoint = endPoint;
    [self.superview.layer addSublayer:gradientLayer];
    gradientLayer.mask = self.layer;
    self.frame = gradientLayer.bounds;
}

+ (NSAttributedString *)labelStyleWithString:(NSString *)labelText color:(UIColor *)color font:(UIFont *)font {
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:labelText];
    [str addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(0,labelText.length)];
    [str addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, labelText.length)];
    return str;
}

/**
 UILabel带有图片的富文本

 @param string 拼接文本
 @param spec 文本或者间接站位
 @param imgName 拼接文本图片
 @param front 图片是否在文本之前
 @return 带有图片的富文本
 */
+ (NSMutableAttributedString *)labelAttributedString:(NSString *)string spec:(NSString *)spec imageName:(NSString *)imgName point:(CGPoint)point imgFrontString:(BOOL)front {
    //创建富文本
    NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:spec];
    [attri appendString:string];
    //NSTextAttachment可以将要插入的图片作为特殊字符处理
    NSTextAttachment *attch = [[NSTextAttachment alloc] init];
    //定义图片内容及位置和大小
    UIImage *img = [UIImage imageNamed:imgName];
    attch.image = img;
    attch.bounds = CGRectMake(point.x, point.y, img.size.width, img.size.height);
    //创建带有图片的富文本
    NSAttributedString *imgAttribut = [NSAttributedString attributedStringWithAttachment:attch];
    if (front) {
        //将图片放在第一位
        [attri insertAttributedString:imgAttribut atIndex:0];
    }
    else {
        //将图片放在最后一位
        [attri appendAttributedString:imgAttribut];
    }
    return attri;
}


+ (NSMutableAttributedString *)labelAttributedString:(NSString *)string spec:(NSString *)spec imageName:(NSString *)imgName imageSize:(CGSize)imgsize point:(CGPoint)point imgFrontString:(BOOL)front
{

    //创建富文本
    NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:spec];
    [attri appendString:string];
    //NSTextAttachment可以将要插入的图片作为特殊字符处理
    NSTextAttachment *attch = [[NSTextAttachment alloc] init];
    //定义图片内容及位置和大小
    UIImage *img = [UIImage imageNamed:imgName];
    attch.image = img;
    attch.bounds = CGRectMake(point.x, point.y, imgsize.width, imgsize.height);
    //创建带有图片的富文本
    NSAttributedString *imgAttribut = [NSAttributedString attributedStringWithAttachment:attch];
    if (front) {
        //将图片放在第一位
        [attri insertAttributedString:imgAttribut atIndex:0];
    }
    else {
        //将图片放在最后一位
        [attri appendAttributedString:imgAttribut];
    }
    return attri;
}


@end
