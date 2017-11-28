//
//  WwGameResultView.h
//  prizeClaw
//
//  Created by 刘昊 on 2017/10/8.
//  Copyright © 2017年 QuanMin.ShouYin. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol WwGameResultViewDelegate <NSObject>

@optional
- (void)hadCompleteResultRequest; // 结果请求完成了

- (void)callReleaseLogic;  // 通知外界释放服务器资源

- (void)playAgain; // 再来一次

- (void)gameResultShareResult:(WwGameResultModel *)result; // 分享

- (void)endGameAndStopPush; // 结束推流

@end

@interface WwGameResultView : UIView

@property (nonatomic, assign) NSInteger roomID;                     /**< 房间ID*/

@property (nonatomic, strong) NSString * orderId;                   /**< 游戏订单号*/

@property (nonatomic, weak) id<WwGameResultViewDelegate> delegate;  /**< 代理*/

@property (nonatomic, assign) BOOL isResultHandleing;               /**< 是否正在处理游戏结果*/

+ (instancetype)gameResultView;

- (void)show;

- (void)dismissWithCompletion:(void(^)())block;

- (void)startRequestResult; /**< 开始拉取游戏结果*/

- (void)handleGameResult:(WwGameResultModel *)model; /**< 处理结果*/

@end
