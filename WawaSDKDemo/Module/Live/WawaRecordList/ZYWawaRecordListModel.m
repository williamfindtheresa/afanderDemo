//
//  ZYWawaRecordListModel.m
//

#import "ZYWawaRecordListModel.h"
#import "ZYWawaRecordListTableViewController.h"
#import <WawaSDK/WawaSDK.h>


@interface ZYWawaRecordListModel ()

@property (nonatomic, assign) BOOL hasMore; //是否可以有更多数据

@property (nonatomic, assign) NSInteger pageIndex; //默认从1开始
@property (nonatomic, assign) NSInteger curFetchIndex;  //当前fetch


@end

@implementation ZYWawaRecordListModel

- (void)fetchDataPage:(NSInteger)page
{
//    NSArray<ZYWawaRecordInfo *> *recommon = [ZYWawaRecordInfo mj_objectArrayWithKeyValuesArray:response.data[@"list"]];
//
//    if ([recommon isKindOfClass:[NSArray class]]) {
//        self.dataSouce = recommon;
//        [self.ownerVC wawaRecordListData:self];
//    }
    [[WwGameManager GameMgrInstance] requestLatestRecordInRoom:self.ownerVC.roomID atPage:page complete:^(BOOL success, NSInteger code, NSArray<WwRoomRecordInfo *> *list) {
        if ([list isKindOfClass:[NSArray class]]) {
            self.dataSouce = [NSMutableArray arrayWithArray:list];
            [self.ownerVC wawaRecordListData:self];
        }
    }];
}


- (id)init
{
    self = [super init];
    if (self) {
        _pageIndex = 1;
        _curFetchIndex = 1;
    }
    return self;
}

- (void)dealloc
{
    NSLog(@"%s",__func__);
}

#pragma mark - Public
- (void)fetchData
{
    [self resetData];
    [self fetchListAtPageIndex:_pageIndex isRefresh:YES];
}

- (void)refreshData //下拉刷新第1页数据
{
    [self resetData];
    [self fetchListAtPageIndex:_pageIndex isRefresh:YES];
}

- (void)fetchMore //获取下一页的数据
{
    if (self.hasMore) {
        _pageIndex += 1;  //多次请求，直接可以过滤掉了
        [self fetchListAtPageIndex:_pageIndex isRefresh:NO];
    }
}

- (void)resetData
{
    _pageIndex = 1;
    _curFetchIndex = 1;
    _hasMore = NO;
}


/**
 请求结果数据
 
 @param aPageIndex index
 @param aIsRefresh 是否是刷新
 */
- (void)fetchListAtPageIndex:(NSInteger)aPageIndex isRefresh:(BOOL)aIsRefresh
{
    if (labs(aPageIndex - _curFetchIndex ) > 1) {
        return;
    }
    
    [[WwGameManager GameMgrInstance] requestLatestRecordInRoom:self.ownerVC.roomID
                                                        atPage:aPageIndex
                                                      complete:^(BOOL success, NSInteger code, NSArray<WwRoomRecordInfo *> *list) {
                                                          if ([list isKindOfClass:[NSArray class]]) {
                                                              self.dataSouce = [NSMutableArray arrayWithArray:list];
                                                              [self.ownerVC wawaRecordListData:self];
                                                              if (aIsRefresh) {
                                                                  self.dataSouce = [NSMutableArray arrayWithArray:list];
                                                              } else {
                                                                   [self.dataSouce addObjectsFromArray:list];
                                                                   self.addedArr = [NSMutableArray arrayWithArray:list];
                                                              }
                                                          }
                                                      }];
    
    
//         self.responseCode = response.code;
//
//         self.addedArr = nil;
//
//         //首页推荐
//         if (response.code != 0) {
//
//             if (aIsRefresh == NO) {
//                 self.pageIndex = self.curFetchIndex;
//             }
//             else {
//                 self.pageIndex = aPageIndex;
//             }
//
//         }
//         else {
//
//             NSMutableArray <ZYWawaRecordInfo *> *recommon = [ZYWawaRecordInfo mj_objectArrayWithKeyValuesArray:response.data[@"list"]];
//
//             if (recommon.count > 0) {
//                 self.hasMore = YES;
//
//                 self.pageIndex = aPageIndex;
//                 self.curFetchIndex = aPageIndex;
//             }
//             else {
//                 self.hasMore = NO;
//                 if (aIsRefresh == NO) {
//                     //下拉加载更多
//                     self.pageIndex -= 1;
//                 }
//             }
//
//             if ([recommon isKindOfClass:[NSArray class]]) {
//                 [recommon enumerateObjectsUsingBlock:^(ZYWawaRecordInfo * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//
//                 }];
//             }
//
//             if (aIsRefresh) {
//                 self.dataSouce = recommon;
//             }
//             else {
//                 [self.dataSouce addObjectsFromArray:recommon];
//                 self.addedArr = recommon;
//             }
//         }
//
//         if (aIsRefresh) {
//             [self.ownerVC dataChange:self];
//         }
//         else {
//             [self.ownerVC dataFetchMoreChange:self];
//         }
    
}

@end
