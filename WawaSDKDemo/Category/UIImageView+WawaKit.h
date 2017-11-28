//
//  UIImageView+WawaKit.h
//  F_Sky
//

#import <UIKit/UIKit.h>

@interface UIImageView (WawaKit)

#pragma mark - Helper Methods

#pragma mark - Public Methods
- (void)ww_setImageWithURL:(NSString *)url;
- (void)ww_setAvatar:(NSString *)url;
- (void)ww_setToyImageWithUrl:(NSString *)url;

/**
 加载GIF图片

 @param gifName GIF图片名称
 */
- (void)ww_loadGifImage:(NSString *)gifName;

@end
