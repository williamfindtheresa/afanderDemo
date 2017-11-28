//
//  WwToyDeliverFooter.h
//  WawaSDKDemo
//
//


#import <UIKit/UIKit.h>
#import <WawaSDK/WawaSDK.h>

static NSString * kWwToyDeliverFooter = @"WwToyDeliverFooter";

typedef NS_ENUM(NSInteger, ToyDeliverFooterStyle) {
    DeliverFooter_Preparing = 0,
    DeliverFooter_Delivering,
    DeliverFooter_Received,
    DeliverFooter_Exchanged,
};

typedef NS_ENUM(NSInteger, DeliverFooterAction) {
    DeliverFooterAction_None = -1,    // 未知
    DeliverFooterAction_LeftAction,    // 左键
    DeliverFooterAction_RightAction,    // 右键
};

@protocol ToyDeliverFooterDelegate <NSObject>

- (void)onDeliverFooterAction:(DeliverFooterAction)action withSection:(NSInteger)section;

@end

static NSInteger HeightOfToyDeliverFooter = 53;

@interface WwToyDeliverFooter : UIView

@property (nonatomic, assign) ToyDeliverFooterStyle style;
@property (nonatomic, strong) UIButton * leftBtn;
@property (nonatomic, strong) UIButton * rightBtn;
@property (nonatomic, strong) UILabel * total;
@property (nonatomic, assign) NSInteger section;

@property (nonatomic, weak) id<ToyDeliverFooterDelegate> delegate;

+ (instancetype)createWithStyle:(ToyDeliverFooterStyle)style;
- (void)reloadWithData:(WwWawaOrderModel *)model;
@end

