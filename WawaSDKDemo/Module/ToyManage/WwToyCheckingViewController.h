//
//  WwToyCheckingViewController.h
//  prizeClaw
//


#import <UIKit/UIKit.h>
#import <WawaSDK/WawaSDK.h>

@interface WwToyCheckingViewController : UITableViewController

@property (nonatomic, assign) NSInteger selectCount;
@property (nonatomic, assign, readonly) NSInteger totalCount;

- (void)refreshList;
- (void)setAllSelect:(BOOL)select;

- (NSArray <WwWawaDepositModel *> *)selectToyList;

@end
