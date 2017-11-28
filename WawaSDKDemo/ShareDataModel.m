//
//  ShareDataModel.m
//  WawaSDKDemo
//
//  Created by 刘昊 on 2017/11/28.
//  Copyright © 2017年 GrayLocus. All rights reserved.
//

#import "ShareDataModel.h"

@implementation ShareDataModel

static ShareDataModel * shareM;
+ (instancetype)shareDataModel {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareM = [ShareDataModel new];
    });
    return shareM;
}

@end
