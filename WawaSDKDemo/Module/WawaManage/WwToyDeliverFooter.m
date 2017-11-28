//
//  WwToyDeliverFooter.m
//  F_Sky
//
//

#import <Foundation/Foundation.h>
#import "WwToyDeliverFooter.h"
#import "WawaKitConstants.h"
#import "UILabel+WawaKit.h"

@implementation WwToyDeliverFooter

+ (instancetype)createWithStyle:(ToyDeliverFooterStyle)style {
    WwToyDeliverFooter *header = [[WwToyDeliverFooter alloc] initWithStyle:style];
    header.style = style;
    return header;
}

- (instancetype)initWithStyle:(ToyDeliverFooterStyle)style {
    self = [super initWithFrame:CGRectMake(0, 0, ScreenWidth, HeightOfToyDeliverFooter)];
    if (self) {
        self.style = style;
        [self initUI];
    }
    return self;
}

- (void)reloadWithData:(WwWawaOrderModel *)model {
    if (_style == DeliverFooter_Exchanged) {
        NSInteger total = 0;
        for (int i=0; i<model.records.count; ++i) {
            WwWawaOrderItem *item = model.records[i];
            if (item) {
                total += item.coin*item.num;
            }
        }
        
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:@"共计: "];
        NSMutableAttributedString *imgStr = [UILabel attributedString:[NSString stringWithFormat:@"%zi", total] withImage:@"toy_exchange_coin" beforeString:YES atPoint:CGPointMake(2, -2)];
        [str appendAttributedString:imgStr];
        [_total setAttributedText:str];
    }
}

- (void)initUI {
    self.backgroundColor = RGBCOLOR(255.0f, 255.0f, 255.0f);
    
    UIView *lineView = [[UIView alloc]init];
    lineView.frame = CGRectMake(0, 0, ScreenWidth, 0.5f);
    lineView.backgroundColor = RGBCOLOR(204.f, 204.f, 204.f);
    
    [self addSubview:lineView];
    
    NSString *leftText, *rightText;
    switch (_style) {
        case DeliverFooter_Preparing:
//            rightText = @"兑换金币";
            rightText = @"确认收货";
            break;
        case DeliverFooter_Delivering:
            leftText = @"查看物流";
            rightText = @"确认收货";
            break;
        case DeliverFooter_Received:
            leftText = @"查看物流";
            break;
        case DeliverFooter_Exchanged:;
            break;
        default:
            break;
    }
    
    @weakify(self);
    if (_style == DeliverFooter_Preparing) {
        [self addSubview:self.rightBtn];
        [_rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.right.equalTo(self).with.offset(-14.f);
            make.top.equalTo(self).with.offset(11.f);
            make.height.equalTo(@32.f);
            make.width.equalTo(@94.f);
        }];
        [self.rightBtn setTitle:rightText forState:UIControlStateNormal];
    }
    else if (_style == DeliverFooter_Delivering) {
        [self addSubview:self.leftBtn];
        [self addSubview:self.rightBtn];
        [_rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.right.equalTo(self).with.offset(-14.f);
            make.top.equalTo(self).with.offset(11.f);
            make.height.equalTo(@32.f);
            make.width.equalTo(@94.f);
        }];
        
        [_leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.right.equalTo(self.rightBtn.mas_left).with.offset(-18.f);
            make.top.equalTo(self).with.offset(11.f);
            make.height.equalTo(@32.f);
            make.width.equalTo(@94.f);
        }];
        [self.leftBtn setTitle:leftText forState:UIControlStateNormal];
        [self.rightBtn setTitle:rightText forState:UIControlStateNormal];
    }
    else if (_style == DeliverFooter_Received) {
        [self addSubview:self.leftBtn];
        [_leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.right.equalTo(self).with.offset(-14.f);
            make.top.equalTo(self).with.offset(11.f);
            make.height.equalTo(@32.f);
            make.width.equalTo(@94.f);
        }];
        [self.leftBtn setTitle:leftText forState:UIControlStateNormal];
    }
    else if (_style == DeliverFooter_Exchanged) {
        [self addSubview:self.total];
        [_total mas_makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.right.equalTo(self.mas_right);
            make.top.equalTo(self).with.offset(20.f);
            make.height.equalTo(@17.f);
            make.width.equalTo(@93.f);
        }];
    }
}

- (void)onButtonClicked:(UIButton *)sender {
    DeliverFooterAction action = DeliverFooterAction_None;
    if (sender == _leftBtn) {
        action = DeliverFooterAction_LeftAction;
    }
    else if (sender == _rightBtn) {
        action = DeliverFooterAction_RightAction;
    }
    if ([self.delegate respondsToSelector:@selector(onDeliverFooterAction:withSection:)]) {
        [self.delegate onDeliverFooterAction:action withSection:self.section];
    }
}


- (UIButton *)leftBtn {
    if (!_leftBtn) {
        _leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _leftBtn.backgroundColor = RGBCOLOR(255, 255, 255);
        _leftBtn.layer.cornerRadius = 15.5;
        _leftBtn.layer.borderWidth = 0.5;
        _leftBtn.layer.borderColor = [[UIColor colorWithRed:68.0f/255.0f green:68.0f/255.0f blue:68.0f/255.0f alpha:1.0f] CGColor];
        [_leftBtn addTarget:self action:@selector(onButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        _leftBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_leftBtn setTitleColor:RGBCOLOR(68, 68, 68) forState:UIControlStateNormal];
        [_leftBtn.titleLabel setTextColor:RGBCOLOR(68, 68, 68)];
    }
    return _leftBtn;
}

- (UIButton *)rightBtn {
    if (!_rightBtn) {
        _rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _rightBtn.layer.cornerRadius = 15.5;
        _rightBtn.layer.backgroundColor = [[UIColor colorWithRed:255.0f/255.0f green:218.0f/255.0f blue:68.0f/255.0f alpha:1.0f] CGColor];
        [_rightBtn setTitleColor:RGBCOLOR(68, 68, 68) forState:UIControlStateNormal];
        _rightBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_rightBtn.titleLabel setTextColor:RGBCOLOR(68, 68, 68)];
        [_rightBtn addTarget:self action:@selector(onButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightBtn;
}

- (UILabel *)total {
    if (!_total) {
        _total = [[UILabel alloc] init];
        _total.font = [UIFont systemFontOfSize:14.0f];
        _total.textColor = RGBCOLOR(68, 68, 68);
        _total.textAlignment = NSTextAlignmentLeft;
    }
    return _total;
}

@end
