//
//  WwLogisticsView.h
//

#import <UIKit/UIKit.h>


/**
 物流详情  浮层
 */
@interface WwLogisticsView : UIView

+ (void)showWithOrderModel:(WwWawaOrderModel *)orderModel;

+ (void)dismiss;

@end
