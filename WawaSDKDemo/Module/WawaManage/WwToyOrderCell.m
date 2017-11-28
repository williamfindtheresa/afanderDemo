//
//  WwToyOrderCell.m
//  F_Sky
//
//

#import "WwToyOrderCell.h"
#import "WawaKitConstants.h"
#import "UIImageView+WawaKit.h"
#import "UILabel+WawaKit.h"

static NSString *Bottom_UnSelectButtonString = @"toy_deposit_unselect";
static NSString *Bottom_SelectButtonString = @"toy_checking_select";

@interface WwToyOrderCell ()
{
    ToyOrderCellSelectedBlock cellSelectedBlock;
}

@property (nonatomic, strong) UIView *bgView;
//显示照片
@property (nonatomic, strong) UIImageView *image;
//选中按钮
@property (nonatomic, strong) UIButton *selectBtn;
//商品名
@property (nonatomic, strong) UILabel *name;
//数量
@property (nonatomic, strong) UILabel *count;
//价格
@property (nonatomic, strong) UILabel *price;
//价格提示
@property (nonatomic, strong) UILabel *priceHint;
//分割线
@property (nonatomic, strong) UIView *line;
@property (nonatomic, assign) BOOL updatedConstraints;
@end

@implementation WwToyOrderCell
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
- (void)reloadDataWithModel:(WwWawaOrderItem*)item {
    self.model = item;
    [self.image ww_setToyImageWithUrl:item.pic];
    
    self.name.text = item.name;
    self.priceHint.text = [NSString stringWithFormat:@"可兑金币:"];
    NSString *imgName = @"toy_exchange_coin";
    NSMutableAttributedString *imgStr = [UILabel attributedString:[NSString stringWithFormat:@"%zi", item.coin] withImage:imgName beforeString:YES atPoint:CGPointMake(2, -2)];
    [self.price setAttributedText:imgStr];
    self.count.text = [NSString stringWithFormat:@"x%ld", item.num];
    if (self.style == ToyOrderCell_CanSelect) {
        _isSelected = item.selected;
        self.selectBtn.selected = item.selected;
    }
}

- (void)orderCellSelectedWithBlock:(ToyOrderCellSelectedBlock)block {
    cellSelectedBlock = block;
}

#pragma mark - 重写setter方法
- (void)setSeparatorVisible:(BOOL)separatorVisible {
    BOOL isVisible = !_line.isHidden;
    if (isVisible != separatorVisible) {
        _line.hidden = !separatorVisible;
    }
}

- (void)addSubviews {
    [self.contentView addSubview:self.bgView];
    [self.bgView addSubview:self.selectBtn];
    [self.bgView addSubview:self.line];
    [self.bgView addSubview:self.image];
    [self.bgView addSubview:self.name];
    [self.bgView addSubview:self.price];
    [self.bgView addSubview:self.priceHint];
    [self.bgView addSubview:self.count];
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
    
    CGFloat imgLeftPadding = 16.f;
    CGFloat nameLeftPadding = 104.f;
    if (_style == ToyOrderCell_NoSelect) {
        imgLeftPadding = 16.f;
        nameLeftPadding = 104.f;
        self.selectBtn.hidden = YES;
    }
    else {
        imgLeftPadding = 47.f;
        nameLeftPadding = 135.f;
        [self.selectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.left.equalTo(self.bgView).with.offset(3.f);
            make.centerY.equalTo(self.bgView);
            make.height.equalTo(@50.f);
            make.width.equalTo(@50.f);
        }];
    }
    
    [self.image mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.equalTo(self.bgView).with.offset(imgLeftPadding);
        make.centerY.equalTo(self.bgView);
        make.height.equalTo(@75.f);
        make.width.equalTo(@75.f);
    }];
    [self.name mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.equalTo(self.bgView).with.offset(nameLeftPadding);
        make.top.equalTo(self).with.offset(26.f);
        make.height.equalTo(@15.f);
        make.width.equalTo(@150.f);
    }];
    
    [self.priceHint mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.equalTo(self.bgView).with.offset(nameLeftPadding);
        make.top.equalTo(self.bgView).with.offset(61.f);
        make.height.equalTo(@17.f);
        make.width.equalTo(@70.f);
    }];
    [self.price mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.equalTo(self.bgView).with.offset(nameLeftPadding + 65.f);
        make.top.equalTo(self.bgView).with.offset(61.f);
        make.height.equalTo(@17.f);
        make.width.equalTo(@100.f);
    }];
    [self.count mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.equalTo(self.bgView.mas_right).with.offset(-40.f);
        make.top.equalTo(self.bgView).with.offset(26.f);
        make.height.equalTo(@15.f);
        make.width.equalTo(@40.f);
    }];
}

#pragma mark - 按钮点击方法
- (void)selectBtnClick:(UIButton*)button {
    button.selected = !button.selected;
    
    if (cellSelectedBlock) {
        cellSelectedBlock(button.selected);
    }
    
    _model.selected = button.selected;
}
#pragma mark - Setter
- (void)setCellSelected:(BOOL)selected {
    _isSelected = selected;
    self.selectBtn.selected = selected;
    
    // update model
    _model.selected = selected;
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

- (UIView *)line {
    if (!_line) {
        _line = [[UIView alloc] init];
        _line.backgroundColor = RGBCOLOR(204.f, 204.f, 204.f);
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
    }
    return _name;
}

- (UILabel *)price {
    if (!_price) {
        _price = [[UILabel alloc] init];
        _price.font = [UIFont systemFontOfSize:14.0f];
    }
    return _price;
}
- (UILabel *)priceHint {
    if (!_priceHint) {
        _priceHint = [[UILabel alloc] init];
        _priceHint.font = [UIFont systemFontOfSize:14.0f];
        _priceHint.textColor = RGBCOLORV(0x444444);
    }
    return _priceHint;
}

- (UILabel *)count {
    if (!_count) {
        _count = [[UILabel alloc] init];
        _count.font = [UIFont systemFontOfSize:14.0f];
        _count.textColor = RGBCOLOR(102, 117, 140);
    }
    return _count;
}

@end
