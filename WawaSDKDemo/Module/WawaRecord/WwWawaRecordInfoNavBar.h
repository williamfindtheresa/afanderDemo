//
//  WwWawaRecordInfoNavBar.h
//  prizeClaw
//

#import <UIKit/UIKit.h>

@class WwWawaRecordInfoNavBar;

@protocol WwWawaRecordInfoNavBarDelegate <NSObject>
- (void)wawaRecordInfoNavBarDelegate:(WwWawaRecordInfoNavBar *)navBar selectButton:(UIButton *)btn;

@end

@interface WwWawaRecordInfoNavBar : UIView

@property (weak, nonatomic) id<WwWawaRecordInfoNavBarDelegate> delegate;
- (void)wawaRecordInfoNavBarTitles:(NSArray *)titles;
- (void)wawaRecordInfoNavBarSelectIndex:(NSInteger)index;
@end
