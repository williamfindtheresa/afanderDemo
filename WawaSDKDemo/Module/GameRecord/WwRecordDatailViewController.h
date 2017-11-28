//
//  WwRecordDatailViewController.h
//  WawaSDKDemo
//

#import <UIKit/UIKit.h>

@class WwGameRecordModel;

@interface WwRecordDatailViewController : UIViewController

/**
 * 创建一个游戏记录详情页面
 * @param record 游戏记录对象
 */
- (instancetype)initWithGameRecordModel:(WwGameRecordModel *)record;

@end
