//
//  WwWatchOperationView.h
//

#import <UIKit/UIKit.h>

@protocol WwWatchOperationViewDelegate <NSObject>

- (void)onChatClicked:(UIButton *)button;
- (BOOL)onStartClicked:(UIButton *)button;
- (void)onShareClicked:(UIButton *)button;
- (void)onExchangeClicked:(UIButton *)button;
- (void)onBalanceClicked:(UIButton *)button;
- (void)onRechargeClicked:(UIButton *)button;//充值点击

@end

@interface WwWatchOperationView : UIView

+ (instancetype)watchOperationView;

@property (nonatomic, strong) WwWawaItem * wawa;                      /**< 娃娃信息*/
@property (nonatomic, assign) BOOL operationDisable;
@property (weak, nonatomic) IBOutlet UIButton *exchangeBtn;
@property (weak, nonatomic) IBOutlet UIButton *balanceBtn;
@property (weak, nonatomic) IBOutlet UIButton *chatButton;
@property (weak, nonatomic) IBOutlet UIButton *startBtn;
@property (weak, nonatomic) IBOutlet UIButton *showTipBtn;  /**< 用于提示没见过开始游戏按钮可点击状态的nc用户 有别的用户正在游戏中了...默认隐藏,显隐完全受socket控制*/
@property (weak, nonatomic) IBOutlet UIButton *shareBtn;

@property (weak, nonatomic) IBOutlet UILabel *wawaPriceLabel;
@property (weak, nonatomic) IBOutlet UIButton *rechargeBtn; //充值按钮

@property (weak, nonatomic) id<WwWatchOperationViewDelegate> delegate;

@property (nonatomic, assign) NSInteger roomState;                      /**< 房间状态*/


@end
