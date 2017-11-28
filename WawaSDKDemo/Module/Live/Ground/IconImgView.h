//
//  IconImgView.h
//  关注动画
//
//  Created by liyang on 16/5/18.
//  Copyright © 2016年 李洋. All rights reserved.
//

#import <UIKit/UIKit.h>

@class IconImgView;
@protocol IconImgViewDelegate <NSObject>

- (void)didClicked:(IconImgView *)iconView;

@end

@interface IconImgView : UIView


@property (nonatomic, strong) UIColor *borderColor;
@property (nonatomic, strong) UIImageView *leftImg;
@property (nonatomic, strong) UIImageView *leftSmallImgView;

@property (nonatomic, copy) void(^ImgClickBlock)(void);

@property (nonatomic, weak) id<IconImgViewDelegate> delegate;

+(instancetype)IconImgViewWithFrame:(CGRect )frame BigIconUrlStr:(NSString*)bigIconUrlStr smallIconUrlStr:(NSString *)smallIconUrlStr;


- (void)setImgStr:(NSString *)imgStr smallImgStr:(int)smallImgStr;


@end
