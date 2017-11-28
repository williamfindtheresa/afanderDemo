//
//  WwToyOrderConformViewController.h
//  prizeClaw
//


#import <UIKit/UIKit.h>

/**
 申请发货 订单确认页面 . 使用的是寄存中的数据
 
DVL_IninData   @[ WwWawaDepositModel ]
 */
@interface WwToyOrderConformViewController : UIViewController

@property (nonatomic, strong) NSMutableArray<WwWawaDepositModel *> * DVL_InitData;                      /**< 数据*/

@end
