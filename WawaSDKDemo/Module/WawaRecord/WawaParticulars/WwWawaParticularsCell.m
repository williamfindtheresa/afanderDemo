//
//  WwWawaParticularsCell.m
//  F_Sky
//


#import "WwWawaParticularsCell.h"

@interface WwWawaParticularsCell ()
@property (weak, nonatomic) IBOutlet UIImageView *contentImageView;

@end

@implementation WwWawaParticularsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.contentImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *ges = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTapAction:)];
    [self.contentImageView addGestureRecognizer:ges];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}
- (void)imageTapAction:(UITapGestureRecognizer *)sender {
    if (self.tapClick) {
        self.tapClick();
    }
}

- (void)wawaParticularsCellImageName:(NSString *)imgName {
    [self.contentImageView sd_setImageWithURL:[NSURL URLWithString:imgName]];
}

@end
