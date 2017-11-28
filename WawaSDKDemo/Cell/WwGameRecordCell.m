//
//  WwGameRecordCell.m
//  WawaSDKDemo
//


#import "WwGameRecordCell.h"
#import "UIImageView+WawaKit.h"
#import "UILabel+WawaKit.h"
#import "WawaKitConstants.h"
#import <WawaSDK/WawaSDK.h>

static NSString *BackButtonString = @"back_button";
static NSString *Bottom_UnSelectButtonString = @"cart_unSelect_btn";
static NSString *Bottom_SelectButtonString = @"cart_selected_btn";
static NSString *CartEmptyString = @"cart_default_bg";


@interface WwGameRecordCell ()

@property (nonatomic, strong) UIView *bgView;
//显示照片
@property (nonatomic, strong) UIImageView *image;
//指示器
@property (nonatomic, strong) UIImageView *indicator;
//商品名
@property (nonatomic, strong) UILabel *name;
//数量
@property (nonatomic, strong) UILabel *count;
//价格
@property (nonatomic, strong) UILabel *price;
//时间
@property (nonatomic, strong) UILabel *date;
//时间
@property (nonatomic, strong) UILabel *result;
//分割线
@property (nonatomic, strong) UIView *line;
@property (nonatomic, assign) BOOL updatedConstraints;
@end

@implementation WwGameRecordCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = RGBCOLOR(250, 250, 250);
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self addSubviews];
    }
    return self;
}

#pragma mark - public method
- (void)reloadDataWithModel:(WwGameRecordModel*)model {
    [self.image ww_setToyImageWithUrl:model.wawa.pic];
    self.name.text = model.wawa.name;
    
    NSString *imageName = @"toy_exchange_coin";
    NSInteger money = model.coin;
    CGPoint point = CGPointMake(2, -2);
    
    if (model.coupon > 0) {
        imageName = @"icon_ticket_big";
        money = model.coupon;
        point = CGPointMake(2, -5);
    }
    
    NSMutableAttributedString *imgStr = [UILabel attributedString:[NSString stringWithFormat:@"x%zi", money] withImage:imageName beforeString:YES atPoint:point];
    [self.price setAttributedText:imgStr];
    
    self.date.text = model.dateline;
    if (model.status == 2) {
        _result.layer.backgroundColor = RGBCOLORV(0xe0fdfc).CGColor;
        _result.text = @"成功";
        [_result setTextColor:RGBCOLORV(0x72f3f5)];
    }
    else if (model.status == 1) {
        _result.layer.backgroundColor = RGBCOLORV(0xf2f2f2).CGColor;
        _result.text = @"失败";
        [_result setTextColor:RGBCOLORV(0xc6c6c6)];
    }
    else if (model.status == 0) {
        // 故障
        _result.layer.backgroundColor = RGBCOLORV(0xf2f2f2).CGColor;
        _result.text = @"失败";
        [_result setTextColor:RGBCOLORV(0xc6c6c6)];
    }
}

#pragma mark - 重写setter方法
- (void)setSeparatorVisible:(BOOL)separatorVisible {
    BOOL isVisible = !_line.isHidden;
    if (isVisible != separatorVisible) {
        _line.hidden = !separatorVisible;
    }
}

- (void)setIndicatorVisible:(BOOL)indicatorVisible {
    BOOL isVisible = !_indicator.isHidden;
    if (isVisible != indicatorVisible) {
        _indicator.hidden = !indicatorVisible;
        CGFloat rightOffset = indicatorVisible ? -38.f: -15.f;
        @weakify(self);
        [self.result mas_updateConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.right.equalTo(self.bgView.mas_right).with.offset(rightOffset);
        }];
    }
}

- (void)addSubviews {
    [self.contentView addSubview:self.bgView];
    [self.bgView addSubview:self.line];
    [self.bgView addSubview:self.image];
    [self.bgView addSubview:self.indicator];
    [self.bgView addSubview:self.name];
    [self.bgView addSubview:self.price];
    [self.bgView addSubview:self.date];
    [self.bgView addSubview:self.result];
}

- (void)updateConstraints {
    [super updateConstraints];
    if (_updatedConstraints) {
        return;
    }
    
    _updatedConstraints = YES;
    
    @weakify(self);
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.equalTo(self);
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.height.equalTo(@(HeightOfGameRecordCell));
    }];
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.bottom.equalTo(self.bgView);
        make.left.equalTo(self.bgView).with.offset(15.f);
        make.height.equalTo(@0.5f);
        make.right.equalTo(self.bgView).with.offset(-15.f);;
    }];
    [self.image mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.equalTo(self.bgView).with.offset(16.f);
        make.centerY.equalTo(self.bgView);
        make.height.equalTo(@75.f);
        make.width.equalTo(@75.f);
    }];
    [self.indicator mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.right.equalTo(self.bgView.mas_right).with.offset(-15.f);
        make.centerY.equalTo(self.bgView.mas_centerY);
        make.height.equalTo(@14.f);
        make.width.equalTo(@8.f);
    }];
    [self.name mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.equalTo(self.bgView).with.offset(104.f);
        make.top.equalTo(self.bgView).with.offset(14.f);
        make.height.equalTo(@15.f);
        make.width.equalTo(@150.f);
    }];
    [self.price mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.equalTo(self.bgView).with.offset(104.f);
        make.top.equalTo(self.bgView).with.offset(61.f);
        make.height.equalTo(@17.f);
        make.width.equalTo(@150.f);
    }];
    [self.date mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.equalTo(self.bgView).with.offset(104.f);
        make.top.equalTo(self.bgView).with.offset(36.f);
        make.height.equalTo(@12.f);
        make.width.equalTo(@150.f);
    }];
    [self.result mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.right.equalTo(self.bgView.mas_right).with.offset(-38.f);
        make.top.equalTo(self.bgView).with.offset(43.f);
        make.height.equalTo(@17.f);
        make.width.equalTo(@40.f);
    }];
}

#pragma mark - Getter
- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc] initWithFrame:CGRectZero];
        _bgView.backgroundColor = RGBCOLOR(255, 255, 255);
    }
    return _bgView;
}

- (UIView *)line {
    if (!_line) {
        _line = [[UIView alloc] init];
        _line.backgroundColor = RGBCOLOR(204.f, 204.f, 204.f);
        _line.hidden = YES;
    }
    return _line;
}

- (UIImageView *)image {
    if (!_image) {
        //显示照片
        _image = [[UIImageView alloc] init];
        _image.contentMode = UIViewContentModeScaleAspectFill;
        _image.clipsToBounds = YES;
        _image.layer.borderColor = RGBCOLOR(255, 218, 68).CGColor;
        _image.layer.borderWidth = 0.5;
        _image.layer.cornerRadius = 2;
    }
    return _image;
}

- (UIImageView *)indicator {
    if (!_indicator) {
        _indicator = [[UIImageView alloc] init];
        _indicator.contentMode = UIViewContentModeScaleAspectFill;
        _indicator.clipsToBounds = YES;
        _indicator.image = [UIImage imageNamed:@"icon_game_record_indicator"];
        _indicator.hidden = YES;
    }
    return _indicator;
}

- (UILabel *)name {
    if (!_name) {
        //商品名
        _name = [[UILabel alloc] init];
        _name.font = [UIFont systemFontOfSize:14.0f];
        _name.textColor = RGBCOLOR(68, 68, 68);
    }
    return _name;
}

- (UILabel *)price {
    if (!_price) {
        _price = [[UILabel alloc] init];
        _price.font = [UIFont systemFontOfSize:14.0f];
        _price.textColor = RGBCOLOR(68, 68, 68);
    }
    return _price;
}

- (UILabel *)result {
    if (!_result) {
        _result = [[UILabel alloc] init];
        _result.layer.cornerRadius = 8.5;
        _result.textAlignment = NSTextAlignmentCenter;
        [_result setFont:[UIFont systemFontOfSize:12.f]];
    }
    return _result;
}

- (UILabel *)date {
    if (!_date) {
        _date = [[UILabel alloc] init];
        _date.font = [UIFont systemFontOfSize:13.f];
        _date.textColor = RGBCOLOR(135, 135, 135);
    }
    return _date;
}

- (UILabel *)count {
    if (!_count) {
        _count = [[UILabel alloc] init];
        _count.font = [UIFont systemFontOfSize:13.f];
        _count.textColor = RGBCOLOR(102, 117, 140);
    }
    return _count;
}

@end
