//
//  WwToyManagePanel.m
//  WawaSDKDemo
//
//

#import <Foundation/Foundation.h>
#import "WwToyManagePanel.h"
#import "WawaKitConstants.h"
#import "UILabel+WawaKit.h"

@interface WwToyManagePanel ()
@property (nonatomic, assign) BOOL layoutUI;

@end

@implementation WwToyManagePanel

+ (instancetype)createPanelWithFrame:(CGRect)frame andStyle:(ToyManagePanelStyle)style {
    WwToyManagePanel *panel = [[WwToyManagePanel alloc] initWithFrame:frame];
    if (panel) {
        panel.style = style;
        [panel layoutPanelUI];
    }
    return panel;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initUI];
    }
    return self;
}

- (void)initUI {
    self.backgroundColor = RGBCOLOR(255.0f, 255.0f, 255.0f);
    
    UIView *lineView = [[UIView alloc]init];
    lineView.frame = CGRectMake(0, 0, ScreenWidth, 0.5f);
    lineView.backgroundColor = RGBCOLOR(204.f, 204.f, 204.f);
    
    [self addSubview:lineView];
    [self addSubview:self.selectAll];
    [self addSubview:self.createOrderBtn];
    [self addSubview:self.exchangeBtn];
}

- (void)layoutPanelUI {
    if (_layoutUI) {
        return;
    }
    _layoutUI = YES;
    @weakify(self);
    [self.selectAll mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.equalTo(self).with.offset(0.f);
        make.top.equalTo(self).with.offset(0.f);
        make.height.equalTo(@53.f);
        make.width.equalTo(@120.f);
    }];
    [self.selectLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.equalTo(self.selectAll).with.offset(47.f);
        make.top.equalTo(self.selectAll);
        make.bottom.equalTo(self.selectAll);
        make.width.equalTo(@80.f);
    }];
    
    if (_style == ToyManagePanel_ToyChecking) {
        self.exchangeBtn.hidden = YES;
//        [self.exchangeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//            @strongify(self);
//            make.right.equalTo(self).with.offset(-14.f);
//            make.top.equalTo(self).with.offset(11.f);
//            make.height.equalTo(@32.f);
//            make.width.equalTo(@94.f);
//        }];
        
        [self.createOrderBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.right.equalTo(self).with.offset(-18.f);
            make.top.equalTo(self).with.offset(11.f);
            make.height.equalTo(@32.f);
            make.width.equalTo(@94.f);
        }];
    }
    else if (_style == ToyManagePanel_Exchange) {
        [self.exchangeBtn addSubview:self.exchangeLabel];
        [self.exchangeBtn setTitle:@"" forState:UIControlStateNormal];
        [self.exchangeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.right.equalTo(self).with.offset(-14.f);
            make.top.equalTo(self).with.offset(11.f);
            make.height.equalTo(@32.f);
            make.width.equalTo(@120.f);
        }];
        
        [self.exchangeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.left.equalTo(self.exchangeBtn).with.offset(10.f);
            make.top.equalTo(self.exchangeBtn);
            make.height.equalTo(@32.f);
            make.width.equalTo(@100);
        }];
        self.createOrderBtn.hidden = YES;
    }
}

#pragma mark - Public Methods
- (void)setStyle:(ToyManagePanelStyle)style {
    _style = style;
    _halfSelect = (style == ToyManagePanel_Exchange);
}

- (void)setAllSelect:(BOOL)allSelect {
    if (allSelect) {
        [self.selectLabel setText:@"全选"];
    }
    else {
        [self.selectLabel setText:@"已选"];
    }
}

- (void)setCurrentSelectNumber:(NSInteger)number withTotal:(NSInteger)total {
    _currentSelectNumber = number;
    
    NSString *str = [NSString stringWithFormat:@"已选(%ld)", _currentSelectNumber];
    if (_currentSelectNumber == 0) {
        str = [NSString stringWithFormat:@"已选"];
    }
    // Note:手动设置选择数目时，只处理全选->非全选变化的情况，非全->全选的情况，不对button状态做改变
    if (number != total) {
        self.selectAll.selected = NO;
        [self.selectLabel setText:str];
    }
    else {
        self.selectAll.selected = YES;
        [self.selectLabel setText:@"全选"];
    }
}

- (void)setSelectTotalValue:(NSInteger)value {
    if (value == 0) {
        _exchangeLabel.text = @"兑换金币";
    }
    else {
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:@"兑换:"];
        [str addAttribute:NSForegroundColorAttributeName value:RGBCOLORV(0xdb9715) range:NSMakeRange(0, str.length)];
        NSMutableAttributedString *valueStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%zi", value]];
        [valueStr addAttribute:NSForegroundColorAttributeName value:RGBCOLORV(0x444444) range:NSMakeRange(0, valueStr.length)];
        NSMutableAttributedString *imgStr = [UILabel attributedString:@"" withImage:@"toy_exchange_coin" beforeString:YES atPoint:CGPointMake(2, -2)];
        [str appendAttributedString:imgStr];
        [str appendAttributedString:valueStr];
        _exchangeLabel.attributedText = str;
    }
}


#pragma mark - Private Methods
- (void)onPanelButtonClicked:(UIButton *)sender {
    ToyManagePanelAction action = ToyManagePanelAction_None;
    
    if (sender == _selectAll) {
        if (_halfSelect) {
            // 只生效一次，半选->（点击）->取消全选
            _halfSelect = NO;
            _selectAll.selected = NO;
        }
        else {
            _selectAll.selected = !_selectAll.isSelected;
        }
        action = _selectAll.isSelected ? ToyManagePanelAction_SelectAll : ToyManagePanelAction_UnselectAll;
    }
    else if (sender == _createOrderBtn) {
        action = ToyManagePanelAction_LeftAction;
    }
    else if (sender == _exchangeBtn) {
        action = ToyManagePanelAction_RightAction;
    }
    
    if ([self.delegate respondsToSelector:@selector(onToyManagePanelAction:)]) {
        [self.delegate onToyManagePanelAction:action];
    }
}

#pragma mark - Getter 

- (UIButton *)selectAll {
    if (!_selectAll) {
        //全选按钮
        _selectAll = [UIButton buttonWithType:UIButtonTypeCustom];
        _selectAll.titleLabel.font = [UIFont systemFontOfSize:15];
        [_selectAll setImageEdgeInsets:UIEdgeInsetsMake(0, -62, 0, 0)];
//        [_selectAll setTitleEdgeInsets:UIEdgeInsetsMake(20, 19, 20, 0)];
        [_selectAll.titleLabel setTextAlignment:NSTextAlignmentLeft];
        [_selectAll setImage:[UIImage imageNamed:@"toy_deposit_unselect"] forState:UIControlStateNormal];
        [_selectAll setImage:[UIImage imageNamed:@"toy_deposit_select"] forState:UIControlStateSelected];
        [_selectAll addTarget:self action:@selector(onPanelButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_selectAll setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_selectAll addSubview:self.selectLabel];
    }
    return _selectAll;
}

- (UILabel *)selectLabel {
    if (!_selectLabel) {
        _selectLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _selectLabel.font = [UIFont systemFontOfSize:15];
        _selectLabel.text = @"已选";
        [_selectLabel setTextAlignment:NSTextAlignmentLeft];
        [_selectLabel setTextColor:RGBCOLORV(0x444444)];
    }
    return _selectLabel;
}

- (UIButton *)createOrderBtn {
    if (!_createOrderBtn) {
        _createOrderBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _createOrderBtn.backgroundColor = RGBCOLORV(0xffffff);
        _createOrderBtn.layer.cornerRadius = 15.5;
        _createOrderBtn.layer.borderWidth = 0.5;
        _createOrderBtn.layer.borderColor = RGBCOLORV(0x444444).CGColor;
        _createOrderBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [_createOrderBtn setTitleColor:RGBCOLORV(0x444444) forState:UIControlStateNormal];
        [_createOrderBtn setTitle:@"申请发货" forState:UIControlStateNormal];
        [_createOrderBtn addTarget:self action:@selector(onPanelButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _createOrderBtn;
}

- (UIButton *)exchangeBtn {
    if (!_exchangeBtn) {
        _exchangeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _exchangeBtn.layer.cornerRadius = 15.5;
        _exchangeBtn.layer.backgroundColor = RGBCOLORV(0xffda44).CGColor;
        
        _exchangeBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [_exchangeBtn setTitleColor:RGBCOLORV(0x444444) forState:UIControlStateNormal];
        [_exchangeBtn setTitle:@"兑换金币" forState:UIControlStateNormal];
        [_exchangeBtn addTarget:self action:@selector(onPanelButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _exchangeBtn;
}

- (UILabel *)exchangeLabel {
    if (!_exchangeLabel) {
        _exchangeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _exchangeLabel.font = [UIFont systemFontOfSize:15];
        _exchangeLabel.text = @"兑换金币";
        [_exchangeLabel setTextAlignment:NSTextAlignmentCenter];
        [_exchangeLabel setTextColor:RGBCOLORV(0x444444)];
    }
    return _exchangeLabel;
}
@end
