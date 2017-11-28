
#import <UIKit/UIKit.h>

static CGFloat ToyCheckingCellRowHeight = 111.f;
static NSString *kWwToyCheckingCell = @"WwToyCheckingCell";


typedef void (^ToyCellSelectedBlock)(BOOL select);
typedef void (^ToyCellTappedBlock)(void);

@interface WwToyCheckingCell : UITableViewCell

@property (nonatomic, assign) BOOL isSelected; //是否选中
@property (nonatomic, strong) WwWawaDepositModel *model;

- (void)setCellSelected:(BOOL)selected;
- (void)reloadDataWithModel:(WwWawaDepositModel *)model;
- (void)cellSelectedWithBlock:(ToyCellSelectedBlock)block;
- (void)cellTapNameAndTitleWithBlock:(ToyCellTappedBlock)block;
- (void)cellTapDateWithBlock:(ToyCellTappedBlock)block;

@end
