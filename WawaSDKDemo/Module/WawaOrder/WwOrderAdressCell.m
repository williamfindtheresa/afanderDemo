//
//  WwOrderAdressCell.m
//  WawaSDKDemo
//

#import "WwOrderAdressCell.h"
#import <WawaSDK/WwDataDef.h>

@interface WwOrderAdressCell ()

@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *phone;
@property (weak, nonatomic) IBOutlet UILabel *detailAddress;
@property (weak, nonatomic) IBOutlet UIButton *selectBtn;
@property (weak, nonatomic) IBOutlet UIView *cardContainerView;

//添加地址view
@property (weak, nonatomic) IBOutlet UIView *cardAddAddressContainerVView;
@property (weak, nonatomic) IBOutlet UIImageView *stampImg;


@end


@implementation WwOrderAdressCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.cardContainerView.layer.cornerRadius = 3;
    self.cardContainerView.layer.masksToBounds = YES;
}

- (void)loadWithData:(WwAddressModel *)aData {
    if (aData == nil) {
        for (UIView *subView in self.cardContainerView.subviews) {
            subView.hidden = YES;
        }
        self.stampImg.hidden = NO;
        self.cardAddAddressContainerVView.hidden = NO;
        _isAddAddress = YES;
    }
    else {
        for (UIView *subView in self.cardContainerView.subviews) {
            subView.hidden = NO;
        }
        self.cardAddAddressContainerVView.hidden = YES;
        _isAddAddress = NO;
        
        // 去显示地址栏目
        self.name.text = aData.name;
        self.phone.text = aData.phone;
        
        NSString *detail = [NSString stringWithFormat:@"%@%@%@%@",aData.province,aData.city,aData.district,aData.address];
        
        self.detailAddress.text = detail;
    }
}


@end
