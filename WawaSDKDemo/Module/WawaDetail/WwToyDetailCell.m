//
//  WwToyDetailCell.m
//  WawaSDKDemo
//

#import "WwToyDetailCell.h"
#import "UIImageView+WawaKit.h"

@interface WwToyDetailCell ()
@property (weak, nonatomic) IBOutlet UIImageView *contentImageView;

@end

@implementation WwToyDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)reloadCellWithImage:(NSString *)imgName {
    [self.contentImageView sd_setImageWithURL:imgName];
}

@end
