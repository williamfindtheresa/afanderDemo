//
//  WwWawaParticularsInfo.h
//  F_Sky
//


#import <Foundation/Foundation.h>

@interface WwWawaParticularsInfo : NSObject

@property (nonatomic, copy) NSString *ID;
//名称
@property (nonatomic, copy) NSString *name;
//尺寸
@property (nonatomic, copy) NSString *size;
//标志 0 默认, 1最新, 2最热
@property (nonatomic, assign) NSInteger flag;
@property (nonatomic, copy) NSString *code;
//单次抓娃娃消耗金币
@property (nonatomic, assign) NSInteger coin;
//单次抓娃娃消耗鱼丸
@property (nonatomic, assign) NSInteger fishball;
//单次抓娃娃消耗兑换劵
@property (nonatomic, assign) NSInteger coupon;
//兑换价格
@property (nonatomic, assign) NSInteger recoverCoin;
//陈列柜图片
@property (nonatomic, copy) NSString *icon;
//封面图
@property (nonatomic, copy) NSString *pic;
//	品牌
@property (nonatomic, copy) NSString *brand;
//适用年龄
@property (nonatomic, copy) NSString *suitAge;
//娃娃详情图片,按逗号分开
@property (nonatomic, copy) NSString *detailPics;
//填充物
@property (nonatomic, copy) NSString *filler;
//面料
@property (nonatomic, copy) NSString *material;
//level
@property (nonatomic, assign) NSInteger level;

@end
