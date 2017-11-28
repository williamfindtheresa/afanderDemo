//
//  ShareDataModel.m
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
