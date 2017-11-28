//
//  WwToyDeliverHeader.m
//  F_Sky
//
//

#import <Foundation/Foundation.h>
#import "WwToyDeliverHeader.h"
#import "WawaKitConstants.h"

static NSString *HeaderPreparingIcon = @"toy_deliver_prepare";
static NSString *HeaderDeliveringIcon = @"toy_deliver_express";
static NSString *HeaderReceivedIcon = @"toy_deliver_receive";
static NSString *HeaderExchangedIcon = @"toy_exchange_icon";

@interface WwToyDeliverHeader ()
@property (nonatomic, strong) UIColor *color;
@property (nonatomic, strong) UIView *bgView;
@end

@implementation WwToyDeliverHeader

+ (instancetype)createWithStyle:(ToyDeliverHeaderStyle)style {
    WwToyDeliverHeader *header = [[WwToyDeliverHeader alloc] initWithStyle:style];
    header.style = style;
    return header;
}

- (instancetype)initWithStyle:(ToyDeliverHeaderStyle)style {
    self = [super initWithFrame:CGRectMake(0, 0, ScreenWidth, HeightOfToyDeliverHeader)];
    if (self) {
        _style = style;
        [self initUI];
    }
    return self;
}

- (void)reloadWithData:(WwWawaOrderModel *)model {
    self.time.text = model.dateline;
}

- (void)initUI {
    NSString *stateText;
    NSString *iconName;
    NSArray *array;
    switch (_style) {
        case DeliverHeader_Prepareing:
            iconName = HeaderPreparingIcon;
            stateText = @"发货准备中";
            _color = RGBCOLOR(89, 198, 247);
            array = @[(id)RGBCOLORV(0xddf4ff).CGColor,
                      (id)RGBCOLORV(0xffffff).CGColor];
            break;
        case DeliverHeader_Delivering:
            iconName = HeaderDeliveringIcon;
            stateText = @"配送中";
            _color = RGBCOLOR(75, 204, 172);
            array = @[(id)RGBCOLORV(0xdafbee).CGColor,
                      (id)RGBCOLORV(0xffffff).CGColor];
            break;
        case DeliverHeader_Receiverd:
            iconName = HeaderReceivedIcon;
            stateText = @"已收货";
            _color = RGBCOLOR(135, 135, 135);
            array = @[(id)RGBCOLORV(0xe8e8e8).CGColor,
                      (id)RGBCOLORV(0xffffff).CGColor];
            break;
        case DeliverHeader_Exchanged:
            iconName = HeaderExchangedIcon;
            stateText = @"已兑换";
            _color = kAppLabelColor;
            array = @[(id)RGBCOLORV(0xfff6d3).CGColor,
                      (id)RGBCOLORV(0xffffff).CGColor];
            break;
        default:
            break;
    }
    CAGradientLayer *gradientLayer = [[CAGradientLayer alloc] init];
    gradientLayer.frame = self.bounds;
    gradientLayer.colors = array;
    gradientLayer.locations = @[@0, @1];
    [gradientLayer setStartPoint:CGPointMake(0, 0.5)];
    [gradientLayer setEndPoint:CGPointMake(1, 0.5)];
    [self.bgView.layer addSublayer:gradientLayer];
    
    self.icon.image = [UIImage imageNamed:iconName];
    
    self.state.text = stateText;
    [self addSubview:self.bgView];
    [self.bgView addSubview:self.icon];
    [self.bgView addSubview:self.state];
    [self.bgView addSubview:self.time];
    
    @weakify(self);
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.edges.equalTo(self);
    }];
    CGFloat iconWidth=19.f, iconHeight = 16.f, topPadding = 8.f;
    if (_style == DeliverHeader_Exchanged) {
        iconWidth = 20.f;
        iconHeight = 20.f;
        topPadding = 6.f;
    }
    [_icon mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.equalTo(self.bgView).with.offset(14.f);
        make.width.equalTo(@(iconWidth));
        make.height.equalTo(@(iconHeight));
        make.top.equalTo(self.bgView).with.offset(topPadding);
    }];
    [_state mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.equalTo(self.bgView).with.offset(47.f);
        make.top.equalTo(self.bgView).with.offset(11.f);
        make.width.equalTo(@80.f);
        make.height.equalTo(@12.f);
    }];
    [_time mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.right.equalTo(self.bgView).with.offset(-15.f);
        make.top.equalTo(self.bgView).with.offset(11.f);
        make.width.equalTo(@140.f);
        make.height.equalTo(@12.f);
    }];
}

- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc] initWithFrame:CGRectZero];
        _bgView.backgroundColor = RGBCOLOR(255, 255, 255);
    }
    return _bgView;
}

- (UIImageView *)icon {
    if (!_icon) {
        _icon = [[UIImageView alloc] initWithFrame:CGRectZero];
    }
    return _icon;
}

- (UILabel *)state {
    if (!_state) {
        _state = [[UILabel alloc] init];
        _state.font = [UIFont systemFontOfSize:13.0f];
        _state.textColor = _color;
        _state.textAlignment = NSTextAlignmentLeft;
    }
    return _state;
}

- (UILabel *)time {
    if (!_time) {
        _time = [[UILabel alloc] init];
        _time.font = [UIFont systemFontOfSize:13.0f];
        _time.textColor = _color;
        _time.textAlignment = NSTextAlignmentRight;
    }
    return _time;
}

@end
