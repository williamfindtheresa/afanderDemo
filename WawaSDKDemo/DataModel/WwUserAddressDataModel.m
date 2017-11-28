//
//  WwUserAddressDataModel.m
//  WawaSDKDemo
//

#import <WawaSDK/WawaSDK.h>
#import "WwUserAddressDataModel.h"

@implementation WwUserAddressDataModel

- (void)asyncFetchListAtPage:(NSInteger)pageIndex isRefresh:(BOOL)isRefresh withComplete:(void (^)(BOOL, NSArray *, NSInteger, long long))complete {
    // 获取最新地址
    [[WwUserInfoManager UserInfoMgrInstance] requestUserAddressWithCompleteHandler:^(int code, NSString *message, NSArray<WwAddressModel *> *list) {
        if (!code) {
            if (complete) {
                complete(YES, list, list.count, NSIntegerMax);
            }
        }
        else {
            if (complete) {
                complete(NO, nil, 0, 0);
            }
        }
        [self setValue:@(code) forKey:kWwDataModelFetchResult];
    }];
}

@end
