//
//  WwToyDeliverViewController.h
//  F_Sky
//

#import "WwBaseViewController.h"


@interface WwToyDeliverViewController : WwBaseViewController

@property (nonatomic, strong) UITableView * tableView;                      /**< 列表*/

- (void)refreshList;

@end
