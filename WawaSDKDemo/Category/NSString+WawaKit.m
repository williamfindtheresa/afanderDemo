//
//  NSString+WawaKit.m
//  WawaSDKDemo
//

#import "NSString+WawaKit.h"

NSString * realString(id str)
{
    if ([str isKindOfClass:[NSNull class]] || str == NULL || str == nil) {
        return @"";
    }
    return [NSString stringWithFormat:@"%@",str];
}

@implementation NSString (WawaKit)

//如果全是空格 做处理
+ (BOOL)isBlankString:(NSString *)string{
    if (string == nil) {
        return YES;
    }
    
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length]==0) {
        return YES;
    }
    return NO;
}

// 传入字符串,直接在沙盒Cache中生成路径
- (instancetype)cacheDir {
    NSString *cache = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject;
    return [cache stringByAppendingPathComponent:[self lastPathComponent]];
}

// 传入字符串,直接在沙盒Document中生成路径
- (instancetype)documentDir {
    NSString *doc = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    return [doc stringByAppendingPathComponent:[self lastPathComponent]];
}

// 传入字符串,直接在沙盒Temp中生成路径
- (instancetype)temDir {
    NSString *tem = NSTemporaryDirectory();
    return [tem stringByAppendingPathComponent:[self lastPathComponent]];
}

- (NSString *)extStringUsePara:(NSString *)para{

    if ([self rangeOfString:@"?"].location == NSNotFound) {
        NSString * str = [NSString stringWithFormat:@"%@?%@",self,para];
        return str;
    }else{
        NSString * str = [NSString stringWithFormat:@"%@&%@",self,para];
        return str;
    }
}

- (CGSize)sizeWithFont:(UIFont*)font   andMaxSize:(CGSize)size {
    //特殊的格式要求都写在属性字典中
    NSDictionary*attrs =@{NSFontAttributeName: font};
    //返回一个矩形，大小等于文本绘制完占据的宽和高。
    return  [self  boundingRectWithSize:size  options:NSStringDrawingUsesLineFragmentOrigin  attributes:attrs   context:nil].size;
}

- (BOOL)isBlankString {
    if (self == nil) {
        return YES;
    }
    if (self == NULL) {
        return YES;
    }
    if ([self isKindOfClass:[NSNull class]]) {
        
        return YES;
    }
    if ([[self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length]==0) {
        return YES;
    }
    return NO;
}


- (NSAttributedString *)labelStyleWithColor:(UIColor *)color font:(UIFont *)font {
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:self];
    [str addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(0,self.length)];
    [str addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, self.length)];
    return str;
}

- (BOOL)validateMobile {
    //手机号以13， 15，18开头，八个 \d 数字字符
    NSString *pattern = @"^1+\\d{10}";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    return [pred evaluateWithObject:self];
}

- (BOOL)validateNumber {
    NSString *pattern = @"^\\d*$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    return [pred evaluateWithObject:self];
}


@end
