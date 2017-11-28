//
//  UILabel+WawaKit.m
//  F_Sky
//
//

#import "UILabel+WawaKit.h"

@implementation UILabel (WawaKit)

+ (NSMutableAttributedString *)attributedString:(NSString *)string withImage:(NSString *)imgName beforeString:(BOOL)before atPoint:(CGPoint)point {
    NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:string];
    NSTextAttachment *attch = [[NSTextAttachment alloc] init];

    UIImage *img = [UIImage imageNamed:imgName];
    attch.image = img;
    attch.bounds = CGRectMake(point.x-2, point.y, img.size.width, img.size.height);

    NSAttributedString *imgAttribut = [NSAttributedString attributedStringWithAttachment:attch];
    if (before) {
        [attri insertAttributedString:imgAttribut atIndex:0];
    }
    else {
        [attri appendAttributedString:imgAttribut];
    }
    return attri;
}

@end
