//
//  WwLiveViewController.h
//  prizeClaw
//

#import <UIKit/UIKit.h>


@class WwLiveInteractiveView;

@interface WwLiveViewController : UIViewController

@property (nonatomic, strong) WwLiveInteractiveView * interV;                       /**< 直播间内交互视图*/

@property (nonatomic, strong) WwRoomModel * room;                                   /**< 数据*/

@end
