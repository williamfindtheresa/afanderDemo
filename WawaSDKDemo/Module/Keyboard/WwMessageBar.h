//
//  WwMessageBar.h
//

#import <UIKit/UIKit.h>

#define TextFieldLength 50

@class WwMessageBar;

@protocol WwMessageBarDelegate <NSObject>

- (void)messageBar:(WwMessageBar *)bar sendMessage:(NSString *)message;

@end


@interface WwMessageBar : UIView

@property (nonatomic, weak) UIView *mayFitView; //一般父view，需要自动调整的 赋值。不需要的不用, unimplement

@property (nonatomic, weak) id<WwMessageBarDelegate> delegate;

@property (nonatomic, assign, readonly) BOOL isActive; //textfield 是否活跃中。 键盘是否弹起来了

@property (nonatomic, readonly, strong) WwUserModel * beChatedUser; /**< 被@ 的人*/

/**< 请不要直接调用以下API。 @WwLiveInteractiveView 调用有自定义逻辑*/
- (void)showKeyboard;
- (void)showKeyboardChatUser:(WwUserModel *)chatUser; //@Ta 聊天区跟人说活
- (void)closeKeyboard;

- (void)clearChatText;

- (void)hotwordClick:(NSString *)hotword; //热词点击

@end
