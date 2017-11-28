//
//  WwRoomWawaExchangeViewController.h
//  F_Sky
//


#import <UIKit/UIKit.h>

@interface WwRoomWawaExchangeViewController : UIViewController
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) NSInteger selectCount;
@property (nonatomic, assign) NSInteger selectValue;

- (void)reloadData;

@end
