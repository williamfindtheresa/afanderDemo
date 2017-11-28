//
//  WwPopupsView.h
//  prizeClaw
//
//  Created by yuyou on 2017/10/10.
//  Copyright © 2017年 QuanMin.ShouYin. All rights reserved.
//

// 备注：只是简单测试了一下，使用时，自测一下效果

#import <UIKit/UIKit.h>

typedef void (^PopupsBlock)();

@class WwPopupsView;

/**
 弹出类型
 
 WwPopupsViewTypeNormal:
    1、主要是一些文字展示，不会传出点击事件，点击事件只是移除弹窗
 
 WwPopupsViewTypeEvent:
    1、相比WwPopupsViewTypeNormal，WwPopupsViewTypeEvent会通过popupsViewDelegate:eventButton:代理传递出去点击事件
 
 WwPopupsViewTypeCustom:
    1、使用WwPopupsViewTypeCustom类型只是会提供遮罩，内容弹窗用户可以完全自定义，只需要通过customUI:withFrame:把自定义View以及frame传入即可
    2、如果自定义全屏View，请手动调用removePopupsView移除弹窗
 */
typedef NS_OPTIONS(NSUInteger, WwPopupsViewType )
{
    WwPopupsViewTypeNormal = 0, //不会出来逻辑
    WwPopupsViewTypeEvent,      //带有事件处理
    WwPopupsViewTypeCustom,     //自定中间弹框内容
    WwPopupsViewTypeNoob,     //新手弹窗
};

@protocol WwPopupsViewDelegate <NSObject>
/**
 弹窗的点击事件
 @param popupsView 弹窗
 @param btn btn.tag: 0-取消，1-确定
 */
- (void)popupsViewDelegate:(WwPopupsView *)popupsView eventButton:(UIButton *)btn;

@end



@interface WwPopupsView : UIView
@property (nonatomic, weak) id <WwPopupsViewDelegate> delegate;


/**
 实例化弹窗

 @param type 弹窗类型
 */
+ (instancetype)instancePopupsView:(WwPopupsViewType)type;

/**
 带回调的实例化方法

 @param type pop 类型
 @param confirm 确认block
 @param cancel 取消block
 */
+ (instancetype)instancePopupsView:(WwPopupsViewType)type withConfirmBlock:(PopupsBlock)confirm andCancelBlock:(PopupsBlock)cancel;

/**
 显示弹出
 */
- (void)show;

/**
 以比较高的优先级显示弹出
 */
- (void)showWithHighLevel;
/**
 移除
 */
- (void)removePopupsView;

#pragma mark - 共有属性

/**
 设置卡片内容size(其实是在挤压contentTitle的高度)
 */
@property (nonatomic, assign) CGSize contentSize;

/**
 遮罩透明度
 */
@property (nonatomic, assign) CGFloat shadeAlpha;

#pragma mark - WwPopupsViewTypeCustom 拥有下面的属性
/**
 自定义控件

 @param customView 自定义内容View
 @param frame 自定义内容的frame
 */
- (void)customUI:(UIView *)customView withFrame:(CGRect)frame;


#pragma mark - WwPopupsViewTypeNormal , WwPopupsViewTypeEvent类型 拥有下面的属性

#pragma mark - 微调界面 “确定按钮高度” ---start
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sureBtnConstraintHeight;

#pragma mark - 微调界面 “确定按钮高度” ---end

/**
 卡片内容背景颜色(默认白色)
 */
@property (nonatomic, strong) UIColor *contentColor;

/**
 中间内容图片数组
 */
@property (nonatomic, strong) NSArray *middleImages;

/**
 背景图片
 */
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
/**
 中间图片数组
 */
@property (weak, nonatomic) IBOutlet UIView *middleImagesView;
//底部距离
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *middleImagesViewConstraintBottom;

/**
 标题
 */
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
/**
 内容文字
 */
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
/**
 描述文字
 */
@property (weak, nonatomic) IBOutlet UILabel *imageDesLabel;
/**
 中间文字title
 */
@property (weak, nonatomic) IBOutlet UILabel *middleLabel;
/**
 确定按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *sureButton;

/**
 右上角关闭按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *closeButton;

@end
