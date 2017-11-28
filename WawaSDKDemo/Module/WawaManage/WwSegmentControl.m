//
//  WwSegmentControl.m
//  WawaSDKDemo
//
//

#import <Foundation/Foundation.h>
#import "WwSegmentControl.h"
#import "UIColor+WawaKit.h"
#import "WawaKitConstants.h"

@interface WwSegmentControl ()<WwSegmentControlDelegate>

@property (nonatomic, assign) CGFloat widthFloat;

@property (nonatomic, strong) UIView *buttonDown;

// BackGround颜色,默认底色为白色
@property (strong, nonatomic) UIColor *backGroundColor;
// 标题文字颜色 ,默认黑色
@property (strong, nonatomic) UIColor *titleColor;
// 选中标题按钮的颜色,默认黑色
@property (strong, nonatomic) UIColor *selectColor;
// 默认字体  14
@property (strong, nonatomic) UIFont *titleFont;/**< 字体大小 */
// 底线
@property (nonatomic, strong) UIView *bottomLine;
@end

@implementation WwSegmentControl

+ (instancetype)segmentWithFrame:(CGRect)frame titleArray:(NSArray *)titleArray defaultSelect:(NSInteger)defaultSelect{
    WwSegmentControl *segment = [[WwSegmentControl alloc] initWithFrame:frame];
    
    [segment addSegmentArray:titleArray];
    [segment selectTheSegment:defaultSelect];
    
    return segment;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.selectSegment = 0;
        self.buttonArray = [NSMutableArray arrayWithCapacity:_buttonArray.count];
        self.titleFont = [UIFont systemFontOfSize:17.0];
        
        self.selectColor = [UIColor blackColor];
        self.titleColor = [UIColor grayColor];
        self.bottomLine = [[UIView alloc] init];
        self.bottomLine.backgroundColor = RGBCOLOR(204, 204, 204);
        self.bottomLine.hidden = YES;
        [self addSubview:_bottomLine];
        [self.bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self);
            make.height.equalTo(@0.5f);
            make.width.equalTo(self);
        }];

        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)addSegmentArray:(NSArray *)segmentArray {
    NSInteger segmentCount = segmentArray.count;
    self.widthFloat = (self.bounds.size.width)/segmentCount;
    
    for (int i=0; i<segmentArray.count; ++i) {
        UIButton* button = [[UIButton alloc] initWithFrame:CGRectMake(i * self.widthFloat, 0, self.widthFloat, self.bounds.size.height-2)];
        [button setTitle:segmentArray[i] forState:UIControlStateNormal];
        [button.titleLabel setFont:self.titleFont];
        [button setTitleColor:self.titleColor forState:UIControlStateNormal];
        [button setTitleColor:self.selectColor forState:UIControlStateSelected];
        [button setTag:i];
        [button addTarget:self action:@selector(onSegmentClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        if (i==0) {
            // 默认下划线高  2
            self.buttonDown = [[UIView alloc] initWithFrame:CGRectMake(i* self.widthFloat, self.bounds.size.height -2, self.widthFloat, 2)];
            
            [self.buttonDown setBackgroundColor:RGBCOLOR(255, 201, 91)];
            [self addSubview:self.buttonDown];
        }
        
        [self addSubview:button];
        [self.buttonArray addObject:button];
    }
    [[self.buttonArray firstObject] setSelected:YES];
}

- (void)onSegmentClicked:(UIButton*)button {
    [self selectTheSegment:button.tag];
}

- (void)selectTheSegment:(NSInteger)segment {
    if ( self.selectSegment != segment) {
        [self.buttonArray[self.selectSegment] setSelected:NO];
        [self.buttonArray[segment] setSelected:YES];
        UIButton *button = self.buttonArray[segment];
        [UIView animateWithDuration:0.1 animations:^{
            CGPoint center = self.buttonDown.center;
            center.x = button.center.x;
            self.buttonDown.center = center;
        }];
        self.selectSegment = segment;
        
        if ([self.delegate respondsToSelector:@selector(segmentSelectionChange:)]) {
            [self.delegate segmentSelectionChange: self.selectSegment];
        }
    }
}

- (void)lineColor:(UIColor *)color{
    self.buttonDown.backgroundColor = color;
}

- (void)setBottomLineVisible:(BOOL)visible {
    self.bottomLine.hidden = !visible;
}

- (void)setSelectSegment:(NSInteger)selectSegment {
    if (_selectSegment != selectSegment) {
        [self.buttonArray[_selectSegment] setSelected:NO];
        [self.buttonArray[selectSegment] setSelected:YES];
        _selectSegment = selectSegment;
        
        UIButton *button = self.buttonArray[selectSegment];
        [UIView animateWithDuration:0.1 animations:^{
            CGPoint center = self.buttonDown.center;
            center.x = button.center.x;
            self.buttonDown.center = center;
        }];
        if ([self.delegate respondsToSelector:@selector(segmentSelectionChange:)]) {
            [self.delegate segmentSelectionChange:_selectSegment];
        }
    }
}

#pragma mark setter
- (void)setTitleColor:(UIColor *)titleColor
     selectTitleColor:(UIColor *)selectTitleColor
      BackGroundColor:(UIColor *)BackGroundColor
        titleFontSize:(CGFloat)size {
    if (BackGroundColor) self.backgroundColor = BackGroundColor;
    
    for (UIView *view in self.subviews) {
        if ([[view class] isSubclassOfClass:[UIButton class]]) {
            UIButton *button =(UIButton *) view;
            if (titleColor) {
                [button setTitleColor:titleColor forState:UIControlStateNormal];
            }
            
            if (selectTitleColor) {
                [button setTitleColor:selectTitleColor forState:UIControlStateHighlighted];
            }
            
            if (size) {
                [button.titleLabel setFont:[UIFont systemFontOfSize:size]];
            }
        }
    }
}

- (void)refreshSegmentTitleWithArray:(NSArray *)array {
    if (array.count != _buttonArray.count) {
        return;
    }
    
    for (int i=0; i<_buttonArray.count; ++i) {
        UIButton *btn = _buttonArray[i];
        [btn setTitle:array[i] forState:UIControlStateNormal];
    }
}

- (void)refreshSegmentTitle:(NSString *)title atIndex:(NSInteger)index {
    if (index <0 || index >= _buttonArray.count) {
        return;
    }
    UIButton *btn = _buttonArray[index];
    [btn setTitle:title forState:UIControlStateNormal];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    UIButton *firstBtn = self.buttonArray.firstObject;
    [self.buttonDown mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(firstBtn);
        make.width.equalTo(@55.f);
        make.bottom.equalTo(self);
        make.height.equalTo(@2.f);
    }];
}

@end
