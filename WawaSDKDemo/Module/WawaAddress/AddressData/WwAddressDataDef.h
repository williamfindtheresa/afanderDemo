//
//  WwAddressDataDef.h
//  F_Sky
//

#import <Foundation/Foundation.h>

/**
 * 地址标识元数据
 */
@interface WwAddressMetaItem : NSObject
@property (nonatomic, strong) NSString * code;  /**< 标识码*/
@property (nonatomic, strong) NSString * name;  /**< 名称*/
@end


/**
 * 区域数据
 */
@interface WwAddressAreaItem : WwAddressMetaItem

@end


/**
 * 城市数据
 */
@interface WwAddressCityItem : WwAddressMetaItem
@property (nonatomic, strong) NSMutableArray <WwAddressAreaItem *> * childs; /**< 下属区域数组*/
@end


/**
 * 省份数据
 */
@interface WwAddressProvinceItem : WwAddressMetaItem
@property (nonatomic, strong) NSMutableArray <WwAddressCityItem *>* childs;  /**< 城市列表*/
@end
