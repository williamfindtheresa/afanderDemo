//
//  WwAudienceCell.m
//  WawaSDKDemo
//

#import "WwAudienceCell.h"
#import "UIImageView+WawaKit.h"

@interface WwAudienceCell()

@property (nonatomic, strong) UIImageView * imgV;

@end


@implementation WwAudienceCell

- (instancetype)initWithFrame:(CGRect)frame
{
    
    self = [super initWithFrame:frame];
    if (self) {
        [self configInit];
    }
    return self;
}

- (void)configInit
{
    self.backgroundColor = [UIColor clearColor];
    [self addSubview:self.imgV];
}

#pragma mark - SetterAndGetter
- (void)setUser:(WwUserModel *)user {
    if (_user.uid == user.uid) {
        return;
    }
    _user = user;
    [_imgV ww_setAvatar:user.portrait type:WwKitImageUrlRuleTypeSmall completed:nil];
}

- (UIImageView *)imgV {
    if (!_imgV) {
        _imgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kCellWidth, kCellWidth)];
        _imgV.layer.cornerRadius = kCellWidth / 2.0;
        _imgV.clipsToBounds = YES;
        _imgV.backgroundColor = [UIColor whiteColor];
        _imgV.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _imgV;
}

@end
