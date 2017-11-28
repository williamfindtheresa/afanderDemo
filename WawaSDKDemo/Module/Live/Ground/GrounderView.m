//
//  GrounderView.m
//  GrounderDemo
//
//  Created by 贾楠 on 16/3/8.
//  Copyright © 2016年 贾楠. All rights reserved.
//
#import "GrounderView.h"
#import "IconImgView.h"
#import "UIColor+WawaKit.h"

#define BarrageDureation 6.0

@interface GrounderView()
{
    float viewWidth;
    GrounderModel * _normalModel;
}


@property (nonatomic, strong) UIView * blackView; /**< 背景*/
@property (nonatomic, strong) IconImgView * iconImgView; /**< 头像*/
@property (nonatomic, strong) UILabel * topLabel; /**< 昵称 */
@property (nonatomic, strong) UILabel * messageLabel; /**< 消息体*/

@property (nonatomic, strong)  UIImageView * bannerHeadV; /**< banner*/
@property (nonatomic, strong)  UIImageView * bannerFootV; /**< banner*/

@property (nonatomic, strong) NSDate * aniStartDate;  /**< 动画开始的时间*/

@end

@implementation GrounderView

- (void)dealloc
{
    NSLog(@"%s",__func__);
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.durtion = BarrageDureation;
        
        _topLabel = [[UILabel alloc] init];
        _topLabel.font = [UIFont systemFontOfSize:13];
        [self addSubview:_topLabel];
        
        _blackView = [UIView new];
        [self addSubview:_blackView];
 
        //头像
        _iconImgView = [IconImgView IconImgViewWithFrame:CGRectMake(0, 0, 30, 30) BigIconUrlStr:nil smallIconUrlStr:@""];
        
        _iconImgView.leftImg.contentMode = UIViewContentModeScaleAspectFit;
        _iconImgView.borderColor = UIColorFromRGB(0xf9c65e);
        [self addSubview:_iconImgView];
        
        /**< 消息*/
        _messageLabel = [[UILabel alloc] init];
        _messageLabel.textColor = [UIColor whiteColor];
        _messageLabel.font = [UIFont boldSystemFontOfSize:14];
        _messageLabel.clipsToBounds = YES;
        _messageLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_messageLabel];
        
        
        /**< banner  头部*/
        _bannerHeadV = [[UIImageView alloc] initWithFrame:CGRectMake(-15, 0, 30, 30)];
        _bannerHeadV.backgroundColor = [UIColor clearColor];
        _bannerHeadV.hidden = YES;
        [self addSubview:_bannerHeadV];
        
        /**< banner 尾部*/
        _bannerFootV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        _bannerFootV.backgroundColor = [UIColor clearColor];
        _bannerFootV.hidden = YES;
        [self addSubview:_bannerFootV];
    }
    return self;
}

#pragma mark - BRElementInterface
/**< 动画元素 */
- (UIView *)BR_element
{
    return self;
}
/**< 可以在此处 异步线程处理 展示数据。 主线程回调 layoutFinish, must call finish*/
- (void)BR_batchResourceModel:(id)model finish:(layoutFinish)complete
{
    if ([model isKindOfClass:[GrounderModel class]]) {
        _normalModel = model;
        //普通票屏幕弹幕
        [self setContent:model];
    } else {
        self.hidden = YES;
    }
    complete();
}

/**< 动画元素 宽度， after batch*/
- (CGFloat)BR_width
{
    return  viewWidth;
}

- (void)BR_updateLayout
{
    
}

#pragma mark -  Layout
//不同弹幕
- (void)setContent:(GrounderModel*)model
{
    
    [self setTextModel:model];
    return; // 目前，只需要文字的 模版
    
    
    if (model.showTxtOnly) {
        //横屏聊天普通文本
        [self setTextModel:model];
        return;
    }
    //花钱弹幕
    [self setType:GrounderTypeDefault];
    
    self.chatModel = model.chatModel;
    self.userInteractionEnabled = YES;
    _iconImgView.userInteractionEnabled = YES;
    _messageLabel.userInteractionEnabled = YES;
    _iconImgView.leftSmallImgView.hidden = NO;
    _iconImgView.leftImg.layer.borderWidth = 1.0f;
    
    int uid = 0, verified = 0;
    NSString *portrait;
    if (model.chatModel) {
        WwUserModel *user = model.chatModel.user;
        uid     = user.uid;
        portrait = user.portrait;
    }
    
    NSString * name = @"哈哈哈";
    NSString * text = @"撒的金卡是快乐到家阿斯兰";
    
    if (model) {
        name = model.name;
        text = model.message;
    }
    
    //昵称
    _topLabel.text = name;
    _topLabel.frame = CGRectMake(35, 0, 150, 10);
//    _topLabel.textColor = model.gatewayRoomChatGet.user.gender > 0 ? kBoyNickColor : kGirlNickColor;
    
    
    //消息体
    _messageLabel.text = text;
    _messageLabel.frame = CGRectMake(35, 12, 150, 18);
    _messageLabel.textColor = [UIColor whiteColor];
    
    
    viewWidth = _messageLabel.frame.size.width + 55;
    if (_topLabel.frame.size.width > _messageLabel.frame.size.width) {
        viewWidth = _topLabel.frame.size.width + 55;
    }
    
    self.frame = CGRectMake(ScreenWidth + 20, 0, viewWidth, 30);
    
    CGRect rect;
    rect.size.width  = viewWidth - 15;
    rect.size.height = CGRectGetHeight(_messageLabel.frame);
    rect.origin.x    = 5;
    rect.origin.x    = _messageLabel.frame.origin.y;
    _blackView.frame = rect;
    
    //设置头像
    [_iconImgView setImgStr:portrait smallImgStr:verified];
    
    
    
    /**< 彩色弹幕背景色*/
    if (realString(model.chatColor).length) {
        
        _iconImgView.borderColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
        _blackView.backgroundColor = [UIColor clearColor];
        
        // 彩色弹幕
        CAGradientLayer *gradientLayer = [CAGradientLayer layer];
        gradientLayer.colors = @[(__bridge id)[[UIColor blackColor] colorWithAlphaComponent:0.8].CGColor, (__bridge id)[[UIColor blackColor] colorWithAlphaComponent:0.0].CGColor];
        gradientLayer.locations = @[@0.2, @1.0];
        gradientLayer.startPoint = CGPointMake(0, 0);
        gradientLayer.endPoint = CGPointMake(1.0, 0);
        gradientLayer.frame = CGRectMake(0.0, 0.0, CGRectGetWidth(_blackView.bounds) + 15.0, CGRectGetHeight(_blackView.bounds));
        
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:gradientLayer.bounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerTopLeft cornerRadii:gradientLayer.bounds.size];
        
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = gradientLayer.bounds;
        maskLayer.path = maskPath.CGPath;
        gradientLayer.mask = maskLayer;
        
        [_blackView.layer insertSublayer:gradientLayer atIndex:0];
        
    }
    else {
        _blackView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    }
}

- (void)setTextModel:(GrounderModel *)model  /**< 只显示文本*/
{
    self.chatModel = model.chatModel;
    _type = GrounderTypeText;
    self.iconImgView.hidden = YES;
    self.topLabel.hidden = YES;
    self.bannerHeadV.hidden = YES;
    self.bannerFootV.hidden = YES;
    self.blackView.hidden = YES;
    
    NSString * text = @"撒的金卡是快乐到家阿斯兰";
    if (model) {
        text = model.message;
    }
    
    //消息体
    NSString *body = [NSString stringWithFormat:@"%@: %@",model.name, text];
    _messageLabel.text = body;
    _messageLabel.textColor = DVLColorGen(@"#ffea87");
    _messageLabel.font = font(16);
    _messageLabel.frame = CGRectMake(5, 6, 100, 20);
    
    _messageLabel.shadowColor = DVLColorGenAlpha(@"#000000", 0.3);
    _messageLabel.shadowOffset = CGSizeMake(0.5, 0.5);

    
    viewWidth = _messageLabel.frame.size.width + 10;
    self.frame = CGRectMake(0, 0, viewWidth, 30);
    CGRect rect;
    rect.size.width  = viewWidth;
    rect.size.height = CGRectGetHeight(_messageLabel.frame);
    rect.origin.x    = 0;
    rect.origin.x    = _messageLabel.frame.origin.y;
    _blackView.frame = rect;
}

#pragma mark - Action
- (void)userClickAction
{
    
}


/**< banner 点击*/
- (void)didTouched
{
    
}


#pragma mark - Getter Setter
- (void)setType:(GrounderType)type
{
    if (_type == type) {
        return;
    }
    _type = type;
    _topLabel.hidden = !(_type == GrounderTypeDefault);
    _iconImgView.hidden = _type == GrounderTypePublic;
    _bannerHeadV.hidden = _type != GrounderTypePublic;
    _bannerFootV.hidden = _type != GrounderTypePublic;
}

@end
