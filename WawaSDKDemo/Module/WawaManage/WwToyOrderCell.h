//
//  WwToyOrderCell.h
//  F_Sky
//
//

#import <UIKit/UIKit.h>


static CGFloat ToyOrderCellRowHeight = 103.f;
static NSString *kWwToyOrderCell = @"WwToyOrderCell";

typedef NS_ENUM(NSInteger, ToyOrderCellStyle) {
    ToyOrderCell_NoSelect = 0,
    ToyOrderCell_CanSelect,
};

typedef void(^ToyOrderCellSelectedBlock)(BOOL select);

@interface WwToyOrderCell : UITableViewCell

@property (nonatomic, assign) ToyOrderCellStyle style;
@property (nonatomic, assign) BOOL separatorVisible;
@property (nonatomic, strong) WwWawaOrderItem *model;
@property (nonatomic, assign) BOOL isSelected;

- (void)reloadDataWithModel:(WwWawaOrderItem *)item;
- (void)orderCellSelectedWithBlock:(ToyOrderCellSelectedBlock)block;

@end
