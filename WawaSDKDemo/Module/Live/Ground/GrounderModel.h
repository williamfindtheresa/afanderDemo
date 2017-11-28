//
//  GrounderModel.h
//  WawaSDKDemo
//
//

#import <Foundation/Foundation.h>
#import "BRRendDataInterface.h"
#import <WawaSDK/WawaSDK.h>

@interface GrounderModel : NSObject <BRRendDataInterface>

@property (nonatomic, strong) WwChatModel *chatModel;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *message;
@property (nonatomic, copy) NSString *iconStr;
@property (nonatomic, copy) NSString *chatColor;                      /**< 弹幕颜色*/
@property (nonatomic, assign) NSInteger gender;

#pragma mark - custom local
@property (nonatomic, assign) BOOL showTxtOnly; /**< 只显示文本*/

#pragma mark - BRRendDataInterface


@end
