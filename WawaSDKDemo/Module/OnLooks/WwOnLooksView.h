//
//  WwOnLooksView.h
//

#import <UIKit/UIKit.h>
#import "WwPingView.h"

@interface WwOnLooksView : UIView

@property (nonatomic, strong) UILabel * looksLab;                       /**< 围观人数*/

@property (nonatomic, strong) WwPingView * pingV;                       /**< 延迟检测视图*/

@property (nonatomic, assign) NSInteger onLooks;                        /**< 围观人数记录*/

+ (instancetype)onlooksView;

- (void)updateOnLooksNum:(NSInteger)num;                /**< 更新围观人数*/

@end
