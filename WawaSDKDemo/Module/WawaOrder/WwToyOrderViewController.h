//
//  WwToyOrderViewController.h
//  prizeClaw
//

#import <UIKit/UIKit.h>

@class WwWawaDepositModel;

/**
 * 申请发货 订单确认页面
 */
@interface WwToyOrderViewController : UIViewController

@property (nonatomic, copy) NSArray <WwWawaDepositModel*> *wawaList;

@end
