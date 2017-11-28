//
//  WwRoomListManager.h
//  WawaSDK
//
//  Copyright © 2017年 杭州庆余年网络科技有限公司 All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WwDataDef.h"

@protocol WwRoomListManagerDelegate <NSObject>

/**
 * 通知接入方客户端，当前房间列表首页数据有变化(主要是房间状态)
 */
- (void)onRoomListChange:(NSArray <WwRoomModel *> *)roomList;

@end

/**
 * WwRoomListManager是房间列表管理对象，负责:
 * 1.获取游戏房间列表
 * 2.订阅游戏房间状态
 */

@interface WwRoomListManager : NSObject

/**
 * WwRoomListManager 的代理对象
 */
@property (nonatomic, weak) id<WwRoomListManagerDelegate> delegate;

/**< 首页房间列表刷新timer间隔，默认15s，通过代理方法onRoomListChange:通知出去
 * Note: 当修改refreshInterval时，会销毁当前刷新定时器并重新创建
 */
@property (nonatomic, assign) NSTimeInterval refreshInterval;

/**
 * 获取WwRoomListManager 单例
 */
+ (instancetype)RoomListMgrInstance;

/**
 * 请求房间列表
 * @param page 请求列表页，从1开始
 * @param size 每页个数
 * @param complete 回调block: code 返回码，message 返回信息，list 返回房间数据列表
 */
- (void)requestRoomListAtPage:(NSInteger)page
                         size:(NSInteger)size
          withCompleteHandler:(void (^)(int code, NSString *message, NSArray<WwRoomModel *> *list))complete;

/**
 * 请求指定房间信息
 * @param roomIdList 房间ID列表
 * @param complete 回调block: code 返回码，message 返回信息，list 返回房间数据列表
 */
- (void)requestRoomListByIds:(NSArray <NSString *>*)roomIdList
         withCompleteHandler:(void (^)(int code, NSString *message, NSArray<WwRoomModel *> *list))complete;

/**
 * 启动首页数据刷新定时器
 * Note: 该方法首先会销毁当前刷新定时器，并根据当前refreshInterval重新创建新的刷新定时器
 */
- (void)startRefreshTimer;

/**
 * 停止首页数据刷新定时器
 * Note: 该方法会立即停止当前激活的刷新定时器
 */
- (void)stopRefreshTimer;

@end
