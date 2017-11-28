//
//  WwGameRecordDataModel.m
//  F_Sky
//

#import <Foundation/Foundation.h>
#import "WwGameRecordDataModel.h"

@implementation WwGameRecordDataModel

- (void)asyncFetchListAtPage:(NSInteger)pageIndex isRefresh:(BOOL)isRefresh withComplete:(void (^)(BOOL, NSArray *, NSInteger, long long))complete {
    [[WwUserInfoManager UserInfoMgrInstance] requestGameRecordAtPage:pageIndex withCompleteHandler:^(int code, NSString *message, NSArray<WwGameRecordModel *> *list) {
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
