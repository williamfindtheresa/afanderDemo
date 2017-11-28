//
//  WwToyDepositCell.h
//  WawaSDKDemo
//
//

#import "WwToyDepositCell.h"
#import "WawaKitConstants.h"
#import "UIImageView+WawaKit.h"
#import "UILabel+WawaKit.h"

static NSString *Bottom_UnSelectButtonString = @"toy_deposit_unselect";
static NSString *Bottom_SelectButtonString = @"toy_deposit_select";

@interface WwToyDepositCell ()
{
    ToyCellSelectedBlock cellSelectedBlock;
    ToyCellTappedBlock cellTappedImageBlock;
    ToyCellTappedBlock cellTappedDateBlock;
}

@property (nonatomic, strong) UIView *bgView;
//选中按钮
@property (nonatomic, strong) UIButton *selectBtn;
//显示照片
@property (nonatomic, strong) UIImageView *image;
//商品名
@property (nonatomic, strong) UILabel *name;
//时间
@property (nonatomic, strong) UILabel *date;
//时间
@property (nonatomic, strong) UIImageView *dateImg;
//价格
@property (nonatomic, strong) UILabel *price;
//价格提示
@property (nonatomic, strong) UILabel *priceHint;
@property (nonatomic, assign) BOOL updatedConstraints;
@end

@implementation WwToyDepositCell
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
- (void)reloadDataWithModel:(WwWawaDepositModel*)model {
    self.model = model;
    [self.image ww_setToyImageWithUrl:model.pic];
    
    self.name.text = model.name;
    self.priceHint.text = [NSString stringWithFormat:@"可兑金币:"];
    NSMutableAttributedString *imgStr = [UILabel attributedString:[NSString stringWithFormat:@"%zi", model.coin] withImage:@"toy_exchange_coin" beforeString:YES atPoint:CGPointMake(2, -2)];
    [self.price setAttributedText:imgStr];
    self.date.text = [NSString stringWithFormat:@"%ld", model.expTime];
    
    self.selectBtn.selected = model.selected;
    _isSelected = model.selected;
}

- (void)cellSelectedWithBlock:(ToyCellSelectedBlock)block {
    cellSelectedBlock = block;
}

- (void)cellTapNameAndTitleWithBlock:(ToyCellTappedBlock)block {
    cellTappedImageBlock = block;
}

- (void)cellTapDateWithBlock:(ToyCellTappedBlock)block {
    cellTappedDateBlock = block;
}
#pragma mark - Getter
- (BOOL)isSelected {
    return _model.selected;
}

#pragma mark - 重写setter方法
- (void)setCellSelected:(BOOL)selected {
    self.selectBtn.selected = selected;
    
    // update model 
    _model.selected = selected;
}
#pragma mark - 按钮点击方法
- (void)selectBtnClick:(UIButton*)button {
    button.selected = !button.selected;
    // update model
    _model.selected = button.selected;
    
    if (cellSelectedBlock) {
        cellSelectedBlock(button.selected);
    }
}

- (void)onImageTapGesture:(UITapGestureRecognizer *)tapGesture {
    if (cellTappedImageBlock) {
        cellTappedImageBlock();
    }
}

- (void)onDateImageTapGesture:(UITapGestureRecognizer *)tapGesture {
    if (cellTappedDateBlock) {
        cellTappedDateBlock();
    }
}

#pragma mark - 布局主视图
- (void)addSubviews {
    [self.contentView addSubview:self.bgView];
    [self.bgView addSubview:self.selectBtn];
    [self.bgView addSubview:self.image];
    [self.bgView addSubview:self.name];
    [self.bgView addSubview:self.price];
    [self.bgView addSubview:self.priceHint];
    [self.bgView addSubview:self.dateImg];
    [self.bgView addSubview:self.date];
    
    // add tap gesture
    UITapGestureRecognizer *tapImageGesture =
    [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onImageTapGesture:)];
    [self.image addGestureRecognizer:tapImageGesture];
    
    UITapGestureRecognizer *tapTitleGesture =
    [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onImageTapGesture:)];
    [self.name addGestureRecognizer:tapTitleGesture];
    
    UITapGestureRecognizer *tapCountdownGesture =
    [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onDateImageTapGesture:)];
    [self.dateImg addGestureRecognizer:tapCountdownGesture];
    
    UITapGestureRecognizer *tapDateGesture =
    [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onDateImageTapGesture:)];
    [self.date addGestureRecognizer:tapDateGesture];
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
        make.height.equalTo(@103.f);
    }];
    [self.selectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.equalTo(self.bgView).with.offset(3.f);
        make.centerY.equalTo(self.bgView);
        make.height.equalTo(@50.f);
        make.width.equalTo(@50.f);
    }];
    [self.image mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.equalTo(self.bgView).with.offset(47.f);
        make.centerY.equalTo(self.bgView);
        make.height.equalTo(@75.f);
        make.width.equalTo(@75.f);
    }];
    [self.name mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.equalTo(self.bgView).with.offset(135.f);
        make.top.equalTo(self).with.offset(26.f);
        make.height.equalTo(@15.f);
        make.width.equalTo(@150.f);
    }];
    [self.priceHint mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.equalTo(self.bgView).with.offset(135.f);
        make.top.equalTo(self.bgView).with.offset(61.f);
        make.height.equalTo(@17.f);
        make.width.equalTo(@70.f);
    }];
    [self.price mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.equalTo(self.bgView).with.offset(135.f + 65.f);
        make.top.equalTo(self.bgView).with.offset(61.f);
        make.height.equalTo(@17.f);
        make.width.equalTo(@100.f);
    }];
    [self.dateImg mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.right.equalTo(self.bgView.mas_right).with.offset(-25.f);
        make.top.equalTo(self.bgView).with.offset(26.f);
        make.height.equalTo(@15.f);
        make.width.equalTo(@13.f);
    }];
    [self.date mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.equalTo(self.bgView.mas_right).with.offset(-22.f);
        make.top.equalTo(self.bgView).with.offset(26.f);
        make.height.equalTo(@15.f);
        make.width.equalTo(@20.f);
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

- (UIButton *)selectBtn {
    if (!_selectBtn) {
        //选中按钮
        _selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _selectBtn.bounds = CGRectMake(0, 0, 30, 30);
        [_selectBtn setImage:[UIImage imageNamed:Bottom_UnSelectButtonString] forState:UIControlStateNormal];
        [_selectBtn setImage:[UIImage imageNamed:Bottom_SelectButtonString] forState:UIControlStateSelected];
        [_selectBtn addTarget:self action:@selector(selectBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _selectBtn;
}

- (UIImageView *)image {
    if (!_image) {
        //显示照片
        _image = [[UIImageView alloc] init];
        _image.userInteractionEnabled = YES;
        _image.contentMode = UIViewContentModeScaleAspectFill;
        _image.clipsToBounds = YES;
        _image.layer.borderColor = RGBCOLOR(255, 218, 68).CGColor;
        _image.layer.borderWidth = 0.5;
        _image.layer.cornerRadius = 2;
    }
    return _image;
}

- (UIImageView *)dateImg {
    if (!_dateImg) {
        _dateImg = [[UIImageView alloc] init];
        _dateImg.image = [UIImage imageNamed:@"toy_deposit_countdown"];
        _dateImg.userInteractionEnabled = YES;
        _dateImg.contentMode = UIViewContentModeScaleAspectFill;
        _dateImg.clipsToBounds = YES;
    }
    return _dateImg;
}

- (UILabel *)name {
    if (!_name) {
        //商品名
        _name = [[UILabel alloc] init];
        _name.userInteractionEnabled = YES;
        _name.font = [UIFont systemFontOfSize:14.0f];
        _name.textColor = RGBCOLORV(0x444444);
    }
    return _name;
}

- (UILabel *)price {
    if (!_price) {
        _price = [[UILabel alloc] init];
        _price.font = [UIFont systemFontOfSize:14.0f];
        _price.textColor = RGBCOLORV(0x444444);
    }
    return _price;
}

- (UILabel *)priceHint {
    if (!_priceHint) {
        _priceHint = [[UILabel alloc] init];
        _priceHint.font = [UIFont systemFontOfSize:14.0f];
        _priceHint.textColor = RGBCOLORV(0x444444);
        _priceHint.textAlignment = NSTextAlignmentLeft;
    }
    return _priceHint;
}
- (UILabel *)date {
    if (!_date) {
        _date = [[UILabel alloc] init];
        _date.font = [UIFont systemFontOfSize:14.f];
        _date.userInteractionEnabled = YES;
        _date.textColor = RGBCOLOR(87, 87, 87);
    }
    return _date;
}

@end
