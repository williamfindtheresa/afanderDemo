//
//  WwGameManager.h
//  WawaSDK
//
//  Copyright © 2017年 杭州庆余年网络科技有限公司 All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WwDataDef.h"
#import "WwConstants.h"

@protocol WwGameManagerDelegate <NSObject>

// game
- (void)gameManagerError:(UserInfoError)error;
- (void)audienceListDidChanged:(NSArray <WwUserModel *>*)array; /**< 房间观众列表变更回调, 每次均会回调第一页的最新列表*/

// stream
- (void)onMasterStreamReady;  /**< 主摄像头的流已经加载成功了*/
- (void)onSlaveStreamReady;   /**< 辅摄像头的流已经加载成功了*/

// IM
- (void)reciveRemoteMsg:(WwChatModel *)chatM; /**< 收到聊天回调*/
- (void)reciveWatchNumber:(NSInteger)number; /**< 收到 观看人数*/
- (void)reciveRoomUpdateData:(WwRoomLiveData *)liveData; /**< 收到 房间状态更新*/
- (void)reciveClawResult:(WwClawResult *)result; /**< 房间内收到 抓娃娃结果通知*/
- (void)reciveGlobleMessage:(WwGlobalNotify *)notify; /**< 收到全平台 抓娃娃结果通知*/

// Tool
- (void)avatarTtlDidChanged:(NSInteger)ttl; /**< ping游戏服务器延迟变更, 每2s ping一次*/

@end


typedef NS_ENUM(NSInteger, PlayDirection) {
    PlayDirection_None = -1, // 未知
    PlayDirection_Up,   // 上
    PlayDirection_Left,// 左
    PlayDirection_Down,// 下
    PlayDirection_Right,// 右
    PlayDirection_Confirm,// 下抓
};

typedef NS_ENUM(NSInteger, PlayOperationType) {
    PlayOperationType_Click,    // 点击
    PlayOperationType_LongPress,// 长按
    PlayOperationType_Release, // 抬起
    PlayOperationType_Reverse, // 撤销长按
};


/**
 * WwGameManager是房间内游戏管理对象，负责:
 * 1.加入房间: 包含加入房间的数据完整性校验
 * 2.房间信息获取：包括当前房间信息与状态，娃娃详情查询
 * 3.观众列表获取与定时刷新
 * 4.发送弹幕、接收弹幕
 * 5.上机请求
 * 6.发送操作指令、切换摄像头等游戏操作
 * 7.接收游戏结果
 */

@interface WwGameManager : NSObject

@property (nonatomic, weak) id<WwGameManagerDelegate> delegate;

/**
 * 获取WwGameManager 单例
 */
+ (instancetype)GameMgrInstance;

/*
 * 加入房间, 需要传入房间列表页给接入方的room字段,
 * SDK内部会对必要数据进行校验,如果校验不通过会直接返回nil
 * 必要字段有: ID, streamMaster, streamPlayer, streamSlave
 */
- (UIView *)enterRoomWith:(WwRoomModel *)room;

/*
 * 销毁房间, 离开房间时务必调用, 否则会影响之后的逻辑
 */
- (void)destoryRoom;

/*
 * 开始播放娃娃机视频流换面
 */
- (void)startGamePlayer;

/*
 * 停止播放娃娃机视频流换面
 */
- (void)stopGamePlayer;

/*
 * 获取房间信息与状态接口, 需要接入方注入房间ID字段,
 * SDK内部会对传入数据进行判空处理,如果判断传入的房间ID为空会直接回调失败block并返回
 * 必要字段有: ID
 */
- (void)requestRoomInfo:(NSInteger)ID complete:(void(^)(BOOL success,NSInteger code,WwRoomModel * roomInfo))block;

/**
 娃娃详情查询, 需要传入娃娃ID字段
 SDK内部会对传入数据做判空处理,如果判断传入的娃娃ID为空会直接回调失败block并返回
 @param wid 娃娃id
 @param block 回调
 */
- (void)requestWawaInfo:(NSInteger)wid complete:(void(^)(BOOL success,NSInteger code,WwWaWaDetailInfo * waInfo))block;

/**
 查询房间最近抓中记录
 @param rid 房间ID
 @param page 请求第几页数据
 @param block 回调
 */
- (void)requestLatestRecordInRoom:(NSInteger)rid
                         atPage:(NSInteger)page
                       complete:(void(^)(BOOL success,NSInteger code, NSArray<WwRoomRecordInfo *> *list))block;

/*
 * 观众列表获取, 需要传入房间ID, 页数
 * SDK内部会对传入数据进行判空处理,如果判断传入的房间ID为空会直接回调失败block并返回
 * 必要字段有: ID
 */
- (void)requestAudienceListWithRoomID:(NSInteger)ID page:(NSInteger)page complete:(void(^)(BOOL success,NSInteger code,NSArray <WwUserModel *>* waInfo))block;

/*
 * 发送弹幕, 需要传入要发送的字符串
 * SDK内部会对传入的数据进行判空处理,如果判断传入的参数不为NSString类型或为nil或长度为空,会直接返回
 */
- (void)sendDamuMsg:(NSString *)msg;

/*
 * 上机请求, 需要传入房间ID
 * 特别注意: 在调用此接口前, 请确保用户信息已经注入到SDK用户信息回调中, 否则上机操作会直接失败
 * SDK内部会对传入数据进行判空处理,如果判断传入的房间ID为空会直接回调失败block并返回
 */
- (void)requestOnBoard:(NSInteger)ID complete:(void(^)(BOOL success,NSInteger code,NSString * msg,NSString * orderID))block;

/*
 * 快速上机请求, 无需传入参数, 会根据当前的机器空闲情况自动为用户分配可使用的机器
 * 特别注意: 在调用此接口前, 请确保用户信息已经注入到SDK用户信息回调中, 否则上机操作会直接失败
 */
- (void)requestQuickOnBoardWithComplete:(void(^)(BOOL success,NSInteger code,NSString * msg,WwRoomModel * room))block;

/*
 * 切换摄像头
 * 参数说明 isMaster:是否要切换到正面摄像头, 传入YES会切换到正面摄像头, 传入NO则会切换到侧面摄像头
 */
- (void)cameraSwitchIsFront:(BOOL)isFront;

/*
 * 游戏操作, 上下左右操作
 */
- (void)requestOperation:(PlayDirection)direction operationType:(PlayOperationType)operationType complete:(void(^)(BOOL success,NSInteger code,NSString * msg))block;

/*
 * 游戏操作, 下爪操作
 * 注: 下爪操作涉及到硬件上的判断娃娃到底有没有抓到, 所以结果回调需要相对较长的时间
 * 参数说明: 要不要强制释放上机锁定(例如:用户点击了下爪之后,在结果回来之前就离开了房间,就放弃了再来一局的机会,需要传入YES来释放等待用户8s选择是否再来一局的必要)
 */
- (void)requestClawWithForceRelease:(BOOL)forceRelease complete:(void(^)(BOOL requestSuccess, NSInteger code,WwGameResultModel * resultM))block;


/**
 请求回放中 游戏操作信息

 @param rid 房间id
 @param time 游戏开始时间， s秒 级别
 @param aPiece 第几片数据 从1开始，1片30s
 
 @discuss
 [
     {
         "data":{
             "type":"BINARY",
             "value":"[{"roomId":243,"time":1510932223761,"msgType":1,"data":"eyJpZCI6MjQzLCJ0b2tlbiI6IjIwMTcxMTE3MjMyMzQzMzc4NDU4OTM5MDEwMDAiLCJkYXRhIjp7ImNvbmZpAVTI6eyJkdXJhdGlvbiI6MzAsImYxIjo0MCwiZjIiOjIwLCJmMyI6OCwiZjQiOjEwLCJzMSI6NywiczIiOjcsInMzIjo4LCJwb3MiOjAsIm1hIjoyMH19LCJhY3Rpb24iOiJzdGFydCJ9"}]"
         },
         "msgTime":1510932223760
     },
     {
         "data":{
         "type":"BINARY",
         "value":"[{"roomId":243,"time":1510932224430,"msgType":1,"data":"eyJpZCI6MjQzLCJ0b2tlbiI6IjIwMTcxMTE3MjMyMzQzMzc4NDU4OTM5MDEwMDAiLCJzAVTEiOjAsImRhdGEiOnsiaW5kAVTgiOjMsImRpcmVjdGlvbiI6M30sImFjdGlvbiI6InJvY2tlcl9zdGFydCJ9"}]"
         },
         "msgTime":1510932224430
     }
 ]
 
 data
     type: 暂无定义
     value中：
        time 可能和 msgTime 有ms级误差。直接使用msgTime
        msgType ：1操作消息 2弹幕消息
        data：消息的具体内容，需要进行base_64解码
 
 msgTime ：消息发生的绝对时间 ms 毫秒 级别
 
 
 value 中 data 数据 base64 解码后
 {
     "id":243,
     "token":"2017111723234337845893901000",
     "data":{
         "config":{
             "duration":30,
             "f1":40,
             "f2":20,
             "f3":8,
             "f4":10,
             "s1":7,
             "s2":7,
             "s3":8,
             "pos":0,
             "ma":20
        }
    },
    "action":"start"
 }
 
 action说明:
     rocker_click: 摇杆点击
     rocker_start: 摇杆按住
     rocker_stop: 摇杆抬起
     rocker_reverse:  摇杆撤销  按点击处理
     direction :代表方向  0上 1下 2左 3右 4下爪
 
 */
- (void)requestReplayVideoMessageInRoom:(NSInteger)rid startTime:(NSTimeInterval)time piece:(NSInteger)aPiece complete:(void(^)(BOOL requestSuccess, NSInteger code,NSArray <NSDictionary *> *list))block;

#pragma mark - Tool

/*
 * 工具接口: 获取当前的服务器时间
 * 说明: 此接口用于分享游戏的时候获取服务器时间戳, 用于前端获取分享时间点, 进而获取分享时间点前后的游戏视频流
 */
- (void)requestSDKServerTime:(void(^)(NSTimeInterval))block;

/*
 * 工具接口: ping游戏服务器
 * 说明: 此接口用于ping游戏服务器, 来观察延迟用于提示用户是否可以上机, 默认不会开启的
 */
- (void)enablePing:(BOOL)enable;

@end
