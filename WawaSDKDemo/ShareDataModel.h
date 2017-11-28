//
//  ShareDataModel.h
//

#import <Foundation/Foundation.h>

@interface ShareDataModel : NSObject

+ (instancetype)shareDataModel;

@property (nonatomic, assign) NSInteger curRoomID;                      /**< 当前的房间ID*/

@property (nonatomic, strong) WwRoomModel * curRoomM;                   /**< 当前房间*/

@end
