//
//  HandleAudienceRankModel.h
//  prizeClaw
//
//  Created by 刘昊 on 2017/10/2.
//  Copyright © 2017年 QuanMin.ShouYin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HandleAudienceRankModel : NSObject

@property (nonatomic, strong) WwUserModel * user;        /**< 用户信息*/

@property (nonatomic, assign) NSInteger rank;       /**< rank，从0开始*/

@property (nonatomic, assign) NSInteger inRoom;     /**< 头等舱。1在房间 2不在房间*/
@property (nonatomic, assign) NSInteger headRank;   /**< 头等舱排名。 从1开始*/

/**< 本地mock*/
@property (nonatomic, assign) BOOL markLevelRoom; /**< 标记是不是接受到了 离开事件*/

@end
