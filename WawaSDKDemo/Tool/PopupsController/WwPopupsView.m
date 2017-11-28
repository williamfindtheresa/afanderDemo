//
//  WwPopupsView.m
//  F_Sky
//
//

#import "WwPopupsView.h"

@interface WwPopupsView ()

/**
 遮罩
 */
@property (weak, nonatomic) IBOutlet UIView *shadeView;
/**
 内容View
 */
@property (weak, nonatomic) IBOutlet UIView *contentView;
/**
 contentView宽
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewConstraintWith;
/**
 contentView高
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewConstraintHeight;
/**
 * 确认按钮回调block
 */
@property (nonatomic, copy) PopupsBlock confirmB;
/**
 * 取消按钮回调block
 */
@property (nonatomic, copy) PopupsBlock cancelB;

@end

@implementation WwPopupsView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(removePopupsView)];
    [self.shadeView addGestureRecognizer:gesture];
}

+ (instancetype)instancePopupsView:(WwPopupsViewType)type {
    if (type == WwPopupsViewTypeEvent) {
        return [[[NSBundle mainBundle] loadNibNamed:@"WwPopupsEventView" owner:nil options:nil] lastObject];
    }
    else if (type == WwPopupsViewTypeCustom) {
        return [[[NSBundle mainBundle] loadNibNamed:@"WwPopupsContomView" owner:nil options:nil] lastObject];
    }
    else if (type == WwPopupsViewTypeNoob) {
        return [[[NSBundle mainBundle] loadNibNamed:@"WwPopupsNoobView" owner:nil options:nil] lastObject];
    }
    return [[[NSBundle mainBundle] loadNibNamed:@"WwPopupsNormalView" owner:nil options:nil] lastObject];
}

+ (instancetype)instancePopupsView:(WwPopupsViewType)type withConfirmBlock:(PopupsBlock)confirm andCancelBlock:(PopupsBlock)cancel {
    WwPopupsView *view = nil;
    if (type == WwPopupsViewTypeEvent) {
        view = [[[NSBundle mainBundle] loadNibNamed:@"WwPopupsEventView" owner:nil options:nil] lastObject];
    }
    else if (type == WwPopupsViewTypeCustom) {
        view = [[[NSBundle mainBundle] loadNibNamed:@"WwPopupsContomView" owner:nil options:nil] lastObject];
    }
    else if (type == WwPopupsViewTypeNoob) {
        view = [[[NSBundle mainBundle] loadNibNamed:@"WwPopupsNoobView" owner:nil options:nil] lastObject];
    }
    if (!view) {
        view = [[[NSBundle mainBundle] loadNibNamed:@"WwPopupsNormalView" owner:nil options:nil] lastObject];
    }
    view.confirmB = confirm;
    view.cancelB = cancel;
    
    return view;
}

- (void)show {
    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    self.frame = window.frame;
    [window addSubview:self];
}

- (void)showWithHighLevel {
    NSArray *windows = [[UIApplication sharedApplication] windows];
    UIWindow *lastWindow = (UIWindow *)[windows lastObject];
    if (lastWindow.hidden) { //最上面的window有可能是隐藏的
        lastWindow = [UIApplication sharedApplication].keyWindow;
    } else {
        lastWindow.windowLevel = MAX(lastWindow.windowLevel+1, UIWindowLevelAlert);
    }
    self.frame = lastWindow.frame;
    [lastWindow addSubview:self];
}
/**
 移除
 */
- (void)removePopupsView {
    [self removeFromSuperview];
}

- (IBAction)closeButtonClick:(UIButton *)btn {
    [self removePopupsView];
    if (btn.tag < 0) {
        return;
    }
    if ([self.delegate respondsToSelector:@selector(popupsViewDelegate:eventButton:)]) {
        [self.delegate popupsViewDelegate:self eventButton:btn];
    }
    if (btn.tag == 0) {
        if (_cancelB) {
            _cancelB();
        }
    }
    else if (btn.tag == 1) {
        if (_confirmB) {
            _confirmB();
        }
    }
}

//设置size
- (void)setContentSize:(CGSize)contentSize {
    _contentSize = contentSize;
    if (contentSize.width > 0) {
        self.contentViewConstraintWith.constant = contentSize.width;
    }
    if (contentSize.height > 0) {
        self.contentViewConstraintHeight.constant = contentSize.height;
    }
}

//遮罩透明度
- (void)setShadeAlpha:(CGFloat)shadeAlpha {
    _shadeAlpha = shadeAlpha;
    if (shadeAlpha < 0.2) {
        [self.shadeView setBackgroundColor:[UIColor clearColor]];
    }
    else {
        self.shadeView.alpha = shadeAlpha;
    }
}

//中间内容图片数组
- (void)setMiddleImages:(NSArray *)middleImages {
    _middleImages = middleImages;
    [self setupContentImages:middleImages];
}

//内容卡片背景颜色
- (void)setContentColor:(UIColor *)contentColor {
    _contentColor = contentColor;
    self.contentView.backgroundColor = contentColor;
}

- (void)setupContentImages:(NSArray *)images {
    if (images.count < 1) {
        return;
    }
    [self.middleImagesView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    NSInteger count = images.count;
    for (NSInteger i = 0; i < count; i++) {
        UIImageView *img = [[UIImageView alloc] init];
        img.image = [UIImage imageNamed:images[i]];
        img.contentMode = UIViewContentModeScaleToFill;
        [self.middleImagesView addSubview:img];
    }
    
    //布局
    for (NSInteger i = 0; i < count; i++) {
        UIImageView *imgView = self.middleImagesView.subviews[i];
        UIImage *img = imgView.image;
        CGSize imgSize = img.size;
        CGFloat X = (self.middleImagesView.width - imgSize.width) * 0.5;
        CGFloat Y = (self.middleImagesView.height - imgSize.height) * 0.5;
        imgView.frame = CGRectMake(X, Y, imgSize.width, imgSize.height);
    }
}

- (void)customUI:(UIView *)customView withFrame:(CGRect)frame {
    if (customView == nil) {
        return;
    }
    [self.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.contentView addSubview:customView];
//    customView.bounds = frame;
    // 父视图的宽高直接取customView
    self.contentViewConstraintWith.constant = frame.size.width;
    self.contentViewConstraintHeight.constant = frame.size.height;
}

@end
