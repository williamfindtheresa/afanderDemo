//
//  ZYWawaRecordListTableViewController.h
//  WawaSDKDemo
//
//

#import <UIKit/UIKit.h>

@interface ZYWawaRecordListTableViewController : UITableViewController

@property (nonatomic, assign) NSInteger roomID;                      /**< 房间ID*/

- (void)wawaRecordListData:(id)dataModel;

- (void)dataChange:(id)dataModel;

//加载更多数据返回
- (void)dataFetchMoreChange:(id)dataModel;

- (void)configPanGesture:(UIPanGestureRecognizer *)pan;
@end
