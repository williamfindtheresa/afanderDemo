//
//  ZYHotWordsCell.m
//  WawaSDKDemo
//
//

#import "ZYHotWordsCell.h"

@interface ZYHotWordsCell ()

@property (nonatomic, strong) UILabel * wordBtn;

@end


@implementation ZYHotWordsCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self customUI];
    }
    return self;
}

#pragma mark - Layout
- (void)customUI
{
    [self wordBtn];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _wordBtn.frame = self.bounds;
}

#pragma mark - Public
- (void)loadWithData:(NSString *)aData
{
    self.wordBtn.text = aData;
}

#pragma mark - Getter Setter
- (UILabel *)wordBtn
{
    if (!_wordBtn) {
        _wordBtn = [[UILabel alloc] initWithFrame:self.bounds];
        _wordBtn.textAlignment = NSTextAlignmentCenter;
        _wordBtn.textColor = DVLColorGen(@"#444444");
        _wordBtn.font = font(17);
        
        _wordBtn.layer.borderColor = DVLColorGen(@"#c1c1c1").CGColor;
        _wordBtn.layer.borderWidth = 1;
        _wordBtn.layer.cornerRadius = 3;
        
        [self addSubview:_wordBtn];
    }
    return _wordBtn;
}

@end
