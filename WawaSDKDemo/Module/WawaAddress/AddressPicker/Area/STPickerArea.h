//
//  STPickerArea.h
//  STPickerView
//
//  Created by https://github.com/STShenZhaoliang/STPickerView on 16/2/15.
//  Copyright © 2016年 shentian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "STPickerView.h"
#import "WwLocalPcasCodeManager.h"


NS_ASSUME_NONNULL_BEGIN
@class STPickerArea;
@protocol  STPickerAreaDelegate<NSObject>

- (void)pickerArea:(STPickerArea *)pickerArea province:(WwAddressProvinceItem *)province city:(WwAddressCityItem *)city area:(WwAddressAreaItem *)area;

- (void)pickerDidClickCancel;

@end
@interface STPickerArea : STPickerView

+ (instancetype)inputPickerView;
- (void)showRightNow;   /**< 调用立刻显示逻辑*/
- (void)findIndexWithProvince:(NSString *)province city:(NSString *)city area:(NSString *)area;


/** 1.中间选择框的高度，default is 32*/
@property (nonatomic, assign)CGFloat heightPickerComponent;

@property(nonatomic, weak)id <STPickerAreaDelegate>delegate ;
@end
NS_ASSUME_NONNULL_END
