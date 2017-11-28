//
//  WwLocalPcasCodeManager.h
//  F_Sky
//

#import <Foundation/Foundation.h>
#import "WwAddressDataDef.h"

@interface WwLocalPcasCodeManager : NSObject

@property (nonatomic, strong, readonly) NSMutableArray * pcasMarr;        /**< 数据*/

+ (instancetype)shareManager;

- (void)recodeDataFromLocalJson;

@end
