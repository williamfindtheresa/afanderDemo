//
//  WwToyDetailHeaderView.h
//  WawaSDKDemo
//

#import <UIKit/UIKit.h>
#import <WawaSDK/WwDataDef.h>

static NSInteger HeightOfDetailHeader = 130;

@interface WwToyDetailHeaderView : UIView

+ (instancetype)shared;

- (void)reloadHeaderWithDetailInfo:(WwWaWaDetailInfo *)model;

@end
