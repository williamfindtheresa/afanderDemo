//
//  WwToyDetailHeaderView.m
//  WawaSDKDemo
//

#import "WwToyDetailHeaderView.h"

@interface WwToyDetailHeaderView ()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *wawaSizeLabel;
@property (weak, nonatomic) IBOutlet UILabel *exchangeValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *wawaMaterialLabel;
@property (weak, nonatomic) IBOutlet UILabel *wawaFillerLabel;
@property (weak, nonatomic) IBOutlet UIImageView *leftImageView;
@property (weak, nonatomic) IBOutlet UILabel *exchangeTitleLab;
@property (weak, nonatomic) IBOutlet UIImageView *exchangeImgV;
@end

@implementation WwToyDetailHeaderView

+ (instancetype)shared {
    return [[[NSBundle mainBundle] loadNibNamed:@"WwToyDetailHeaderView" owner:nil options:nil] lastObject];
}

- (void)reloadHeaderWithDetailInfo:(WwWaWaDetailInfo *)model {
    self.nameLabel.text = model.name;
    self.wawaSizeLabel.text = model.size;
    self.exchangeValueLabel.text = [NSString stringWithFormat:@"%zd", model.recoverCoin];
    self.wawaMaterialLabel.text = model.material;
    self.wawaFillerLabel.text = model.filler;
    self.leftImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"popupos_head_%zd", model.level]];
}

- (IBAction)sizeInfoButtonClick:(UIButton *)sender {

}
@end
