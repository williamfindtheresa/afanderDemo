//
//  WwToyOrderConformViewController.h
//  F_Sky
//


#import <UIKit/UIKit.h>

/**
 申请发货 订单确认页面 . 使用的是寄存中的数据
 
Ww_IninData   @[ WwWawaDepositModel ]
 */
@interface WwToyOrderConformViewController : UIViewController

@property (nonatomic, strong) NSMutableArray<WwWawaDepositModel *> * Ww_InitData;                      /**< 数据*/

@end
