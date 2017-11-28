//
//  WwToyDeliverHeader.h
//  WawaSDKDemo
//
//

#import <UIKit/UIKit.h>


static NSString * kWwToyDeliverHeader = @"WwToyDeliverHeader";
static NSInteger HeightOfToyDeliverHeader = 32;

typedef NS_ENUM(NSInteger, ToyDeliverHeaderStyle) {
    DeliverHeader_None = -1, // 未知
    DeliverHeader_Prepareing, // 准备中
    DeliverHeader_Delivering, // 运送中
    DeliverHeader_Receiverd, // 已收货
    DeliverHeader_Exchanged, // 已兑换
};

@interface WwToyDeliverHeader : UIView

@property (nonatomic, strong) UIImageView *icon;
@property (nonatomic, strong) UILabel *state;
@property (nonatomic, strong) UILabel *time;
@property (nonatomic, assign) ToyDeliverHeaderStyle style;
+ (instancetype)createWithStyle:(ToyDeliverHeaderStyle)style;

- (void)reloadWithData:(WwWawaOrderModel *)model;
@end
