//
//  WwToyDetailViewController.h
//  WawaSDKDemo
//


#import <UIKit/UIKit.h>
#import <WawaSDK/WawaSDK.h>

@interface WwToyDetailViewController : UITableViewController

@property (nonatomic, strong) WwWawaItem * wawa;                      /**< 娃娃信息*/

- (void)wawaParticularsData:(id)dataModel;

@end
