//
//  WwLogisticsDataModel.h
//

#import <Foundation/Foundation.h>
@class WwLogisticsViewController, WwLogisticsModel;


@interface WwLogisticsDataModel : NSObject

@property (nonatomic, weak) WwLogisticsViewController *ownVc;

- (void)fetchData;

@property (nonatomic, strong) WwLogisticsModel *recorderModel;

@end



@interface WwLogisticsListInfo : NSObject

@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *time;

//mock
@property (nonatomic, assign) BOOL isFirst; //是不是第一个list数据 mock
@property (nonatomic, assign) BOOL isLast;

@end


@interface WwLogisticsWaWa : NSObject

@property (nonatomic, copy) NSString * pic;

@end


@interface WwLogisticsModel : NSObject


@property (nonatomic, copy) NSString *number;//单号
@property (nonatomic, copy) NSString *type; //快递类型
@property (nonatomic, copy) NSString *company; //快递公司名称
@property (nonatomic, assign) NSInteger deliverystatus ;//1.在途中 2. 派送中 3. 已签收 4. 派送失败或者拒收

@property (nonatomic, assign) NSInteger issign;

@property (nonatomic, strong) NSArray<WwLogisticsListInfo *> * list;

@property (nonatomic, strong) WwLogisticsWaWa *wawa;

@property (nonatomic, assign) NSInteger wawaNum; //娃娃数量

@property (nonatomic, copy) NSString  *tel; //官方电话号码

- (NSString *)deliverDescription;

@end
