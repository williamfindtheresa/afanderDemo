//
//  WwLatestLiveCell.m
//  F_Sky
//

#import "WwLatestLiveCell.h"

#import "UIImageView+WawaKit.h"
#import "UIColor+WawaKit.h"
#import "UILabel+WawaKit.h"

#define WawaKitColorGen(aColorString) [UIColor colorFromString:aColorString]

@interface WwLatestLiveCell()

//背景图片
@property (weak, nonatomic) IBOutlet UIImageView *portraitImageView;

//热门标签
@property (weak, nonatomic) IBOutlet UIImageView *rightHotView;

//娃娃昵称
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

//机器状态
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;

//娃娃所需金额
@property (weak, nonatomic) IBOutlet UILabel *countLabel;


@property (weak, nonatomic) IBOutlet UIView *bottomSep;

@property (weak, nonatomic) IBOutlet UIView *rightSep;

@property (weak, nonatomic) IBOutlet UIImageView *priceTipImageView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nameRight;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nameLeft;

@end

@implementation WwLatestLiveCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    BOOL isIPhone5_or_Older = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) && ([[UIScreen mainScreen] bounds].size.height <= 568.0);
    
    if (isIPhone5_or_Older) {
        self.nameLeft.constant = 10;
        self.nameRight.constant = 10;
    }
    self.backgroundColor = [UIColor whiteColor];
}


- (void)loadWithData:(WwRoomModel *)aData itemIndex:(NSInteger)rowIndex
{
    if (aData == nil) {
        self.hidden = YES;
        return;
    }
    
    if (rowIndex == 0) {
        CAShapeLayer *mask = [self maskCorner:UIRectCornerTopLeft andRadii:CGSizeMake(16, 16)];
        self.layer.mask = mask;
    }
    else if (rowIndex == 1) {
    
        CAShapeLayer *mask = [self maskCorner:UIRectCornerTopRight andRadii:CGSizeMake(16, 16)];
        self.layer.mask = mask;
    }
    else {
        self.layer.mask = nil;
    }
    
    
    self.hidden = NO;
    if (rowIndex % 2 == 1) {
        self.rightSep.hidden = YES;
    }
    else {
        self.rightSep.hidden = NO;
    }
    
    if (aData.wawa.flag & (1<<1)) {
        self.rightHotView.hidden = NO;
        self.rightHotView.image = [UIImage imageNamed:@"home_hot"];
    }
    else if (aData.wawa.flag & (1<<0))  {
        self.rightHotView.hidden = NO;
        self.rightHotView.image = [UIImage imageNamed:@"home_new"];
    }
    else {
        self.rightHotView.hidden = YES;
    }
    
    [self.portraitImageView ww_setToyImageWithUrl:aData.wawa.pic];
    self.nameLabel.text = aData.wawa.name;
    
    NSString *imageName = @"room_idle";
    NSString *statusDes = nil;
    UIColor *color = WawaKitColorGen(@"#000000");
    if (aData.state == 2) {
        imageName = @"room_idle";
        statusDes = @"空闲中";
        color = WawaKitColorGen(@"#1dd8e4");
    }
    else if (aData.state > 2) {
        imageName = @"room_use";
        statusDes = @"游戏中";
        color = WawaKitColorGen(@"#ff688f");
    }
    else if (aData.state == 1) {
        color = WawaKitColorGen(@"#ffbf24");
        imageName = @"room_buhuo";
        statusDes = @"补货中";
    }
    
    NSMutableAttributedString *attrstr1 = [UILabel attributedString:statusDes withImage:imageName beforeString:YES atPoint:CGPointZero];
    [attrstr1 addAttribute:NSFontAttributeName value:font(14) range:NSMakeRange(0,attrstr1.length)];
    [attrstr1 addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(0,attrstr1.length)];
    self.statusLabel.attributedText =  attrstr1;
    
    self.priceTipImageView.image = [UIImage imageNamed:@"recharge_small"];
    self.countLabel.text = [self getCostDescribeByWawaInfo:aData.wawa];
}


#pragma mark - Helper
- (NSString *)getCostDescribeByWawaInfo:(WwWawaItem *)item {
    NSString * des = nil;
    if (item.coin > 0) {
        des = [NSString stringWithFormat:@"%zi/次", item.coin];
    }
    else if (item.fishball > 0) {
        des = [NSString stringWithFormat:@"%zi/次", item.fishball];
    }
    else if (item.coupon > 0){
        des = [NSString stringWithFormat:@"%zi/次", item.coupon];
    }
    return des;
}

- (CAShapeLayer *)maskCorner:(UIRectCorner)corner andRadii:(CGSize)size
{
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:corner  cornerRadii:size];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    return maskLayer;
}

+ (NSMutableAttributedString *)labelAttributedString:(NSString *)string imageName:(NSString *)imgName imageSize:(CGSize)imgsize point:(CGPoint)point imgFrontString:(BOOL)front {
    //创建富文本
    NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:string];
    
    //NSTextAttachment可以将要插入的图片作为特殊字符处理
    NSTextAttachment *attch = [[NSTextAttachment alloc] init];
    //定义图片内容及位置和大小
    UIImage *img = [UIImage imageNamed:imgName];
    attch.image = img;
    attch.bounds = CGRectMake(point.x, point.y, imgsize.width, imgsize.height);
    //创建带有图片的富文本
    NSAttributedString *imgAttribut = [NSAttributedString attributedStringWithAttachment:attch];
    if (front) {
        //将图片放在第一位
        [attri insertAttributedString:imgAttribut atIndex:0];
    }
    else {
        //将图片放在最后一位
        [attri appendAttributedString:imgAttribut];
    }
    return attri;
}



@end
