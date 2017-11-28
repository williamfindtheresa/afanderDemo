//
//  WwRecordPreviewCell.m
//  WawaSDKDemo
//

#import <Foundation/Foundation.h>
#import "WwRecordPreviewCell.h"
#import "UIImageView+WawaKit.h"
#import "UILabel+WawaKit.h"
#import "WawaKitConstants.h"

@interface WwRecordPreviewCell ()

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UILabel *title;
@property (nonatomic, strong) UIButton *shareBtn;
@property (nonatomic, strong) UIImageView *videoPreview;
@property (nonatomic, strong) UIButton *play;
@property (nonatomic, assign) BOOL updatedConstraints;

@end

@implementation WwRecordPreviewCell

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

- (void)reloadDataWithModel:(WwGameRecordModel*)model {
    [self.videoPreview ww_setToyImageWithUrl:model.wawa.pic];
}

- (void)addSubviews {
    [self.contentView addSubview:self.bgView];
    [self.bgView addSubview:self.title];
    [self.bgView addSubview:self.shareBtn];
    [self.bgView addSubview:self.videoPreview];
    [self.videoPreview addSubview:self.play];
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
        make.edges.equalTo(self);
    }];
    [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.equalTo(self.bgView).with.offset(18.f);
        make.left.equalTo(self.bgView).with.offset(16.f);
        make.height.equalTo(@13.f);
        make.width.equalTo(@100.f);
    }];
    [self.shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.right.equalTo(self.bgView);
        make.top.equalTo(self.bgView);
        make.height.equalTo(@49.f);
        make.width.equalTo(@50.f);
    }];
    
    [self.videoPreview mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.equalTo(self.bgView).with.offset(15.f);
        make.right.equalTo(self.bgView).with.offset(-15.f);
        make.top.equalTo(self.bgView).with.offset(52.f);
        make.height.equalTo(@345.f);
        make.width.equalTo(@345.f);
    }];
    [self.play mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.edges.equalTo(self.videoPreview);
    }];
}


- (void)onPreviewButtonClicked:(UIButton *)button {
    if (button == _shareBtn) {
        if ([self.delegate respondsToSelector:@selector(onRecordPreviewClickAction:)]) {
            [self.delegate onRecordPreviewClickAction:RecordPreview_Share];
        }
    }
    else if (button == _play) {
        if ([self.delegate respondsToSelector:@selector(onRecordPreviewClickAction:)]) {
            [self.delegate onRecordPreviewClickAction:RecordPreview_Play];
        }
    }
}

#pragma mark - Getter
- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc] initWithFrame:CGRectZero];
        _bgView.backgroundColor = RGBCOLOR(255, 255, 255);
    }
    return _bgView;
}

- (UILabel *)title {
    if (!_title) {
        _title = [[UILabel alloc] init];
        _title.font = [UIFont systemFontOfSize:14.0f];
        _title.textColor = RGBCOLOR(68, 68, 68);
        _title.text = @"游戏视频";
    }
    return _title;
}

- (UIButton *)shareBtn {
    if (!_shareBtn) {
        _shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _shareBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_shareBtn setImage:[UIImage imageNamed:@"icon_game_record_shared"] forState:UIControlStateNormal];
        [_shareBtn addTarget:self action:@selector(onPreviewButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_shareBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    return _shareBtn;
}

- (UIImageView *)videoPreview {
    if (!_videoPreview) {
        _videoPreview = [[UIImageView alloc] init];
        _videoPreview.userInteractionEnabled = YES;
        _videoPreview.contentMode = UIViewContentModeScaleAspectFill;
        _videoPreview.clipsToBounds = YES;
        _videoPreview.layer.borderColor = kAppLabelColor.CGColor;
        _videoPreview.layer.borderWidth = 0.5;
        _videoPreview.layer.cornerRadius = 2;
    }
    return _videoPreview;
}

- (UIButton *)play {
    if (!_play) {
        _play = [UIButton buttonWithType:UIButtonTypeCustom];
        [_play setImage:[UIImage imageNamed:@"icon_game_record_play"] forState:UIControlStateNormal];
        [_play setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_play addTarget:self action:@selector(onPreviewButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _play;
}

@end


@interface WwRecordDetailCell ()
@property (nonatomic, strong) UIView *bgView;
//显示照片
@property (nonatomic, strong) UIImageView *image;
//商品名
@property (nonatomic, strong) UILabel *name;
//价格
@property (nonatomic, strong) UILabel *price;
//时间
@property (nonatomic, strong) UILabel *date;
//时间
@property (nonatomic, strong) UILabel *result;
//分割线
@property (nonatomic, strong) UIView *line;
//时间
@property (nonatomic, strong) UILabel *orderName;
//游戏编号
@property (nonatomic, strong) UILabel *orderId;
//申诉提醒
@property (nonatomic, strong) UILabel *appeal;
//申诉按钮
@property (nonatomic, strong) UIButton *appealBtn;
//分割线
@property (nonatomic, strong) UIView *line2;
@property (nonatomic, assign) BOOL updatedConstraints;
@end

@implementation WwRecordDetailCell

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
    self.orderId.text = model.orderId;
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

- (void)addSubviews {
    [self.contentView addSubview:self.bgView];
    [self.bgView addSubview:self.line];
    [self.bgView addSubview:self.image];
    [self.bgView addSubview:self.line2];
    [self.bgView addSubview:self.name];
    [self.bgView addSubview:self.price];
    [self.bgView addSubview:self.date];
    [self.bgView addSubview:self.result];
    [self.bgView addSubview:self.orderName];
    [self.bgView addSubview:self.orderId];
    [self.bgView addSubview:self.appeal];
    [self.bgView addSubview:self.appealBtn];
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
        make.edges.equalTo(self);
    }];
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.equalTo(self.bgView.mas_top).with.offset(103.f);
        make.left.equalTo(self.bgView).with.offset(15.f);
        make.height.equalTo(@0.5f);
        make.right.equalTo(self.bgView).with.offset(-15.f);;
    }];
    [self.image mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.equalTo(self.bgView.mas_top).with.offset(14.f);
        make.left.equalTo(self.bgView).with.offset(16.f);
        make.height.equalTo(@75.f);
        make.width.equalTo(@75.f);
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
        make.right.equalTo(self.bgView.mas_right).with.offset(-15.f);
        make.top.equalTo(self.bgView).with.offset(43.f);
        make.height.equalTo(@17.f);
        make.width.equalTo(@40.f);
    }];
    [self.orderName mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.equalTo(self.bgView).with.offset(16.f);
        make.top.equalTo(self.bgView).with.offset(118.f);
        make.height.equalTo(@14.f);
        make.width.equalTo(@75.f);
    }];
    [self.orderId mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.right.equalTo(self.bgView).with.offset(-16.f);
        make.top.equalTo(self.bgView).with.offset(118.f);
        make.height.equalTo(@12.f);
        make.width.equalTo(@230.f);
    }];
    [self.line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.equalTo(self.bgView.mas_top).with.offset(144.f);
        make.left.equalTo(self.bgView).with.offset(15.f);
        make.height.equalTo(@0.5f);
        make.right.equalTo(self.bgView).with.offset(-15.f);;
    }];
    [self.appeal mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.equalTo(self.bgView).with.offset(16.f);
        make.top.equalTo(self.bgView).with.offset(157.f);
        make.height.equalTo(@28.f);
        make.width.equalTo(@180.f);
    }];
    [self.appealBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.right.equalTo(self.bgView).with.offset(-16.f);
        make.top.equalTo(self.bgView).with.offset(157.f);
        make.height.equalTo(@28.f);
        make.width.equalTo(@90.f);
    }];
}

- (void)onPreviewButtonClicked:(UIButton *)button {
    if (button == _appealBtn) {
        if ([self.delegate respondsToSelector:@selector(onRecordPreviewClickAction:)]) {
            [self.delegate onRecordPreviewClickAction:RecordPreview_Appeal];
        }
    }
}


#pragma mark - Getter
- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc] initWithFrame:CGRectZero];
        _bgView.backgroundColor = RGBCOLOR(255, 255, 255);
    }
    return _bgView;
}

- (UIView *)line2 {
    if (!_line2) {
        _line2 = [[UIView alloc] init];
        _line2.backgroundColor = RGBCOLOR(234, 234, 234);
    }
    return _line2;
}

- (UIView *)line {
    if (!_line) {
        _line = [[UIView alloc] init];
        _line.backgroundColor = RGBCOLOR(234, 234, 234);
    }
    return _line;
}

- (UIImageView *)image {
    if (!_image) {
        //显示照片
        _image = [[UIImageView alloc] init];
        _image.contentMode = UIViewContentModeScaleAspectFill;
        _image.clipsToBounds = YES;
        _image.layer.borderColor = kAppLabelColor.CGColor;
        _image.layer.borderWidth = 0.5;
        _image.layer.cornerRadius = 2;
    }
    return _image;
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
        _result.font = [UIFont systemFontOfSize:12.0f];
        _result.layer.cornerRadius = 8.5;
        _result.textAlignment = NSTextAlignmentCenter;
    }
    return _result;
}

- (UILabel *)date {
    if (!_date) {
        _date = [[UILabel alloc] init];
        _date.font = [UIFont systemFontOfSize:14.f];
        _date.textColor = RGBCOLOR(135, 135, 135);
    }
    return _date;
}

- (UILabel *)orderName {
    if (!_orderName) {
        _orderName = [[UILabel alloc] init];
        _orderName.font = [UIFont systemFontOfSize:14.0f];
        _orderName.textColor = RGBCOLORV(0x878787);
        _orderName.textAlignment = NSTextAlignmentLeft;
        _orderName.text = @"游戏编号";
    }
    return _orderName;
}

- (UILabel *)orderId {
    if (!_orderId) {
        _orderId = [[UILabel alloc] init];
        _orderId.font = [UIFont systemFontOfSize:14.0f];
        _orderId.textColor = RGBCOLOR(68, 68, 68);
        _orderId.textAlignment = NSTextAlignmentRight;
    }
    return _orderId;
}

- (UILabel *)appeal {
    if (!_appeal) {
        _appeal = [[UILabel alloc] init];
        _appeal.font = [UIFont systemFontOfSize:14.0f];
        _appeal.textColor = RGBCOLORV(0x878787);;
        _appeal.numberOfLines = 1;
        _appeal.text = @"游戏中遇到问题请点击申诉";
    }
    return _appeal;
}

- (UIButton *)appealBtn {
    if (!_appealBtn) {
        _appealBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _appealBtn.backgroundColor = kAppLabelColor;
        _appealBtn.layer.cornerRadius = 13.5;
        _appealBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_appealBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_appealBtn setTitle:@"申诉" forState:UIControlStateNormal];
        [_appealBtn addTarget:self action:@selector(onPreviewButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _appealBtn;
}
@end
