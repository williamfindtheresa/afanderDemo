//
//  SDPhotoBrowser.h
//  photobrowser
//
//  Created by aier on 15-2-3.
//  Copyright (c) 2015年 aier. All rights reserved.
//

#import <UIKit/UIKit.h>


@class SDButton, SDPhotoBrowser;

@protocol SDPhotoBrowserDelegate <NSObject>

//@required

@optional

- (UIImage *)photoBrowser:(SDPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index;


- (NSURL *)photoBrowser:(SDPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index;

@end


@interface SDPhotoBrowser : UIView <UIScrollViewDelegate>

@property (nonatomic, weak) UIView *sourceImagesContainerView;
@property (nonatomic, assign) NSInteger currentImageIndex;
/**  tableView时使用  */
@property (nonatomic, assign) NSInteger section;
@property (nonatomic, assign) NSInteger imageCount;
/**  是否单张图片  */
@property (nonatomic, assign) BOOL isSingelImage;

@property (nonatomic, weak) id<SDPhotoBrowserDelegate> delegate;

- (void)show;


@end
