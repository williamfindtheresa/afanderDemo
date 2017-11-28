//
//  WwLogisticsView.h
//  prizeClaw
//
//  Created by ganyanchao on 03/10/2017.
//  Copyright © 2017 QuanMin.ShouYin. All rights reserved.
//

#import <UIKit/UIKit.h>


/**
 物流详情  浮层
 */
@interface WwLogisticsView : UIView

+ (void)showWithOrderModel:(WwWawaOrderModel *)orderModel;

+ (void)dismiss;

@end
