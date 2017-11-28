//
//  WwAddressTableViewCell.h
//  WawaSDKDemo
//

#import "WwAddressTableViewCell.h"

@implementation WwAddressTableViewCell

- (void)setModel:(WwAddressModel *)model {
 
    _model = model;
    // 联系人
    self.nameLabel.text = model.name;
    // 电话
    self.phoneLabel.text = model.phone;
    //默认
    NSString *defaultStr = model.isDefault ? @"[默认地址] " : @"";
    NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc] init];
    NSMutableAttributedString *addressAttribute = [defaultStr labelStyleWithColor:[UIColor redColor] font:[UIFont systemFontOfSize:14.0]];
    if (self.isDefault) {
        [AttributedStr appendAttributedString:addressAttribute];
    }
    // 详细地址
    NSMutableString * mStr = [NSMutableString stringWithFormat:@"%@",model.province];
    if (![model.province hasSuffix:@"市"] && ![model.province hasSuffix:@"省"]) {
        [mStr appendString:@"省"];
    }
    [mStr appendFormat:@"%@%@%@",model.city,model.district,model.address];
    
    NSAttributedString *mStrAttribute = [mStr labelStyleWithColor:RGBCOLORV(0x444444) font:[UIFont systemFontOfSize:14.0]];
    [AttributedStr appendAttributedString:mStrAttribute];
    self.addressLabel.attributedText = AttributedStr;
    
    // 是否默认
    self.defaultBtn.selected = model.isDefault;
}

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
}


- (IBAction)MRaddress:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(defaultBtnDidClicked:)]) {
        sender.tag = self.tag;
        BOOL toType = !sender.selected;
        if (toType == NO) {
            return;
        }
        sender.selected = toType;
        [self.delegate defaultBtnDidClicked:self.model];
    };
}

- (IBAction)EditBtn:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(editBtnDidClicked:)]) {
        sender.tag = self.tag;
        [self.delegate editBtnDidClicked:self.model];
    };
}

- (IBAction)Delete:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(deleteBtnDidClicked:)]) {
        sender.tag = self.tag;
        [self.delegate deleteBtnDidClicked:self.model];
    };
}

@end
