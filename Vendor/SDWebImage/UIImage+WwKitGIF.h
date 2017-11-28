//
//  UIImage+GIF.h
//  LBGIFImage
//
//  Created by Laurin Brandner on 06.01.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (WwKitGIF)

+ (UIImage *)ww_animatedGIFNamed:(NSString *)name;

+ (UIImage *)ww_animatedGIFWithData:(NSData *)data;

- (UIImage *)ww_animatedImageByScalingAndCroppingToSize:(CGSize)size;

@end
