//
//  WwToyDepositViewController.h
//  F_Sky
//

#import <UIKit/UIKit.h>


@interface WwToyDepositViewController : UIViewController

@property (nonatomic, assign) NSInteger selectCount;
@property (nonatomic, assign, readonly) NSInteger totalCount;

- (void)refreshList;
- (void)setAllSelect:(BOOL)select;

- (NSArray <WwWawaDepositModel *> *)selectToyList;

@end
