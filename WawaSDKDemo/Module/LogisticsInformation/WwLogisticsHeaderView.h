//
//  WwLogisticsHeaderView.h
//

#import <UIKit/UIKit.h>

@interface WwLogisticsHeaderView : UIView

/**< 请求数值之后的回调*/
- (void)loadData:(id)data;

/**< 使用订单数据填充*/
- (void)fillContentWithOrderModel:(WwWawaOrderModel *)model;

@end
