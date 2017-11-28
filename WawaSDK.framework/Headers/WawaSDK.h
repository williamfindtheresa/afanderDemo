//
//  WawaSDK.h
//  WawaSDK
//
//  Copyright © 2017年 杭州庆余年网络科技有限公司 All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WwUserInfoManager.h"
#import "WwRoomListManager.h"
#import "WwGameManager.h"

#import "WwErrorDef.h"
#import "WwDataDef.h"


@interface WawaSDK : NSObject

@property (nonatomic, strong, nonnull) WwUserInfoManager *userInfoMgr;
@property (nonatomic, strong, nonnull) WwRoomListManager *roomListMgr;
@property (nonatomic, strong, nonnull) WwGameManager *gameMgr;

/**
 获取SDK实例
 @return WawaSDK
 */
+ (instancetype _Nonnull)WawaSDKInstance;

/**
 设置log开关

 @param enable true 打开，false 关闭
 */
- (void)setLogEnable:(BOOL)enable;

/**
 获取SDK版本
 */
- (NSString *_Nullable)sdkVersion;


/**
 向SDK 注册appid appkey

 @param appId 商户后台注册的appid
 @param appKey 商户后台注册的appkey
 @param completeHandle 结果状态回调
 */
- (void)registerApp:(NSString *_Nonnull)appId appKey:(NSString *_Nonnull)appKey complete:(void (^ __nullable)(BOOL success, int code, NSString * __nullable message))completeHandle;

@end

