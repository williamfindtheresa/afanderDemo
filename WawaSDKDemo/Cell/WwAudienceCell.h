//
//  WwAudienceCell.h
//  WawaSDKDemo
//

#import <UIKit/UIKit.h>
#import <WawaSDK/WawaSDK.h>

#define kCellWidth 40

@interface WwAudienceCell : UICollectionViewCell

@property (nonatomic, strong) WwUserModel * user;                      /**< 用户数据*/

@end
