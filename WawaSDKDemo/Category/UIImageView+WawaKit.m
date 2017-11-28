//
//  UIImageView+WawaKit.h
//  WawaSDKDemo
//

#import "UIImageView+WawaKit.h"
#import "UIImage+GIF.h"
#import "UIImageView+WebCache.h"
#import "WawaKitConstants.h"

@implementation UIImageView (WawaKit)

- (void)ww_setImageWithURL:(NSString *)url
{
    [self sd_setImageWithURL:[NSURL URLWithString:realString(url)] placeholderImage:nil options:0 progress:nil completed:nil];
}

- (void)ww_setToyImageWithUrl:(NSString *)url {
    [self sd_setImageWithURL:[NSURL URLWithString:realString(url)] placeholderImage:[UIImage imageNamed:@"toy_default"] options:0 progress:nil completed:nil];
}


// 设置取代一些url获取类型

- (void)ww_setAvatar:(NSString *)url {
    UIImage *defaultImage = [UIImage imageNamed:@"avatar_default_medium"];
    [self sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:defaultImage options:0 progress:nil completed:nil];
}

- (void)ww_loadGifImage:(NSString *)gifName {
    NSString *path = [[NSBundle mainBundle] pathForResource:gifName ofType:@"gif"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    UIImage *image = [UIImage sd_animatedGIFWithData:data];
    self.image = image;
}
@end
