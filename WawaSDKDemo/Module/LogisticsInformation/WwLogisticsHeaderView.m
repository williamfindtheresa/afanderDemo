//
//  WwLogisticsHeaderView.m
//

#import "WwLogisticsHeaderView.h"

#import "WwLogisticsDataModel.h"
#import "WwViewUtil.h"


@interface WwLogisticsHeaderView ()

@property (weak, nonatomic) IBOutlet UIImageView *pic;
@property (weak, nonatomic) IBOutlet UILabel *deliverStatus; //物流状态
@property (weak, nonatomic) IBOutlet UILabel *numberLabel; //运单号
@property (weak, nonatomic) IBOutlet UILabel *fromSource; //来源
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel; //官方号码
@property (weak, nonatomic) IBOutlet UILabel *totalLabel; //共几件
@property (weak, nonatomic) IBOutlet UIView *picContainer;
@property (nonatomic, copy) NSString *officalPhone;
@end

@implementation WwLogisticsHeaderView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.numberLabel.adjustsFontSizeToFitWidth = YES;
    self.phoneLabel.adjustsFontSizeToFitWidth = YES;
    self.fromSource.adjustsFontSizeToFitWidth = YES;
    
    self.picContainer.layer.cornerRadius = 3;
    self.picContainer.layer.masksToBounds = YES;
    
    self.picContainer.layer.borderColor = WwColorGen(@"#ffd236").CGColor;
    self.picContainer.layer.borderWidth = 0.5;
    
    [self.phoneLabel  addSingleTapGestureAtTarget:self action:@selector(callPhone:)];
    
    self.backgroundColor = WwColorGen(@"FFFFFF");
    
    [self  refreshInitData];
}

#pragma mark - Public
- (void)fillContentWithOrderModel:(WwWawaOrderModel *)model
{
    NSInteger totalNum = 0;
    totalNum = model.records.count;
    totalNum = MAX(1, totalNum);
    self.totalLabel.text = [NSString stringWithFormat:@"共%zi件",totalNum];
    
    NSString *pic = nil;
    pic = [(WwWawaOrderItem *)[model.records safeObjectAtIndex:0] pic];
    [self.pic sd_setImageWithURL:[NSURL URLWithString:realString(pic)]];
}

- (void)loadData:(WwLogisticsModel *)data {
    
    if (data.wawaNum > 0) {
        self.totalLabel.text = [NSString stringWithFormat:@"共%zi件",data.wawaNum];
    }
    
    [self.pic sd_setImageWithURL:[NSURL URLWithString:realString(data.wawa.pic)]];
    
    if (realString(data.number).length) {
        NSMutableAttributedString *wuliu = [self messageTitle:@"物流状态：" titleColor:@"#5a342b" resultStr:[data deliverDescription] resultColor:@"#1ed771" fontNum:16];
        self.deliverStatus.attributedText = wuliu;
    }
    
    NSMutableAttributedString *chengyun = [self messageTitle:@"承运来源：" titleColor:@"#e5a830" resultStr:data.company resultColor:@"#e5a830" fontNum:14];
    self.fromSource.attributedText = chengyun;
    
    
    NSMutableAttributedString *danhao = [self messageTitle:@"运单编号：" titleColor:@"#e5a830" resultStr:data.number resultColor:@"#e5a830" fontNum:14];
    
    self.numberLabel.attributedText = danhao;
    
    self.phoneLabel.attributedText = [self messageTitle:@"官方电话：" titleColor:@"#e5a830" resultStr:data.tel resultColor:@"#5cabff" fontNum:14];
    
    self.officalPhone = data.tel;
}

#pragma mark - Helper

/**< 默认状态*/
- (void)refreshInitData
{
    NSMutableAttributedString *wuliu = [self messageTitle:@"物流状态：" titleColor:@"#5a342b" resultStr:@"等待发货" resultColor:@"#1ed771" fontNum:16];
    self.deliverStatus.attributedText = wuliu;
    
    NSMutableAttributedString *chengyun = [self messageTitle:@"承运来源：" titleColor:@"#e5a830" resultStr:nil resultColor:@"#e5a830" fontNum:14];
    self.fromSource.attributedText = chengyun;
    
    NSMutableAttributedString *danhao = [self messageTitle:@"运单编号：" titleColor:@"#e5a830" resultStr:nil resultColor:@"#e5a830" fontNum:14];
    
    self.numberLabel.attributedText = danhao;
    
    self.phoneLabel.attributedText = [self messageTitle:@"官方电话：" titleColor:@"#e5a830" resultStr:nil resultColor:@"#5cabff" fontNum:14];
}


- (NSMutableAttributedString *)messageTitle:(NSString *)title
                       titleColor:(NSString *)tcolor
                        resultStr:(NSString *)result
                      resultColor:(NSString *)resultColor
                          fontNum:(NSInteger)num
{
    
    NSString *mt = realString(title);
    NSString *mr = realString(result);
    
    NSMutableAttributedString * mstr = [[NSMutableAttributedString  alloc] initWithString:mt];
    [mstr addAttribute:NSForegroundColorAttributeName value:WwColorGen(tcolor) range:mt.rangeOfAll];
    
    
    NSMutableAttributedString *mrStr = [[NSMutableAttributedString  alloc] initWithString:mr];
    [mrStr addAttribute:NSForegroundColorAttributeName value:WwColorGen(resultColor) range:mr.rangeOfAll];
    
    [mstr appendAttributedString:mrStr];
    
    [mstr addAttribute:NSFontAttributeName value:font(num) range:mstr.rangeOfAll];
    
    return mstr;
}


- (void)callPhone:(UITapGestureRecognizer *)tap
{
    if (!realString(self.officalPhone).length) {
        return;
    }

    NSMutableString* str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",self.officalPhone];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}


@end
