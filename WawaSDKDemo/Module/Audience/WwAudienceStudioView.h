//
//  WwAudienceStudioView.h
//

#import <UIKit/UIKit.h>
#import "WwAudienceCell.h"

@protocol WwAudienceStudioViewDelegate <NSObject>

- (void)audienceDidSelect:(WwUserModel *)user;

- (void)updateAudienceCount:(NSInteger)count;

@end

@interface WwAudienceStudioView : UIView

@property (nonatomic, assign) NSInteger roomID;                             /**< 房间号*/

@property (nonatomic, weak) id<WwAudienceStudioViewDelegate> delegate;      /**< 代理*/

+ (instancetype)zyAudienceView;                                             /**< 生成一张观众视图*/

- (void)firstRequest;

@end



