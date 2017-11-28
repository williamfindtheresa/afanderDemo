//
//  WwAddressDataDef.m
//  WawaSDKDemo
//

#import "WwAddressDataDef.h"

@implementation WwAddressMetaItem

@end

@implementation WwAddressAreaItem

@end

@implementation WwAddressCityItem

+ (NSDictionary *)mj_objectClassInArray
{
    return @{
             @"childs":[WwAddressAreaItem class]
             };
}

@end

@implementation WwAddressProvinceItem

+ (NSDictionary *)mj_objectClassInArray
{
    return @{
             @"childs":[WwAddressCityItem class]
             };
}

@end
