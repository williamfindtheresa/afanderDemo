//
//  UIImageView+WawaKit.h
//  WawaSDKDemo
//

#import "UIImageView+WawaKit.h"
#import "UIImage+WwKitGIF.h"
#import "UIImageView+WwKitWebCache.h"
#import "WawaKitConstants.h"

@implementation UIImageView (WawaKit)

+ (NSString *)getImageWithPara:(NSString *)image withType:(WwKitImageUrlRuleType)type {
    NSString *imageUrl = image;
    
    if (NO == [image isKindOfClass:[NSString class]] || image.length == 0) {
        return nil;
    }
    
    if ([image hasPrefix:@"i:"]) {
        NSString *imageKey = [image substringFromIndex:@"i:".length];
        imageUrl = [NSString stringWithFormat:@"%@/%@", WwImageIServer,imageKey];
    }
    else if ([image hasPrefix:@"a:"]) {
        NSString *imageKey = [image substringFromIndex:@"a:".length];
        imageUrl = [NSString stringWithFormat:@"%@/%@", WwImageAServer,imageKey];
    }
    else if ([image hasPrefix:@"attchment:"]) {
        NSString *imageKey = [image substringFromIndex:@"attchment:".length];
        imageUrl = [NSString stringWithFormat:@"%@/%@", WwImageAttchmentServer,imageKey];
    }
    else if ([image hasPrefix:@"f:"]){
        // 文件下载的地方
        NSString *imageKey = [image substringFromIndex:@"f:".length];
        imageUrl = [NSString stringWithFormat:@"%@/%@", WwFileAttchment,imageKey];
    }
    //全民图片处理 ,直接return
    else if ([image hasPrefix:@"http"]){
        return imageUrl;
    }
    
    if (type >= WwKitImageUrlRuleTypeSmall) {
        NSArray  * arr = @[@"-small",@"-medium",@"-normal",@"-big"];
        NSString * str = arr[type];
        imageUrl = [imageUrl stringByAppendingString:str];
    }
    return imageUrl;
}

- (void)ww_setFitImageWithUrl:(NSString *)url
{
    [self ww_setImageWithUrl:url placeholderImage:nil options:0 progress:nil completed:nil];
}

- (void)ww_setImageWithUrl:(NSString *)url
{
    [self ww_setImageWithUrl:url placeholderImage:nil options:0 progress:nil completed:nil];
}

- (void)ww_setToyImageWithUrl:(NSString *)url {
    [self ww_setImageWithUrl:url placeholderImage:[UIImage imageNamed:@"toy_default"] options:0 progress:nil completed:nil];
}

- (void)ww_setImageWithUrl:(NSString *)url placeholderImage:(UIImage *)placeholder options:(WwKitWebImageOptions)options progress:(WwKitWebImageDownloaderProgressBlock)progressBlock completed:(WwKitWebImageCompletionBlock)completedBlock
{
    NSString *imageUrl = [UIImageView getImageWithPara:url withType:WwKitImageUrlRuleTypeMedium];
    ;
    [self ww_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:placeholder options:options progress:progressBlock completed:completedBlock];
}

// 设置取代一些url获取类型

- (void)ww_setAvatarWithPara:(NSString *)url ByType:(WwKitImageUrlRuleType)type{
    UIImage *defaultImage = nil;
    WwKitImageUrlRuleType smallerType = WwKitImageUrlRuleTypeInvalid;
    
    switch (type) {
        case WwKitImageUrlRuleTypeNormal:
            defaultImage = [UIImage imageNamed:@"avatar_default_medium"];
            smallerType = WwKitImageUrlRuleTypeMedium;
            break;
        case WwKitImageUrlRuleTypeSmall:
            defaultImage = [UIImage imageNamed:@"avatar_default_small"];
            smallerType = WwKitImageUrlRuleTypeSmall;
            break;
        case WwKitImageUrlRuleTypeMedium:
            defaultImage = [UIImage imageNamed:@"avatar_default_medium"];
            smallerType = WwKitImageUrlRuleTypeSmall;
            break;
        case WwKitImageUrlRuleTypeBig:
            defaultImage = [UIImage imageNamed:@"avatar_default_medium"];
            smallerType = WwKitImageUrlRuleTypeMedium;
            break;
        default:
            break;
    }

    // check if  smaller image is exists
    if (smallerType != WwKitImageUrlRuleTypeInvalid) {
        NSString *smallerImageUrl = [UIImageView getImageWithPara:url withType:smallerType];
        UIImage * avatar = [[WwKitImageCache sharedImageCache] imageFromDiskCacheForKey:smallerImageUrl];
        // replace default image
        if (avatar) {
            defaultImage = avatar;
        }
    }
    
    NSString *imageUrl = [UIImageView getImageWithPara:url withType:type];
    imageUrl = [imageUrl stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    imageUrl = [imageUrl stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    [self ww_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:defaultImage options:0 progress:nil completed:nil];
}

// 虚位以待 专用
- (void)ww_setAvatarRoomLoadingWithPara:(NSString *)url toType:(WwKitImageUrlRuleType)type placeImage:(NSString *)imageName
{
    UIImage *defaultImage = [UIImage imageNamed:imageName];
    
    NSString *imageUrl = [UIImageView getImageWithPara:url withType:type];
    
    [self ww_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:defaultImage options:0 progress:nil completed:nil];
}


- (void)ww_setAvatar:(NSString *)url type:(WwKitImageUrlRuleType)type completed:(void(^)(UIImage *image))complete {
    
    UIImage *defaultImage = [UIImage imageNamed:@"defaultIndex"];
    NSString *imageUrl = [UIImageView getImageWithPara:url withType:type];
    ;
    [self ww_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:defaultImage options:0 progress:nil completed:^(UIImage *image, NSError *error, WwKitImageCacheType cacheType, NSURL *imageURL) {
        if (complete) {
            complete(image);
        }
    }];
}

- (void)ww_loadGifImage:(NSString *)gifName {
    NSString *path = [[NSBundle mainBundle] pathForResource:gifName ofType:@"gif"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    UIImage *image = [UIImage ww_animatedGIFWithData:data];
    self.image = image;
}
@end
