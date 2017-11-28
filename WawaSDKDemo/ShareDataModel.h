//
//  ShareDataModel.h
//  WawaSDKDemo
//
//  Created by 刘昊 on 2017/11/28.
//  Copyright © 2017年 GrayLocus. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShareDataModel : NSObject

+ (instancetype)shareDataModel;

@property (nonatomic, assign) NSInteger curRoomID;                      /**< 当前的房间ID*/

@property (nonatomic, strong) WwRoomModel * curRoomM;                   /**< 当前房间*/

@end
