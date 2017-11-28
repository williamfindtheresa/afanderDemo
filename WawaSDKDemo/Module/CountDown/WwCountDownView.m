//
//  QuickSendGiftView.m
//

#import "WwCountDownView.h"
#import "WwShareAudioPlayer.h"
#import "NSTimer+EOCBlocksSupport.h"


/*
 目前是正方形 区域内部渐变
 */
#define DEGREES_TO_RADOANS(x) (M_PI * (x) / 180.0) // 将角度转为弧度


//全屏的
#define TopColorArr  @[ (id)DMRGBColor(54, 127, 255).CGColor,(id)DMRGBColor(54, 215, 255).CGColor]

#define BottomColorArr @[ (id)DMRGBColor(248, 151, 0).CGColor,(id)DMRGBColor(252, 233, 81).CGColor]

//顶部的环形渐变view
@interface RingShapedProgressView : UIView

/**< 0.0 - 1.0 */
- (void)updateProgress:(CGFloat)progress;

- (void)updateFillColorToRed; //最后10s变色

@end



@interface WwCountDownView ()
{
    NSTimeInterval _startTemp; /**< 开始tem*/
    NSTimeInterval _countNum; /**< 倒计时 tem * 10*/
}

@property (nonatomic, strong) RingShapedProgressView *progressView; /**< 顶部进度条*/

@property (nonatomic, strong) UILabel *countLabel; /**< 当前时间*/
@property (nonatomic, strong) NSTimer *countTimer;//30s  /**< 发送礼物 显示时长 倒计时*/

@property (nonatomic, strong) CALayer *innerShader; /**< 内部阴影*/

@end


@implementation WwCountDownView

- (void)dealloc
{
    NSLog(@"%s",__func__);
    [self stopTimer];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self configUI];
    }
    return self;
}

- (void)configUI
{
    _totalTimer = 30.0f;
    self.backgroundColor = [UIColor clearColor];
    [self.layer addSublayer:self.innerShader]; //底部阴影
    [self addSubview:self.progressView];
    [self addSubview:self.countLabel];
}

#pragma mark - Public
- (void)updateProgressTimer:(NSTimeInterval)countDown
{
    self.status = WwCountDownStatusCountDown;
    
    countDown = MIN(countDown, _totalTimer);
    countDown = MAX(0, countDown);
    
    CGFloat progress = countDown / _totalTimer;
    progress = MIN(1.0, progress);
    progress = MAX(0.0, progress);
    
    [self updateProgress:progress];
    [self updateNumCount:countDown];
    
    _startTemp = countDown;
    [self startTimer]; /**< 开启计时*/
}


- (void)setStatus:(WwCountDownStatus)status
{
    safe_async_main(^{
        _status = status;
        if (status == WwCountDownStatusCountDown) {
            self.hidden = NO;
            self.progressView.hidden = NO;
            self.countLabel.hidden = NO;
        }
        else if (status == WwCountDownStatusCountFinish){
            [self stopTimer];
            self.countLabel.text = @"等待\n结果";
            self.hidden = NO;
            self.countLabel.hidden = NO;
            self.progressView.hidden = YES;
        }
        else if (status == WwCountDownStatusRequestResultIng) {
            [self stopTimer];
            self.countLabel.text = @"等待\n结果";
            self.hidden = NO;
            self.progressView.hidden = YES;
            self.countLabel.hidden = NO;
        }
        else if (status == WwCountDownStatusRequestComplete) {
            [self stopTimer];
            self.hidden = YES;
        }
    
    });
}

#pragma mark - Layout
- (void)layoutSubviews
{
    [super layoutSubviews];
    self.countLabel.frame = self.bounds;
}

#pragma mark - Private

- (void)updateNumCount:(NSInteger)giftCount
{
    NSString *count = [NSString stringWithFormat:@"%zi",giftCount];
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:count];
    NSShadow * shar = [[NSShadow alloc] init];
    shar.shadowBlurRadius = 1.0;
    shar.shadowColor = [UIColor blackColor];
    shar.shadowOffset = (CGSize){0.5,0.5};
    NSDictionary * dic = @{
                           NSShadowAttributeName:shar,
                           };
    [attr addAttributes:dic range:NSMakeRange(0,count.length)];
    [attr addAttribute:NSFontAttributeName value:font(18) range:NSMakeRange(0, count.length)];
    self.countLabel.attributedText = attr;
}

- (void)updateProgress:(CGFloat)progress
{
    progress = MIN(1.0, progress);
    progress = MAX(0.0, progress);
    
    [self.progressView updateProgress:progress];
}

- (void)startTimer
{
    [self stopTimer];
    _countNum = _startTemp * 10;
    __weak typeof(self) wSelf = self;
    self.countTimer = [NSTimer eoc_scheduledTimerWithTimeInterval:0.1 block:^{
        [self countDown];
    } repeats:YES];
}

- (void)stopTimer
{
    [[WwShareAudioPlayer shareAudioPlayer] stopResultPlayer];
    [self.countTimer invalidate];
}


#pragma mark - Helper
- (void)countDown
{
    _countNum -= 1;
    if (_countNum == 0) {
        [self stopTimer];
        self.status = WwCountDownStatusCountFinish;
        if ([self.delegate respondsToSelector:@selector(zyTimerFinish)]) {
            [self.delegate zyTimerFinish];
        }
    }
    else {
        CGFloat progress = _countNum /(_totalTimer*10);
        [self updateProgress:progress];
        NSTimeInterval animateCount = _countNum/10.0;
        NSInteger tmpCount = ceil(animateCount);

        [self updateNumCount:tmpCount];
        
        if (tmpCount == 10) {
            //变色
            [self.progressView updateFillColorToRed];
        }
        else if ([self checkCombo:animateCount])  {
            //心跳动画
            [self animateNumber];
        }
        
    }
}

- (BOOL)checkCombo:(CGFloat)count
{
    if (
        count == 1 ||
        count == 2 ||
        count == 3 ||
        count == 4 ||
        count == 5
        ) {
        return YES;
    }
    return NO;
}

- (void)animateNumber
{
    [self.countLabel.layer removeAllAnimations];
    self.countLabel.transform = CGAffineTransformMakeScale(2.5, 2.5);
    @weakify(self);
    [UIView animateWithDuration:1.0
                          delay:0
         usingSpringWithDamping:0.3
          initialSpringVelocity:0.4
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         @strongify(self);
                         self.countLabel.transform = CGAffineTransformIdentity;
                     }
                     completion:^(BOOL finished) {
                         self.countLabel.transform = CGAffineTransformIdentity;
                     }];
}

#pragma mark - Getter Setter

- (RingShapedProgressView *)progressView
{
    if (!_progressView) {
        CGRect frame;
        frame.origin.x = 0;
        frame.origin.y = 0;
        frame.size = CGSizeMake([self widthRound], [self widthRound]);
        _progressView = [[RingShapedProgressView alloc] initWithFrame:frame];
    }
    return _progressView;
}

- (CGFloat)widthRound
{
    return 40.0f; /**< 环形宽度 数值*/
}

- (UILabel *)countLabel
{
    if (!_countLabel) {
        _countLabel = [[UILabel alloc] initWithFrame:(CGRect){0,0,self.width,self.height}];
        _countLabel.backgroundColor = [UIColor clearColor];
        _countLabel.textColor = [UIColor whiteColor];
        _countLabel.font = font(10);
        _countLabel.textAlignment = NSTextAlignmentCenter;
        _countLabel.numberOfLines = 0;
    }
    return _countLabel;
}

- (CALayer *)innerShader
{
    if (!_innerShader) {
        _innerShader = [CALayer layer];
        _innerShader.backgroundColor = WwColorGenAlpha(@"#000000", 0.2).CGColor;
        _innerShader.frame = (CGRect){0,0,40,40};
        _innerShader.cornerRadius = 40/2.0;
    }
    return _innerShader;
}

@end



@interface RingShapedProgressView ()

@property (nonatomic, strong) CALayer      *whiteLayer;  /**< 半透明背景色*/

@property (nonatomic, strong) CAShapeLayer *colorLayer;  /**< 渐变色进度  */
@property (nonatomic, strong) CAShapeLayer *colorLayerMask; /**< 切割留下 环形进度*/

@property (nonatomic, strong) CAGradientLayer * topLayer;
@property (nonatomic, strong) CAGradientLayer *bottomLayer;

@end



@implementation RingShapedProgressView /**< 顶部进度条*/

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self configUI];
    }
    return self;
}

- (void)configUI
{
    self.backgroundColor = [UIColor clearColor];
    
    [self.layer addSublayer:self.colorLayer];
    
    CAShapeLayer *colorMask = self.layerMask;
    
    self.colorLayer.mask = colorMask;
    self.colorLayerMask = colorMask;

}

- (void)updateProgress:(CGFloat)progress
{
    self.colorLayerMask.strokeEnd = progress;
    if (progress == 1) {
        self.topLayer.colors = TopColorArr;
        self.bottomLayer.colors = BottomColorArr;
    }
}

- (void)updateFillColorToRed
{
    self.topLayer.colors = @[(id)WwColorGen(@"#ef313a").CGColor, (id)WwColorGen(@"#fb6a43").CGColor];
}


#pragma mark - Getter Setter

- (CGFloat)lineWidth
{
    /**< 线宽度*/
    return 2;
}



- (CAShapeLayer *)colorLayer
{
    if (!_colorLayer) {
        CGRect frame =  (CGRect){0,0,self.width,self.height};
        _colorLayer = [CAShapeLayer layer];
        _colorLayer.frame = frame;
        
        CAGradientLayer *leftLayer = [CAGradientLayer layer];
        leftLayer.frame = frame;
        
        // 分段设置渐变色
        leftLayer.locations = @[@0.0, @1];
        leftLayer.colors = TopColorArr;
        
        //从上到下
        leftLayer.startPoint = CGPointMake(0.5, 0);
        leftLayer.endPoint = CGPointMake(0.5, 1);
        
        [_colorLayer addSublayer:leftLayer];
        self.topLayer = leftLayer;
    }
    return _colorLayer;
}



- (CAShapeLayer *)layerMask
{
    CAShapeLayer *layer = [CAShapeLayer layer];
    
    CGRect frame =  (CGRect){0,0,self.width,self.height};
    layer.frame = frame;
    
    // 创建一个圆心为父视图中点的圆，半径为父视图宽的2/5，起始角度是从-240°到60°
    UIBezierPath *path = nil;

    layer.lineWidth = [self lineWidth];
    
    path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(frame.size.width / 2, frame.size.width / 2)
                                          radius:frame.size.width / 2.0 - 1
                                      startAngle:DEGREES_TO_RADOANS(-90)
                                        endAngle:DEGREES_TO_RADOANS(-(360+90))
                                       clockwise:NO];
  
    
    layer.path = path.CGPath;
    layer.fillColor = [UIColor clearColor].CGColor; // 填充色为透明（不设置为黑色）
    layer.strokeColor = [UIColor blackColor].CGColor; // 随便设置一个边框颜色
    
    path.lineCapStyle = kCGLineCapSquare;
    path.lineJoinStyle = kCGLineJoinMiter;
    
    return layer;
}


@end

