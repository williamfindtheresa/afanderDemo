//
//  WwGameRecordCell.h
//  WawaSDKDemo
//


#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, GameRecordCellStyle) {
    GameRecord_NoIndicator,
    GameRecord_Indicator
};

static CGFloat HeightOfGameRecordCell = 103.f;
static CGFloat HeightOfGameRecordCellWithIndicator = 111.f;

static NSString *kWwGameRecordCell = @"WwGameRecordCell";

@class WwGameRecordModel;


@interface WwGameRecordCell : UITableViewCell

@property (nonatomic, assign) BOOL separatorVisible;
@property (nonatomic, assign) BOOL indicatorVisible;
- (void)reloadDataWithModel:(WwGameRecordModel*)model;

@end
