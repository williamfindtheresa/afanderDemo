//
//  WwWawaParticularsCell.h
//  prizeClaw
//


#import <UIKit/UIKit.h>

typedef void(^ImageTapBlock)();

@interface WwWawaParticularsCell : UITableViewCell
@property (nonatomic, copy) ImageTapBlock tapClick;                    /**< 点击图片*/
- (void)wawaParticularsCellImageName:(NSString *)imgName;
@end
