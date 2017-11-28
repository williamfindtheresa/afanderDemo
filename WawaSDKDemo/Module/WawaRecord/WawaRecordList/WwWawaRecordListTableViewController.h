//
//  WwWawaRecordListTableViewController.h
//  F_Sky
//


#import <UIKit/UIKit.h>

@interface WwWawaRecordListTableViewController : UITableViewController

- (void)wawaRecordListData:(id)dataModel;

- (void)dataChange:(id)dataModel;

//加载更多数据返回
- (void)dataFetchMoreChange:(id)dataModel;

@end
