//
//  WwWawaParticularsModel.h
//  prizeClaw
//


#import <Foundation/Foundation.h>

@class WwWawaParticularsTableViewController;
@class WwWawaParticularsInfo;

@interface WwWawaParticularsModel : NSObject

@property (nonatomic, strong) NSArray <WwWawaParticularsInfo *> *dataSouce;

@property (nonatomic, weak) WwWawaParticularsTableViewController *ownerVC;
- (void)fetchDataWithWawaId:(NSInteger)wawaId;
@end
