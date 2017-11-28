//
//  WwUserInfoManager.h
//  WawaSDK
//
//  Copyright © 2017年 杭州庆余年网络科技有限公司 All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "WwDataDef.h"
#import "WwConstants.h"

typedef NS_OPTIONS(NSUInteger, WwWawaListType) {
    WawaList_Deposit = 1<<0, /**< 寄存中*/
    WawaList_Deliver = 1<<1, /**< 运送中*/
    WawaList_Exchange = 1<<2, /**< 已兑换*/
    WawaList_All = WawaList_Deposit | WawaList_Deliver | WawaList_Exchange, /**< 全部*/
};

@class WwUserWawaModel;
@class UserInfo;

/**
 * WwUserInfoManager代理
 */
#pragma mark - WwUserInfoManagerDelegate
@protocol WwUserInfoManagerDelegate <NSObject>

- (void)onUserInfoManagerError:(UserInfoError)error;

@end


/**
 * WwUserInfoManager是用户个人信息管理对象，负责:
 * 1.用户信息获取与修改 
 * 2.游戏结果与游戏记录查询
 * 3.战利品查询
 * 4.娃娃列表查看与发货订单管理
 */
#pragma mark - WwUserInfoManager
@interface WwUserInfoManager : NSObject

@property (nonatomic, weak) id<WwUserInfoManagerDelegate> delegate; /**< 代理*/
@property (nonatomic, copy) UserInfo *(^userInfo)(void);            /**< 数据源*/
@property (nonatomic, strong) WwUserModel * currentUserInfo;        /**< 当前SDK注册的用户信息*/

/**
 * 获取WwUserInfoManager 单例
 */
+ (instancetype)UserInfoMgrInstance;

/**
 * 合作方，当用户从匿名，登陆之后，主动触发调用。
 */
- (void)loginUserWithCompleteHandler:(void (^)(int code, NSString *message))complete;

/**
 * 合作方，退出登录。
 */
- (void)logout;

/**
 * 请求当前登陆用户信息
 * @param complete 回调block
 */
- (void)requestUserInfoWithCompleteHandler:(void (^)(WwUserModel *user))complete;

/**
 * 请求用户信息
 * @param uid 要请求的用户uid, 注意, 这个uid不是接入方服务器分配的uid, 而是通过SDK接口获取的uid. 当看自己，传0
 * @param complete 回调block
 */
- (void)requestCommonUserInfoWithUid:(NSInteger)uid completeHandler:(void (^)(BOOL success, NSInteger code, NSString * msg, WwUserModel *user))complete;


/**
 * 请求用户游戏记录
 * @param page 页数，从1开始
 * @param complete 回调block
 */
- (void)requestGameRecordAtPage:(NSInteger)page
            withCompleteHandler:(void (^)(int code, NSString *message, NSArray<WwGameRecordModel *> *list))complete;


/**
 * 请求用户地址列表
 * @param complete 回调block
 */
- (void)requestUserAddressWithCompleteHandler:(void (^)(int code, NSString *message, NSArray<WwAddressModel *> *list))complete;


/**
 * 请求用户抓取到娃娃列表
 * @param type 获取不同类型列表数据
 * @param complete 回调block
 */
- (void)requestUserWawaList:(WwWawaListType)type withCompleteHandler:(void (^)(int code, NSString *message, WwUserWawaModel *model))complete;



/**
 * 请求用户战利品列表
 * @param page 页数，从1开始
 * @param uid 看谁的战利品，传谁的uid. 当登陆用户查看自己。 uid传0
 * @param complete 回调block
 */
- (void)requestUserWardrobeAtPage:(NSInteger)page
                           userId:(long long)uid
              withCompleteHandler:(void (^)(int code, NSString *message, WwTrophy *trophy))complete;


/**
 * 请求商城物品列表
 * @param page 页数，从1开始
 * @param complete 回调block
 */
- (void)requestUserMallListAtPage:(NSInteger)page
              withCompleteHandler:(void (^)(int code, NSString *message, NSArray<WwMallGoodsInfo *> *list))complete;

/**
 * 积分兑换娃娃
 * @param wid 兑换娃娃，id
 * @param complete 回调
 */
- (void)requestUserMallGoodsExchangeWWID:(NSInteger)wid
              withCompleteHandler:(void (^)(int code, NSString *message, NSInteger balance))complete;

/**
 * 请求发货
 * @param wawaIds 娃娃寄存项ID数组
 * @param complete 回调block
 */
- (void)requetCreateOrderWithWawaIds:(NSArray <NSString *> *)wawaIds
                             address:(WwAddressModel *)addressModel
                 withCompleteHandler:(void (^)(int code, NSString *message))complete;


/**
 * 请求积分商城列表
 */
- (void)requetGoodMallListAtPage:(NSInteger)page complete:(void(^)(BOOL success, NSInteger code,NSArray <WWExchangeInfo *>* arr))complete;

/**
 * 请求兑换娃娃
 * @param info 娃娃信息, 使用列表页请求到的娃娃信息
 */
- (void)requestExchangeGood:(WWExchangeInfo *)info complete:(void(^)(BOOL success, NSInteger code, NSString * msg))complete;

#pragma mark - 游戏记录 申诉游戏
/**
 * 请求申述游戏
 * @param orderID 游戏订单号, 使用列表页请求到的订单信息
 */
- (void)requestReportGame:(NSString *)orderID reason:(NSString *)reason reasonId:(NSString *)reasonID complete:(void(^)(BOOL success, NSInteger code, NSString * msg))complete;

#pragma mark - 用户举报
/**
 * 房间内举报某个用户
 */
- (void)requestReportUser:(NSInteger)uid type:(NSInteger)type inRoom:(NSInteger)rid complete:(void(^)(BOOL success, NSInteger code, NSString * msg))complete;

#pragma mark - 我的娃娃
/**
 * 娃娃兑换成金币
 * @param exWawaDict 兑换娃娃的字典
 */
- (void)requestWawaExchangeCoin:(NSDictionary *)exWawaDict withCompleteHandler:(void (^)(int code, NSString *message))complete;

#pragma mark - 确认收货与物流接口
/**
 * 确认收货接口
 * @param orderId 订单ID
 */
- (void)requestRecivedGoods:(NSString *)orderId withCompleteHandler:(void (^)(int code, NSString *message))complete;


#pragma mark - 物流查询
/**
 * 物流查询
 * @param orderId 订单ID
 */
- (void)requestExpressInfo:(NSString *)orderId withCompleteHandler:(void (^)(int code, NSString *message, AVTLogisticsModel *model))complete;
@end

/**
 * 当前第三方用户信息
 */
#pragma mark - UserInfo
@interface UserInfo : NSObject
@property (nonatomic, copy) NSString *uid;      /**< 用户ID*/
@property (nonatomic, copy) NSString *name;     /**< 用户昵称*/
@property (nonatomic, copy) NSString *avatar;   /**< 用户头像*/
@end


/**
 * 用户抓到娃娃与发货订单数据对象
 */
#pragma mark - WwUserWawaModel
@interface WwUserWawaModel : NSObject
@property (nonatomic, copy) NSMutableArray <WwWawaOrderModel *> *deliverList;      /**< 已发货*/
@property (nonatomic, copy) NSMutableArray <WwWawaOrderModel *> *exchangeList;     /**< 已兑换*/
@property (nonatomic, copy) NSMutableArray <WwWawaDepositModel *> *depositList;    /**< 寄存中*/
@property (nonatomic, assign) NSInteger deliverTotalCount;                                /**< 已发货总数*/
@property (nonatomic, assign) NSInteger exchangeTotalCount;                                /**< 已兑换总数*/
@property (nonatomic, assign) NSInteger depositTotalCount;                                /**< 寄存中总数*/
@end

@interface WwUserInfoManager (Modify)

/**< 为保证修改资料的成功率，修改用户头像 和 其他资料分别修改*/

/**
 修改登录用户信息
 @param changeHandle  开发者在changeHandle block 中修改用户的个人信息
 @param complete 修改用户信息API调用的回调
 eg:
    [[WwUserInfoManager UserInfoMgrInstance] updateUserInfo:^(WwUserChangeInfo *changedUser) {
        // 性别改为男
        changedUser.gender = 1;
        // 昵称改为 "小明"
        changedUser.nickname = @"小明";
    } withCompleteHandler:^(int code, NSString *message) {
        // 修改用户信息API调用的回调
    }];
 */
- (void)updateUserInfo:(void(^)(WwUserChangeInfo *changedUser))changeHandle
   withCompleteHandler:(void (^)(int code, NSString *message))complete;


/**
 * 修改登录用户头像
 * @param image 头像
 * @param complete 回调
 */
- (void)updateUserPortrait:(UIImage *)image
       withCompleteHandler:(void (^)(int code, NSString *message))complete;


/**
 * 请求收货地址列表
 * @param complete 回调
 */
- (void)requestAddressListComplete:(void (^)(int code, NSString *message,NSArray<WwAddressModel *> *addressList))complete;


/**
 * 设置已有一个地址是否是默认地址
 * @param aId 地址ID
 * @param isdefault YES 默认
 * @param completeHandle 回调
 */
- (void)updateAddress:(NSInteger)aId toDefault:(BOOL)isdefault complete:(void (^)(int code, NSString *message))completeHandle;

/**
 * 新加入一个收货地址
 * @param addHandle 在 addHandle block中，填写要新加入的地址信息
 * @param complete 回调
 * @discuss
     [[WwUserInfoManager UserInfoMgrInstance] addUserAddress:^(WwAddressModel *address) {
         address.province = @"北京";
         ...
        //在此将所有参数必填（除了aID）
     } withCompleteHandler:^(int code, NSString *message) {
        //请求结果回调
    }];
 */
- (void)addUserAddress:(void (^)(WwAddressModel *address))addHandle
   withCompleteHandler:(void (^)(int code, NSString *message))complete;

/**
 * 删除一个收货地址
 * @param aID address ID
 * @param complete 回调
 */
- (void)deleteUserAddress:(NSInteger)aID
      withCompleteHandler:(void (^)(int code, NSString *message))complete;

/**
 * 编辑修改一个收货地址,
 * @param upHandle ,在upHandle block 中，填写需要修改的地址信息
 * @param complete 回调
 * @discuss
     [[WwUserInfoManager UserInfoMgrInstance] updateUserAddress:^(WwAddressModel *upAddress) {
         upAddress.aID = 123;
         upAddress.province = @"北京";
         ...
         //在此将所有参数必填, Note:aID 是从sdk获取的
     } withCompleteHandler:^(int code, NSString *message) {
        //请求结果回调
     }];
 */
- (void)updateUserAddress:(void (^)(WwAddressModel *upAddress))upHandle
   withCompleteHandler:(void (^)(int code, NSString *message))complete;

/**
 * 游戏申诉状态
 * @param orderID 游戏编号
 * @param complete 回调 isComplain
 */
- (void)gameAppealWithOrderID:(NSString *)orderID
      withCompleteHandler:(void (^)(int code, BOOL isComplain, NSString *message))complete;

@end

