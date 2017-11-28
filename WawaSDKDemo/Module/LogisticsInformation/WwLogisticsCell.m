//
//  WwLogisticsCell.m
//  prizeClaw
//
//  Created by ganyanchao on 03/10/2017.
//  Copyright © 2017 QuanMin.ShouYin. All rights reserved.
//

#import "WwLogisticsCell.h"
#import "WwLogisticsDataModel.h"


@interface MYTestView : UITextView


@end



static CGFloat Log_Dis_Top = 20;
static CGFloat Log_Dis_Bottom = 20.0;

@interface WwLogisticsCell () <YYTextViewDelegate>

@property (strong, nonatomic)  UITextView *textDesView;
@property (strong, nonatomic)  UILabel *labelDate;

@property (strong, nonatomic) UIView *speView;  //横屏的 分割线

@property (nonatomic, strong) UIView *bigCycleView;   //大图
@property (nonatomic, strong) UIView *smallCycleView; //小图

@property (nonatomic, strong) UIView *topSpeLineView;
@property (nonatomic, strong) UIView *bottomSepLineView;

@end


@implementation WwLogisticsCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self textDesView];
    [self labelDate];
    
    [self bigCycleView];
    [self smallCycleView];
    [self topSpeLineView];
    [self bottomSepLineView];
}

#pragma mark - Public
- (void)loadWithData:(WwLogisticsListInfo *)aData
{
    if ([aData isKindOfClass:[WwLogisticsListInfo class]] == NO) {
        self.hidden = YES;
        return;
    }
    
    self.hidden = NO;
    NSString *text = aData.status;
    
    self.textDesView.text = text;
    self.labelDate.text = aData.time;
    
    UIColor *dateColor;
    UIColor *desColor;
    
    if (aData.isFirst) {
        self.smallCycleView.hidden = YES;
        self.bigCycleView.hidden = NO;
        self.topSpeLineView.hidden = YES;
        self.bottomSepLineView.hidden = NO;
        
        dateColor = DVLColorGen(@"#1ed771");
        desColor = DVLColorGen(@"#1ed771");
        
    }
    else {
        self.smallCycleView.hidden = NO;
        self.bigCycleView.hidden = YES;
        self.topSpeLineView.hidden = NO;
        self.bottomSepLineView.hidden = NO;
        
        dateColor = DVLColorGen(@"#878787");
        desColor = DVLColorGen(@"#878787");
    }
    
    
    self.labelDate.textColor = dateColor;
    self.textDesView.textColor = desColor;
    
    if (aData.isLast) {
        self.speView.hidden = YES;
    }
    else {
        self.speView.hidden = NO;
    }

}


#pragma mark - UITextViewDelegate

- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange
{
    if (IS_IPAD) {
        return NO;
    }
    
    NSLog(@"url :%@",URL);
    if ([[URL scheme] hasPrefix:@"tel"]) {
        return YES;
    }
    return NO;
}



#pragma mark - Getter Setter
- (UITextView *)textDesView
{
    if (!_textDesView) {
        _textDesView = [[MYTestView alloc] init];
        [self addSubview:_textDesView];
        [_textDesView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(63);
            make.top.equalTo (self).offset(Log_Dis_Top);
            make.right.equalTo(self).offset(-25);
        }];
        _textDesView.font = font(15);
        _textDesView.textContainerInset = UIEdgeInsetsZero;
        _textDesView.dataDetectorTypes = UIDataDetectorTypeAll;
        _textDesView.scrollEnabled = NO;
        _textDesView.editable = NO;
        _textDesView.delegate = self;
        _textDesView.layoutManager.allowsNonContiguousLayout = NO;
    }
    return _textDesView;
}

- (UILabel *)labelDate
{
    if (!_labelDate) {
        _labelDate = [[UILabel alloc] init];
        _labelDate.font = font(14);
        [self addSubview:_labelDate];
        [_labelDate mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.greaterThanOrEqualTo(self.textDesView.mas_bottom).offset(12);
            make.left.equalTo(self.textDesView);
            make.right.equalTo(self.textDesView).offset(1);
            make.bottom.equalTo(self).offset(-Log_Dis_Bottom);
            make.height.equalTo(@(20));
        }];
        
    }
    return _labelDate;
}

- (UIView *)speView
{
    if (!_speView) {
        _speView = [[UIView alloc] init];
        [self addSubview:_speView];
        _speView.backgroundColor = DVLColorGen(@"#eaeaea");
        [_speView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self);
            make.height.equalTo(@(1));
            make.left.equalTo(_labelDate);
            make.right.equalTo(self.labelDate);
        }];
    }
    return _speView;
}

- (UIView *)bigCycleView
{
    if (!_bigCycleView) {
        _bigCycleView = [[UIView  alloc] init];
        [self addSubview:_bigCycleView];
        _bigCycleView.backgroundColor = DVLColorGen(@"#2ce880");
        [_bigCycleView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(25);
            make.top.equalTo(self).offset(Log_Dis_Top);
            make.width.height.equalTo(@(12));
        }];
        
        _bigCycleView.layer.cornerRadius = 6;
        
    }
    return _bigCycleView;

}

- (UIView *)smallCycleView
{
    if (!_smallCycleView) {
        _smallCycleView = [[UIView alloc] init];
        _smallCycleView.backgroundColor = DVLColorGen(@"#eaeaea");
        [self addSubview:_smallCycleView];
        
        [_smallCycleView  mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(27);
            make.top.equalTo(self).offset(Log_Dis_Top + 2);
            make.width.height.equalTo(@(8));
        }];
        
        _smallCycleView.layer.cornerRadius = 4;
        
    }
    return _smallCycleView;
}

- (UIView *)topSpeLineView
{
    if (!_topSpeLineView) {
        _topSpeLineView = [[UIView alloc] init];
        _topSpeLineView.backgroundColor = DVLColorGen(@"#eaeaea");
        [self  insertSubview:_topSpeLineView belowSubview:self.bigCycleView];
        
        [_topSpeLineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@(1));
            make.centerX.equalTo(self.bigCycleView.mas_centerX);
            make.top.equalTo(self);
            make.bottom.equalTo(self.bigCycleView.mas_top);
            
        }];
    }
    return _topSpeLineView;
}

- (UIView *)bottomSepLineView
{
    if (!_bottomSepLineView) {
        
        _bottomSepLineView = [[UIView alloc] init];
        _bottomSepLineView.backgroundColor = DVLColorGen(@"#eaeaea");
        [self  insertSubview:_bottomSepLineView belowSubview:self.bigCycleView];
        
        [_bottomSepLineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@(1));
            make.centerX.equalTo(self.bigCycleView.mas_centerX);
            make.top.equalTo(self.bigCycleView.mas_top);
            make.bottom.equalTo(self);
        }];
    }
    return _bottomSepLineView;
}


@end


@implementation MYTestView

- (CGSize)intrinsicContentSize
{
    CGFloat w = ScreenWidth - 60;
    
    CGRect rect =  [self.text boundingRectWithSize:CGSizeMake(w, CGFLOAT_MAX) options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font(17)} context:nil] ;
    CGFloat hei = ceil(rect.size.height) + 5;
    
    self.contentSize = CGSizeMake(w, hei);
    
    NSLog(@"rect height -    %f , text %@",hei,self.text);
    
    return self.contentSize;
}

@end
