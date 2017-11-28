//
//  IconImgView.m
//  关注动画
//
//  Created by liyang on 16/5/18.
//  Copyright © 2016年 李洋. All rights reserved.
//
#define RGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]
#import "IconImgView.h"
@interface IconImgView()

@property (nonatomic, strong) UITapGestureRecognizer *tapGesturRecognizer;

@end

@implementation IconImgView

- (void)dealloc
{
    NSLog(@"%s",__func__);
}


- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self configLeftIcon];
}


+(instancetype)IconImgViewWithFrame:(CGRect )frame
                      BigIconUrlStr:(NSString*)bigIconUrlStr
{
    
    IconImgView * iconImgView = [[IconImgView alloc]initWithFrame:frame];
    
    [iconImgView configLeftIcon];
    
    return iconImgView;
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    CGRect lefeframe = self.bounds;
    self.leftImg.frame = lefeframe;
    self.leftImg.layer.cornerRadius = CGRectGetHeight(lefeframe) *0.5;
}

#pragma mark - Helper
- (void)configLeftIcon
{
    self.leftImg = [[UIImageView alloc]initWithFrame:self.bounds];
    self.leftImg.layer.masksToBounds = YES;
    [self addSubview:self.leftImg];
    self.leftImg.contentMode = UIViewContentModeScaleAspectFill;
    
    self.tapGesturRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickIconImageView)];
    [self.leftImg addGestureRecognizer:self.tapGesturRecognizer];
    self.leftImg.userInteractionEnabled=YES;
}

#pragma mark - Public

- (void)setBorderColor:(UIColor *)borderColor
{
    _borderColor = borderColor;
    self.leftImg.layer.borderWidth = 1.0;
    self.leftImg.layer.borderColor = borderColor.CGColor;
}

- (void)clickIconImageView
{
    if (self.ImgClickBlock) {
        self.ImgClickBlock();
    }
    if ([self.delegate respondsToSelector:@selector(didClicked:)]) {
        [self.delegate didClicked:self];
    }
}

- (void)setImgStr:(NSString *)imgStr
{
    [self.leftImg sd_setImageWithURL:[NSURL URLWithString:realString(imgStr)]];
}

@end
