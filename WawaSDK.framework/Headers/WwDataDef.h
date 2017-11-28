//
//  WwDataDef.h
//  WawaSDK
//
//  Copyright © 2017年 杭州庆余年网络科技有限公司 All rights reserved.
//

#import <Foundation/Foundation.h>

@class WwWawaItem;
@class WwUserModel;


/**
 * 基础图片转换类
 */
@interface AVTImageBaseModel : NSObject
@property (nonatomic, strong) NSString * portrait;                      /**< 头像*/
@property (nonatomic, strong) NSString * icon;                          /**< 单体icon, 缩略*/
@property (nonatomic, strong) NSString * pic;                           /**< 详情大图, 高清*/
@end


/**
 * 游戏房间描述对象
 */
@interface WwRoomModel : NSObject

@property (nonatomic, assign) NSInteger ID;         /**< 房间ID*/
@property (nonatomic, assign) NSInteger state;      /**< 房间状态: 小于1:故障 1：补货 2:空闲 大于2:游戏中*/
@property (nonatomic, strong) WwWawaItem *wawa;     /**< 玩具描述对象*/
@property (nonatomic, assign) NSInteger uid;        /**< 在玩的人uid*/
@property (nonatomic, strong) WwUserModel *user;    /**< 在玩的玩家*/
@property (nonatomic, copy)   NSString *streamMaster;
@property (nonatomic, copy)   NSString *streamPlayer;
@property (nonatomic, copy)   NSString *streamSlave;
@property (nonatomic, copy)   NSString *orderId;
@end


/**
 * 娃娃玩具描述对象
 */
@interface WwWawaItem : AVTImageBaseModel

@property (nonatomic, assign) NSInteger ID;         /**< 娃娃ID*/
@property (nonatomic, assign) NSInteger flag;       /**< 按位与运算，0位标识是否新品娃娃，1位标识是否热门*/
@property (nonatomic, assign) NSInteger coin;       /**< 所需金币*/
@property (nonatomic, assign) NSInteger fishball;   /**< 所需鱼丸*/
@property (nonatomic, assign) NSInteger coupon;     /**< 所需优惠券*/
@property (nonatomic, copy)   NSString  *name;      /**< 娃娃名称*/

@end

/**
 * 个人财富描述对象
 */
@interface WwRichInfo : NSObject

@property (nonatomic, assign) long long coin;        /**< 金币*/
@property (nonatomic, assign) long long fishball;    /**< 鱼丸*/
@property (nonatomic, assign) long long coupon;      /**< 畅玩券今日余额*/
@property (nonatomic, assign) long long couponDays;  /**< 畅玩券剩余天数*/

@end

/**
 * 玩家描述对象
 */
@interface WwUserModel : AVTImageBaseModel

@property (nonatomic, assign) NSInteger uid;         /**< 用户ID*/
@property (nonatomic, assign) NSInteger gender;      /**< 性别, 1男 0女*/
@property (nonatomic, copy)   NSString  *nickname;   /**< 昵称*/
@property (nonatomic, copy)   NSString  *birth;      /**< 生日 yyyy-MM-dd*/
@property (nonatomic, strong) WwRichInfo *rich;      /**< 剩余的财富（钻石和星光）*/

@property (nonatomic, assign) NSInteger spoils; /**< 战利品个数*/

@end


/**
 用户当前可修改资料 描述对象
 */
@interface WwUserChangeInfo : NSObject

@property (nonatomic, assign) NSInteger gender;      /**< 性别, 1男 0女*/
@property (nonatomic, copy)   NSString  *nickname;   /**< 昵称 长度不超过8*/
@property (nonatomic, copy)   NSString  *birth;      /**< 生日 yyyy-MM-dd*/

@end

/**
 * 玩家地址信息描述对象
 */
@interface WwAddressModel : NSObject

@property (nonatomic, assign) NSInteger aID;         /**< 地址ID*/
@property (nonatomic, strong) NSString  *province;   /**< 省份*/
@property (nonatomic, strong) NSString  *city;       /**< 城市*/
@property (nonatomic, strong) NSString  *district;   /**< 县,区*/
@property (nonatomic, strong) NSString  *address;    /**< 详细地址*/
@property (nonatomic, strong) NSString  *name;       /**< 联系人*/
@property (nonatomic, strong) NSString  *phone;      /**< 手机*/
@property (nonatomic, assign) BOOL isDefault;        /**< 是否默认地址*/

@end

@class WwGameRecordVideoItem;
@class WwGameRecordWawaItem;
/**
 * 游戏记录描述对象
 */
@interface WwGameRecordModel : NSObject

@property (nonatomic, copy) NSString *dateline;     /**< 游戏时间*/
@property (nonatomic, copy) NSString *orderId;      /**< 记录Id*/
@property (nonatomic, assign) NSInteger wid;        /**< 娃娃ID*/
@property (nonatomic, assign) NSInteger status;     /**< 状态 0:失败（游戏失败，如机器故障）; 1:未抓中; 2:抓中;*/
@property (nonatomic, strong) WwGameRecordVideoItem *video;
@property (nonatomic, assign) NSInteger coin;       /**< 消耗金币*/
@property (nonatomic, assign) NSInteger fishball;   /**< 消耗鱼丸*/
@property (nonatomic, assign) NSInteger coupon;     /**< 消耗点券*/
@property (nonatomic, copy) NSString *awardFishball; /**< 奖励鱼丸*/
@property (nonatomic, strong) WwGameRecordWawaItem *wawa;

@end

/**
 * 视频回放描述对象
 */
@interface WwGameRecordVideoItem : NSObject
@property (nonatomic, copy) NSString *machineStream;
@property (nonatomic, copy) NSString *livekey;
@property (nonatomic, assign) NSInteger startTime;  /**< 单位为秒，从1970-1-1 00:00:00开始*/
@property (nonatomic, assign) NSInteger duration;   /**< 单位为秒*/
@end

/**
 * 个人游戏记录
 */
@interface WwGameRecordWawaItem : AVTImageBaseModel

@property (nonatomic, copy) NSString *name;         /**< 娃娃名称*/

@end

/**
 * 用户战利品
 */

@interface WwWawaInfo : AVTImageBaseModel
@property (nonatomic, copy) NSString *name;

@end

@interface WwWarTrophyInfo : NSObject
@property (nonatomic, copy) NSString *dateline;
@property (nonatomic, strong) WwWawaInfo *wawa;
@property (nonatomic, assign) NSInteger uid;
@property (nonatomic, assign) NSInteger wawaId;
@property (nonatomic, assign) NSInteger total;

@end

@interface WwWardrobeModel : NSObject

@property (nonatomic, assign) NSInteger level1;    /**< 等级1的战利品数目*/
@property (nonatomic, assign) NSInteger level2;    /**< 等级2的战利品数目*/
@property (nonatomic, assign) NSInteger level3;    /**< 等级3的战利品数目*/
@property (nonatomic, assign) NSInteger level4;    /**< 等级4的战利品数目*/
@property (nonatomic, assign) NSInteger spoils;    /**< 战利品总数*/

@end

@interface WwTrophy : NSObject
@property (nonatomic, strong) WwWardrobeModel *warTrophyHead;
@property (nonatomic, strong) NSArray<WwWarTrophyInfo*> *warTrophyInfo;

@end


/**
 * 商城货物信息
 */
@interface WwMallGoodsInfo : AVTImageBaseModel
@property (nonatomic, copy) NSString *code;                 /**< 商品编号*/
@property (nonatomic, copy) NSString *name;                 /**< 货物名称*/
@property (nonatomic, assign) NSInteger ID;                 /**< 货物ID*/
@property (nonatomic, assign) NSInteger exchangeFishball;   /**< 兑换所需鱼丸*/
@property (nonatomic, assign) NSInteger flag;               /**< 按位与运算，第3位标识是否热门，eg: flag&(1<<2) */
@end

/**
 * 娃娃寄存对象
 */
@interface WwWawaDepositModel : AVTImageBaseModel
@property (nonatomic, assign) NSInteger ID;         /**< 记录ID*/
@property (nonatomic, assign) NSInteger wid;        /**< 娃娃ID*/
@property (nonatomic, assign) NSInteger expTime;    /**< 寄存剩余天数*/
@property (nonatomic, copy)   NSString  *name;      /**< 娃娃名称*/
@property (nonatomic, assign) NSInteger coin;       /**< 价值*/
@property (nonatomic, assign) BOOL selected;        /**< 标记选中*/
@end

/**
 * 娃娃发货订单条目
 */
@interface WwWawaOrderItem : AVTImageBaseModel
@property (nonatomic, assign) NSInteger wid;        /**< 娃娃id*/
@property (nonatomic, copy)   NSString  *name;      /**< 娃娃名称*/
@property (nonatomic, assign) NSInteger coin;       /**< 价值*/
@property (nonatomic, assign) NSInteger num;        /**< 娃娃数量*/
@property (nonatomic, assign) BOOL selected;        /**< 标记选中*/
@end

/**
 * 游戏结果
 */
@interface WwGameResultModel : NSObject
@property (nonatomic, assign) NSInteger ID;                         /**< id*/
@property (nonatomic, strong) NSString * dateline;                  /**< 时间*/
@property (nonatomic, strong) NSString * orderId;                   /**< 订单号*/
@property (nonatomic, assign) NSInteger uid;                        /**< 用户ID*/
@property (nonatomic, assign) NSInteger rid;                        /**< rid*/
@property (nonatomic, assign) NSInteger playTimes;                  /**< 上机时间*/
@property (nonatomic, assign) NSInteger clawTimes;                  /**< 游戏(摇爪操作)时间*/
@property (nonatomic, strong) NSString * video;                     /**< 游戏视频*/
@property (nonatomic, assign) NSInteger coin;                       /**< 奖励*/
@property (nonatomic, assign) NSInteger fishball;                   /**< */
@property (nonatomic, assign) NSInteger coupon;                     /**< */
@property (nonatomic, assign) NSInteger awardFishball;              /**< 奖励*/
@property (nonatomic, assign) NSInteger state;                      /**< 状态, 0，1失败，2成功*/
@property (nonatomic, assign) NSInteger stage;                      /**< -1上机失败，1:上机中，2:摇杆中, 3:下抓中, 4:游戏结束, 5: 游戏申述*/
@property (nonatomic, assign) NSInteger wawaSuccess;                /**< 已有多少人抓住了娃娃*/
@property (nonatomic, strong) WwWawaItem * wawa;                    /**< 娃娃数据*/
@end


/**
 * 娃娃发货订单
 */
@interface WwWawaOrderModel : NSObject
@property (nonatomic, copy)   NSString *orderId;    /**< 订单id*/
@property (nonatomic, assign) NSInteger status;     /**< 快递状态，0发货准备中；1运送中；2已收货 */
@property (nonatomic, copy)   NSString *dateline;   /**< 申请发货时间*/
@property (nonatomic, copy)   NSMutableArray <WwWawaOrderItem *> *records; /**< 订单具体条目*/
@property (nonatomic, assign) BOOL selected;        /**< 标记选中*/
@end

/**
 * 聊天
 */
@interface WwChatModel : NSObject

@property (nonatomic, strong) WwUserModel *user;    /**< 发言者*/
@property (nonatomic, strong) NSString *msg;        /**< 发炎内容*/

@end


/**
 房间状态更新
 */
@interface WwRoomLiveData : NSObject

@property(nonatomic, assign) NSInteger rid;
@property(nonatomic, strong) WwUserModel *user; /**< 玩家，没人玩 nil*/
/** -100:机器回收, -1:机器下架, 0:机器故障,  1:补货中，2: 空闲, 3:开始游戏, 4: 移动中, 5:下抓(等待结果), 6: 等待重新上机 */
@property(nonatomic, assign) NSInteger state;
@property(nonatomic, copy) NSString *streamPlayer; /** 增加了flag 字段 */

@end


/**
 娃娃抓取结果通知
 */
@interface WwClawResult : NSObject

@property(nonatomic, assign) NSInteger rid;
/** 用户 */
@property(nonatomic, strong) WwUserModel *user;
/** 1:未抓中; 2:抓中; */
@property(nonatomic, assign) NSInteger status;

@end


@interface WwGlobalNotify: NSObject
/** 文本消息内容 */
@property(nonatomic, copy) NSString *message;
@end



/**
 房间内娃娃详细资料
 */
@interface WwWaWaDetailInfo : AVTImageBaseModel
@property (nonatomic, assign) NSInteger wid;        /**< 娃娃id*/
@property (nonatomic, copy) NSString *name;         /**< 名称*/
@property (nonatomic, copy) NSString *size;         /**< 尺寸*/
@property (nonatomic, assign) NSInteger flag;
@property (nonatomic, copy) NSString *code;
@property (nonatomic, assign) NSInteger coin;       /**< 单次抓娃娃消耗金币*/
@property (nonatomic, assign) NSInteger fishball;   /**< 单次抓娃娃消耗鱼丸*/
@property (nonatomic, assign) NSInteger coupon;     /**< 单次抓娃娃消耗兑换劵*/
@property (nonatomic, assign) NSInteger recoverCoin;/**< 兑换价格*/
@property (nonatomic, copy) NSString *brand;        /**< 品牌*/
@property (nonatomic, copy) NSString *suitAge;      /**< 适用年龄*/
@property (nonatomic, strong) NSString *detailPics; /**< 娃娃详情图片,按逗号分开*/
@property (nonatomic, copy) NSString *filler;       /**< 填充物*/
@property (nonatomic, copy) NSString *material;     /**< 面料*/
@property (nonatomic, assign) NSInteger level;      /**< 等级*/
@end

/**
 房间内最近抓中游戏记录
 */
@interface WwRoomRecordInfo : NSObject
@property (nonatomic, copy) NSString *dateline;
@property (nonatomic, copy) NSString *orderId;
@property (nonatomic, strong) WwGameRecordVideoItem *video;
@property (nonatomic, assign) NSInteger wid;
@property (nonatomic, strong) WwUserModel *user;   /**< 抓中的人*/
@end


/**
 * 积分商城商品列表
 */
@interface WWExchangeInfo : AVTImageBaseModel

@property (nonatomic, copy) NSString *code;
@property (nonatomic, assign) NSInteger exchangeFishball;
@property (nonatomic, assign) NSInteger flag;
@property (nonatomic, assign) NSInteger ID;
@property (nonatomic, copy) NSString *name;

@end


/*
 * 物流信息
 */
@class AVTLogisticsListInfo;
@interface AVTLogisticsModel : NSObject

@property (nonatomic, copy) NSString *number;//单号
@property (nonatomic, copy) NSString *type; //快递类型
@property (nonatomic, copy) NSString *company; //快递公司名称
@property (nonatomic, assign) NSInteger deliverystatus ;//1.在途中 2. 派送中 3. 已签收 4. 派送失败或者拒收

@property (nonatomic, assign) NSInteger issign;

@property (nonatomic, strong) NSArray<AVTLogisticsListInfo *> * list;

@property (nonatomic, strong) WwWawaItem *wawa;

@property (nonatomic, assign) NSInteger wawaNum; //娃娃数量

@property (nonatomic, copy) NSString  *tel; //官方电话号码

- (NSString *)deliverDescription;

@end


/*
 * 物流追踪信息
 */
@interface AVTLogisticsListInfo : NSObject

@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *time;

//mock
@property (nonatomic, assign) BOOL isFirst; //是不是第一个list数据 mock
@property (nonatomic, assign) BOOL isLast;

@end
