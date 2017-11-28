//
//  WwWawaParticularsHeaderView.m
//  F_Sky
//


#import "WwWawaParticularsHeaderView.h"
#import "WwWawaParticularsInfo.h"

@interface WwWawaParticularsHeaderView ()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *wawaSizeLabel;
@property (weak, nonatomic) IBOutlet UILabel *exchangeValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *wawaMaterialLabel;
@property (weak, nonatomic) IBOutlet UILabel *wawaFillerLabel;
@property (weak, nonatomic) IBOutlet UIImageView *leftImageView;

@property (weak, nonatomic) IBOutlet UILabel *exchangeTitleLab;
@property (weak, nonatomic) IBOutlet UIImageView *exchangeImgV;
@end

@implementation WwWawaParticularsHeaderView

+ (instancetype)shared {
    return [[[NSBundle mainBundle] loadNibNamed:@"WwWawaParticularsHeaderView" owner:nil options:nil] lastObject];
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)wawaParticularsHeaderViewWithData:(id)model {
    WwWawaParticularsInfo *info = (WwWawaParticularsInfo *)model;
    self.nameLabel.text = info.name;
    self.wawaSizeLabel.text = info.size;
    self.exchangeValueLabel.text = [NSString stringWithFormat:@"%zd", info.recoverCoin];
    self.wawaMaterialLabel.text = info.material;
    self.wawaFillerLabel.text = info.filler;
    self.leftImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"popupos_head_%zd", info.level]];
    
}

- (IBAction)sizeInfoButtonClick:(UIButton *)sender {
    NSLog(@"尺寸减少");
}
@end
