//
//  IconImgView.h
//

#import <UIKit/UIKit.h>

@class IconImgView;
@protocol IconImgViewDelegate <NSObject>

- (void)didClicked:(IconImgView *)iconView;

@end

@interface IconImgView : UIView


@property (nonatomic, strong) UIColor *borderColor;
@property (nonatomic, strong) UIImageView *leftImg;

@property (nonatomic, copy) void(^ImgClickBlock)(void);

@property (nonatomic, weak) id<IconImgViewDelegate> delegate;

+(instancetype)IconImgViewWithFrame:(CGRect )frame BigIconUrlStr:(NSString*)bigIconUrlStr;

- (void)setImgStr:(NSString *)imgStr;

@end
