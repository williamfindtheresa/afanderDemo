//
//  WwLogisticsDataModel.m
//  prizeClaw
//
//  Created by ganyanchao on 03/10/2017.
//  Copyright © 2017 QuanMin.ShouYin. All rights reserved.
//

#import "WwLogisticsDataModel.h"
#import "WwLogisticsViewController.h"

@implementation WwLogisticsDataModel

- (void)fetchData
{
    WwWawaOrderModel *orderModel = self.ownVc.Ww_InitData;
    NSString *orderId = orderModel.orderId;
    if (realString(orderId).length) {
        NSLog(@"物流 - 没有订单id");
        return;
    }
    [[WawaSDK WawaSDKInstance].userInfoMgr requestExpressInfo:realString(orderId) withCompleteHandler:^(int code, NSString *message, AVTLogisticsModel *model) {
        
        if (code != WwErrorCodeSuccess) {
            NSLog(@"%@",message);
            return ; //记录查询错误
        }
        NSDictionary *kv = [model mj_keyValues];
        self.recorderModel = [WwLogisticsModel mj_objectWithKeyValues:kv];
        [self.ownVc dataChange:self];
    }];
}

@end


@implementation WwLogisticsWaWa


@end


@implementation WwLogisticsModel

+ (NSDictionary *)mj_objectClassInArray
{
    return @{@"list":[WwLogisticsListInfo class]};
}


////1.在途中 2. 派送中 3. 已签收 4. 派送失败或者拒收
- (NSString *)deliverDescription
{
    if (_deliverystatus == 1) {
        return @"在途中";
    }
    else if (_deliverystatus == 2) {
        return @"派送中";
    }
    
    else if (_deliverystatus == 3) {
        return @"已签收";
    }
    
    else if (_deliverystatus == 4) {
        return @"派送失败";
    }
    return nil;
}

@end

@implementation WwLogisticsListInfo

@end
