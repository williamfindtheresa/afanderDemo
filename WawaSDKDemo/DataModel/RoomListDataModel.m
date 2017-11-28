//
//  RoomListDataModel.m
//  F_Sky
//

#import "RoomListDataModel.h"

@implementation RoomListDataModel

- (void)asyncFetchListAtPage:(NSInteger)pageIndex isRefresh:(BOOL)isRefresh withComplete:(void (^)(BOOL, NSArray *, NSInteger, long long))complete {
    [[WwRoomListManager RoomListMgrInstance] requestRoomListAtPage:pageIndex size:5 withCompleteHandler:^(int code, NSString *message, NSArray<WwRoomModel *> *list) {
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


