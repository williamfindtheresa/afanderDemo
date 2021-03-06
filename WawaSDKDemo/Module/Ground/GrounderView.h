//
//  GrounderView.h
//


#import <UIKit/UIKit.h>
#import "GrounderModel.h"



#import "BREngine.h"

@class GatewayRoomChatGet;
@class GrounderView;


typedef NS_ENUM(NSInteger, GrounderType) {
    GrounderTypeDefault = 0,    /**< 默认*/
    GrounderTypeText,           /**< 纯文本*/
};

@interface GrounderView : UIView <BRElementInterface>

@property (nonatomic, strong) GatewayRoomChatGet *gatewayRoomChatGet;

@property (nonatomic, assign) NSTimeInterval durtion; /**< 动画时间长度*/


@property (nonatomic, assign) GrounderType type;/**< 类型*/

- (void)setContent:(GrounderModel*)model;       /**< 普通弹幕*/

- (void)userClickAction;


@end
