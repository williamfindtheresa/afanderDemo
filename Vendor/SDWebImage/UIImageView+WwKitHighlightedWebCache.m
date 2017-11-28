/*
 * This file is part of the SDWebImage package.
 * (c) Olivier Poitrey <rs@dailymotion.com>
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

#import "UIImageView+WwKitHighlightedWebCache.h"
#import "UIView+WwKitWebCacheOperation.h"

#define UIImageViewHighlightedWebCacheOperationKey @"highlightedImage"

@implementation UIImageView (WwKitHighlightedWebCache)

- (void)ww_setHighlightedImageWithURL:(NSURL *)url {
    [self ww_setHighlightedImageWithURL:url options:0 progress:nil completed:nil];
}

- (void)ww_setHighlightedImageWithURL:(NSURL *)url options:(WwKitWebImageOptions)options {
    [self ww_setHighlightedImageWithURL:url options:options progress:nil completed:nil];
}

- (void)ww_setHighlightedImageWithURL:(NSURL *)url completed:(WwKitWebImageCompletionBlock)completedBlock {
    [self ww_setHighlightedImageWithURL:url options:0 progress:nil completed:completedBlock];
}

- (void)ww_setHighlightedImageWithURL:(NSURL *)url options:(WwKitWebImageOptions)options completed:(WwKitWebImageCompletionBlock)completedBlock {
    [self ww_setHighlightedImageWithURL:url options:options progress:nil completed:completedBlock];
}

- (void)ww_setHighlightedImageWithURL:(NSURL *)url options:(WwKitWebImageOptions)options progress:(WwKitWebImageDownloaderProgressBlock)progressBlock completed:(WwKitWebImageCompletionBlock)completedBlock {
    [self ww_cancelCurrentHighlightedImageLoad];

    if (url) {
        __weak __typeof(self)wself = self;
        id<WwKitWebImageOperation> operation = [WwKitWebImageManager.sharedManager downloadImageWithURL:url options:options progress:progressBlock completed:^(UIImage *image, NSError *error, WwKitImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
            if (!wself) return;
            dispatch_main_sync_safe (^
                                     {
                                         if (!wself) return;
                                         if (image && (options & WwKitWebImageAvoidAutoSetImage) && completedBlock)
                                         {
                                             completedBlock(image, error, cacheType, url);
                                             return;
                                         }
                                         else if (image) {
                                             wself.highlightedImage = image;
                                             [wself setNeedsLayout];
                                         }
                                         if (completedBlock && finished) {
                                             completedBlock(image, error, cacheType, url);
                                         }
                                     });
        }];
        [self ww_setImageLoadOperation:operation forKey:UIImageViewHighlightedWebCacheOperationKey];
    } else {
        dispatch_main_async_safe(^{
            NSError *error = [NSError errorWithDomain:WwKitWebImageErrorDomain code:-1 userInfo:@{NSLocalizedDescriptionKey : @"Trying to load a nil url"}];
            if (completedBlock) {
                completedBlock(nil, error, WwKitImageCacheTypeNone, url);
            }
        });
    }
}

- (void)ww_cancelCurrentHighlightedImageLoad {
    [self ww_cancelImageLoadOperationWithKey:UIImageViewHighlightedWebCacheOperationKey];
}

@end


@implementation UIImageView (HighlightedWebCacheDeprecated)

- (void)setHighlightedImageWithURL:(NSURL *)url {
    [self ww_setHighlightedImageWithURL:url options:0 progress:nil completed:nil];
}

- (void)setHighlightedImageWithURL:(NSURL *)url options:(WwKitWebImageOptions)options {
    [self ww_setHighlightedImageWithURL:url options:options progress:nil completed:nil];
}

- (void)setHighlightedImageWithURL:(NSURL *)url completed:(WwKitWebImageCompletedBlock)completedBlock {
    [self ww_setHighlightedImageWithURL:url options:0 progress:nil completed:^(UIImage *image, NSError *error, WwKitImageCacheType cacheType, NSURL *imageURL) {
        if (completedBlock) {
            completedBlock(image, error, cacheType);
        }
    }];
}

- (void)setHighlightedImageWithURL:(NSURL *)url options:(WwKitWebImageOptions)options completed:(WwKitWebImageCompletedBlock)completedBlock {
    [self ww_setHighlightedImageWithURL:url options:options progress:nil completed:^(UIImage *image, NSError *error, WwKitImageCacheType cacheType, NSURL *imageURL) {
        if (completedBlock) {
            completedBlock(image, error, cacheType);
        }
    }];
}

- (void)setHighlightedImageWithURL:(NSURL *)url options:(WwKitWebImageOptions)options progress:(WwKitWebImageDownloaderProgressBlock)progressBlock completed:(WwKitWebImageCompletedBlock)completedBlock {
    [self ww_setHighlightedImageWithURL:url options:0 progress:progressBlock completed:^(UIImage *image, NSError *error, WwKitImageCacheType cacheType, NSURL *imageURL) {
        if (completedBlock) {
            completedBlock(image, error, cacheType);
        }
    }];
}

- (void)cancelCurrentHighlightedImageLoad {
    [self ww_cancelCurrentHighlightedImageLoad];
}

@end
