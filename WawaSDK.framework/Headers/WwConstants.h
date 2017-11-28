//
//  WwConstants.h
//  WawaSDK
//
//  Copyright © 2017年 杭州庆余年网络科技有限公司 All rights reserved.
//

#ifndef WwConstants_h
#define WwConstants_h


typedef NS_ENUM(NSInteger, UserInfoError) {
    UserInfoError_Unknown = -1,     // 未知
    UserInfoError_Unlogin = 0,      // 未登录
    UserInfoError_NotEnoughRich,    // 财富信息不足
};

static const NSString *WwCodeInCheckingStr = @"SDK正在进行安全性检查";


#endif /* WwConstants_h */
