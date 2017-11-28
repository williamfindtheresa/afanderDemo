//
//  WwWawaParticularsModel.m
//  prizeClaw
//


#import "WwWawaParticularsModel.h"
#import "WwWawaParticularsTableViewController.h"
#import "WwWawaParticularsInfo.h"

@implementation WwWawaParticularsModel

- (void)fetchDataWithWawaId:(NSInteger)wawaId
{
    [[WwGameManager GameMgrInstance] requestWawaInfo:wawaId complete:^(BOOL success, NSInteger code, WwWaWaDetailInfo *waInfo) {
        //首页推荐
        if (!success) {
            return;
        }
        NSDictionary *kv = [waInfo mj_JSONObject];
        WwWawaParticularsInfo *info = [WwWawaParticularsInfo mj_objectWithKeyValues:kv];
        NSArray<WwWawaParticularsInfo *> *recommon = @[info];
        
        if ([recommon isKindOfClass:[NSArray class]]) {
            self.dataSouce = recommon;
            [self.ownerVC  wawaParticularsData:self];
        }
    }];
}
@end
