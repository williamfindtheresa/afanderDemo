//
//  WwGroundManager.h
//  F_Sky
//
//

#import <Foundation/Foundation.h>

@class WwLiveInteractiveView;

@class GrounderModel;

@interface WwGroundManager : NSObject

@property (nonatomic, strong, readonly) UIView *barrageSuperView;

@property (nonatomic, weak) WwLiveInteractiveView *interView;

//自己发送
- (void)sendBarrageText:(NSString *)barrageText;  /**< 发送聊天或者弹幕*/
//收到
- (void)reciveBarrage:(GrounderModel *)grounderModel; /**< 发送票屏弹幕*/

@end
