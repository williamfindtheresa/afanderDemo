//
//  WwWawaRecordListModel.h
//  F_Sky
//


#import <Foundation/Foundation.h>

@class WwWawaRecordListTableViewController, WwWawaRecordInfo;

@interface WwWawaRecordListModel : NSObject

@property (nonatomic, strong) NSMutableArray <WwWawaRecordInfo *> *dataSouce;
@property (nonatomic, weak) WwWawaRecordListTableViewController *ownerVC;
//每次请求增加的数据
@property (nonatomic, strong) NSMutableArray <WwWawaRecordInfo *> *addedArr;

//上一次 page1 的时候请求的时间
@property(nonatomic,strong)NSDate *lastFirstPageTime;

@property (nonatomic, assign) NSInteger responseCode; //当前请求code

- (void)fetchData; /**< 第1次进入*/

- (void)refreshData; /**< 下拉刷新第1页数据*/

- (void)fetchMore;  /**< 获取下一页的数据*/


//15s 刷新一次数据，
- (void)startTimer;
- (void)stopTimer;

@end
