//
//  WwOrderAdressCell.h
//  WawaSDKDemo
//

#import <UIKit/UIKit.h>


static CGFloat  kNoAdrressRowHeight = 126.0;
static NSString *kWwOrderAdressCellIdentifier = @"WwOrderAdressCell";

@class WwAddressModel;
@interface WwOrderAdressCell : UITableViewCell

- (void)loadWithData:(WwAddressModel *)aData;

@property (nonatomic, assign, readonly) BOOL isAddAddress; //是否是添加地址页面
@property (nonatomic, copy) void (^selectAddress)(WwAddressModel *model);

@end
