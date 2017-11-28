//
//  WwWawaRecordInfoNavBar.m
//  F_Sky
//


#import "WwWawaRecordInfoNavBar.h"

@interface WwWawaRecordInfoNavBar ()
@property (nonatomic,strong) UIButton *currentBtn;
@property (nonatomic, strong) UIView *lineView;
@end

@implementation WwWawaRecordInfoNavBar


- (void)wawaRecordInfoNavBarTitles:(NSArray *)titles {
    NSInteger count = titles.count;
    for (NSInteger i = 0; i < count; i++) {
        UIButton *btn = [[UIButton alloc] init];
        [btn setTitle:titles[i] forState:UIControlStateNormal];
        [btn.titleLabel setFont:[UIFont systemFontOfSize:16.0]];
        btn.tag = i;
        if (count > 1) {
            [btn addTarget:self action:@selector(titleButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        }
        
        if (i == 0) {
            [btn setTitleColor:RGBCOLORV(0x5a342b) forState:UIControlStateNormal];
            self.currentBtn = btn;
        }
        else {
            [btn setTitleColor:RGBCOLORVA(0x5a342b, 0.6) forState:UIControlStateNormal];
        }
        
        [self addSubview:btn];
    }
    //下划线
    if (count > 1) {
        self.lineView = [[UIView alloc] init];
        self.lineView.backgroundColor = kAppLabelColor;
        self.lineView.layer.cornerRadius = 1.0;
        [self addSubview:self.lineView];
    }
    
    //布局
    CGFloat btnH = self.height;
    CGFloat btnW = 100;
    CGFloat btnY = 10;
    CGFloat spec = (self.width - count * btnW) / (count + 1);
    for (NSInteger i = 0; i < count; i++) {
        CGFloat btnX = spec + i * (btnW + spec);
        UIButton *btn = self.subviews[i];
        btn.frame = CGRectMake(btnX, btnY, btnW, btnH);
    }
    
    if (count > 1) {
        self.lineView.width = 83;
        self.lineView.height = 2.0;
        self.lineView.top = 44;
        self.lineView.centerX = self.currentBtn.centerX;
    }
}

- (void)titleButtonClick:(UIButton *)btn {
    if (self.currentBtn.tag == btn.tag) {
        return;
    }
    [self.currentBtn setTitleColor:RGBCOLORVA(0x5a342b, 0.6) forState:UIControlStateNormal];
    self.currentBtn = btn;
    self.lineView.centerX = self.currentBtn.centerX;
    [self.currentBtn setTitleColor:RGBCOLORV(0x5a342b) forState:UIControlStateNormal];
    if ([self.delegate respondsToSelector:@selector(wawaRecordInfoNavBarDelegate:selectButton:)]) {
        [self.delegate wawaRecordInfoNavBarDelegate:self selectButton:btn];
    }
}

- (void)wawaRecordInfoNavBarSelectIndex:(NSInteger)index {
    if (self.currentBtn.tag == index) {
        return;
    }
    [self.currentBtn setTitleColor:RGBCOLORVA(0x5a342b, 0.6) forState:UIControlStateNormal];
    self.currentBtn = self.subviews[index];
    self.lineView.centerX = self.currentBtn.centerX;
    [self.currentBtn setTitleColor:RGBCOLORV(0x5a342b) forState:UIControlStateNormal];
}
@end
