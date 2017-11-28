//
//  ZYGroundManager.h
//  WawaSDKDemo
//
//

#import <Foundation/Foundation.h>
#import <WawaSDK/WawaSDK.h>
#import "GrounderModel.h"

@interface ZYGroundManager : NSObject

@property (nonatomic, strong, readonly) UIView *barrageSuperView;

@property (nonatomic, assign) NSInteger roomID;                      /**< 房间号*/

//自己发送
- (void)sendBarrageText:(NSString *)barrageText chatUser:(WwUserModel *)chatUser;  /**< 发送聊天或者弹幕*/
//收到
- (void)reciveBarrage:(GrounderModel *)grounderModel; /**< 发送票屏弹幕*/

@end
