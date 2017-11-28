//
//  WwRecordPreviewCell.h
//  F_Sky
//

#import <UIKit/UIKit.h>


static CGFloat HeightOfRecordPreviewCell = 412.f;
static CGFloat HeightOfRecordDetailCell = 200.f;
static NSString *kWwRecordPreviewCell = @"WwRecordPreviewCell";
static NSString *kWwRecordDetailCell = @"WwRecordDetailCell";

typedef NS_ENUM(NSInteger, RecordPreviewAction) {
    RecordPreview_None = -1,
    RecordPreview_Play, // Play
    RecordPreview_Share, // Share
    RecordPreview_Appeal, // Appeal
};

@protocol WwRecordPreviewDelegate <NSObject>

- (void)onRecordPreviewClickAction:(RecordPreviewAction)action;

@end

@interface WwRecordPreviewCell : UITableViewCell
- (void)reloadDataWithModel:(WwGameRecordModel*)model;
@property (nonatomic, weak) id<WwRecordPreviewDelegate> delegate;
@end

@interface WwRecordDetailCell : UITableViewCell
- (void)reloadDataWithModel:(WwGameRecordModel*)model;
@property (nonatomic, weak) id<WwRecordPreviewDelegate> delegate;
@end
