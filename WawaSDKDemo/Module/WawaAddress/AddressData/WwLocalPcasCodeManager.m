//
//  WwLocalPcasCodeManager.m
//  WawaSDKDemo
//

#import "WwLocalPcasCodeManager.h"
#import "MJExtension.h"

@interface WwLocalPcasCodeManager()

@end

@implementation WwLocalPcasCodeManager

static WwLocalPcasCodeManager * pcasManager;
+ (instancetype)shareManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        pcasManager = [WwLocalPcasCodeManager new];
    });
    return pcasManager;
}

- (void)recodeDataFromLocalJson {
    NSMutableArray * dataMarr = nil;
    NSString * path = [[NSBundle mainBundle] pathForResource:@"pcascode.txt" ofType:nil];
    NSData * data = [[NSFileManager defaultManager] contentsAtPath:path];
    NSError * error;
    if (data) {
        dataMarr = [NSJSONSerialization JSONObjectWithData:data
                                                   options:kNilOptions
                                                     error:&error];
    }
    _pcasMarr = [WwAddressProvinceItem mj_objectArrayWithKeyValuesArray:dataMarr];
}

@end
