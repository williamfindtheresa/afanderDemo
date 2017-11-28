//
//  WwAddressTableViewCell.h
//  F_Sky
//

#import <UIKit/UIKit.h>
#import <WawaSDK/WwDataDef.h>

static NSString *const kWwAddressTableViewCellIdentifier = @"WwAddressTableViewCell";

@protocol CellButtonDelegate <NSObject>

- (void)defaultBtnDidClicked:(WwAddressModel *)model;

- (void)editBtnDidClicked:(WwAddressModel *)model;

- (void)deleteBtnDidClicked:(WwAddressModel *)model;

@end

@interface WwAddressTableViewCell : UITableViewCell

@property (nonatomic, weak) id<CellButtonDelegate>delegate;

@property (nonatomic, strong) WwAddressModel * model; /**< 数据模型*/
//申请发货控制是否显示【默认地址】
@property (nonatomic, assign) BOOL isDefault;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

@property (weak, nonatomic) IBOutlet UIView *operationBaseV;
@property (weak, nonatomic) IBOutlet UIButton *defaultBtn;
@property (weak, nonatomic) IBOutlet UIButton *editBtn;
@property (weak, nonatomic) IBOutlet UIButton *delegateBtn;

@end
