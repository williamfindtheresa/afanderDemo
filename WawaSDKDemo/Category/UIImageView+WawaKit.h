//
//  UIImageView+WawaKit.h
//  WawaSDKDemo
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, WwKitImageUrlRuleType) {
    WwKitImageUrlRuleTypeInvalid = -1,
    WwKitImageUrlRuleTypeSmall = 0,    // UIImageView size 70*70
    WwKitImageUrlRuleTypeMedium,       // UIImageView size 180*180
    WwKitImageUrlRuleTypeNormal,       // UIImageView size 240*240
    WwKitImageUrlRuleTypeBig           // UIImageView size 750*750
};


@interface UIImageView (WawaKit)

#pragma mark - Helper Methods

/**
 根据image key拼接image完整URL

 @param image image key
 @param type image大小格式，参考WwKitImageUrlRuleType
 @return 返回image完整URL
 */
+ (NSString *)getImageWithPara:(NSString *)image withType:(WwKitImageUrlRuleType)type;

#pragma mark - Public Methods
- (void)ww_setFitImageWithUrl:(NSString *)url;
- (void)ww_setImageWithUrl:(NSString *)url;
- (void)ww_setToyImageWithUrl:(NSString *)url;

- (void)ww_setAvatarRoomLoadingWithPara:(NSString *)url toType:(WwKitImageUrlRuleType)type placeImage:(NSString *)imageName;

/**
 *  带 fadein 效果
 */
- (void)ww_setAvatar:(NSString *)url type:(WwKitImageUrlRuleType)type completed:(void(^)(UIImage *image))complete;

/**
 加载GIF图片

 @param gifName GIF图片名称
 */
- (void)ww_loadGifImage:(NSString *)gifName;

@end
