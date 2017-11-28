//
//  WwLogisticsViewController.h
//

#import <UIKit/UIKit.h>
#import "WwBaseViewController.h"

/**
 物流信息
 */
@interface WwLogisticsViewController : WwBaseViewController

//setWw_initDat 初始化传递参数  orderModel , 订单model

@property (nonatomic, strong) WwWawaOrderModel * Ww_InitData;

- (void)dataChange:(id)model;

@end
