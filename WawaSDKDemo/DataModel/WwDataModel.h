//
//  WwDataModel.h
//  WawaSDKDemo
//

#import <Foundation/Foundation.h>


OBJC_EXPORT NSString *const kWwDataModelFetchResult;

@class WwDataModel;

@protocol WwDataModelDelegate <NSObject>

/**
 * DataModel 刷新结果通知
 */
- (void)onDataModelRefresh:(WwDataModel *)dataModel;

/**
 * DataModel 翻页结果通知
 */
- (void)onDataModelFetchMore:(WwDataModel *)dataModel;

@end

@interface WwDataModel : NSObject
@property (nonatomic, weak) id<WwDataModelDelegate> delegate;
@property (nonatomic, strong) NSMutableArray *list;
@property (nonatomic, assign) id fetchResult; //当前请求结果
@property (nonatomic, readonly) NSArray *addPageObjects; //每次请求结果数据

/**
 * 下拉刷新第1页数据
 */
- (void)refreshData;

/**
 * 获取下一页的数据
 */
- (void)fetchMore;


/**
 * 当前数据列表数目
 */
- (NSInteger)count;


/**
 * 获取相应index位置数据
 */
- (id)objectAtIndex:(NSUInteger)index;


/**
 * 请求数据的方法

 @param pageIndex 请求数据页数
 @param isRefresh 刷新 or 翻页
 */
- (void)fetchListAtPageIndex:(NSInteger)pageIndex isRefresh:(BOOL)isRefresh;

/**
 子类需要实现此方法

 @param pageIndex 请求数据页数
 @param isRefresh 刷新 or 翻页
 @param complete 请求结果的回调
 */
- (void)asyncFetchListAtPage:(NSInteger)pageIndex isRefresh:(BOOL)isRefresh withComplete:(void (^)(BOOL isSuccess, NSArray *listArray, NSInteger count, long long totalCount))complete;
@end
