//
//  WwDataModel.m
//  F_Sky
//

#import "WwDataModel.h"

NSString *const kWwDataModelFetchResult = @"fetchResult";

@interface WwDataModel ()
@property (nonatomic, assign) BOOL hasMore; //是否可以有更多数据
@property (nonatomic, assign) NSInteger pageIndex; //默认从1开始
@property (nonatomic, assign) NSInteger curFetchIndex;  //当前fetch
@end

@implementation WwDataModel

- (void)dealloc {
}


- (id)init {
    self = [super init];
    if (self) {
        _pageIndex = 1;
        _curFetchIndex = 1;
    }
    return self;
}

#pragma mark - Public
- (void)refreshData
{
    [self resetData];
    [self fetchListAtPageIndex:_pageIndex isRefresh:YES];
}

- (void)fetchMore
{
    if (self.hasMore) {
        _pageIndex += 1;  //多次请求，直接可以过滤掉了
        [self fetchListAtPageIndex:_pageIndex isRefresh:NO];
    }
}

- (NSInteger)count {
    return _list.count;
}

- (id)objectAtIndex:(NSUInteger)index {
    if (index < _list.count) {
        return [_list objectAtIndex:index];
    }
    else {
        NSAssert(0, @"数据越界");
        return nil;
    }
}

- (void)resetData
{
    _pageIndex = 1;
    _curFetchIndex = 1;
    _hasMore = NO;
}

- (void)asyncFetchListAtPage:(NSInteger)pageIndex isRefresh:(BOOL)isRefresh withComplete:(void (^)(BOOL isSuccess, NSArray *listArray, NSInteger count, long long totalCount))complete
{
    NSAssert(0, @"子类需要重写该方法");
}

- (void)fetchListAtPageIndex:(NSInteger)pageIndex isRefresh:(BOOL)isRefresh
{
    if (labs(pageIndex - _curFetchIndex ) > 1) {
        return;
    }
    
    [self asyncFetchListAtPage:pageIndex isRefresh:isRefresh withComplete:^(BOOL isSuccess, NSArray *listArray, NSInteger count, long long totalCount) {
        _addPageObjects = nil;
        
        if (isSuccess) {
            if (listArray.count > 0) {
                _hasMore = YES;
                _pageIndex = pageIndex;
                _curFetchIndex = pageIndex;
            }
            else {
                _hasMore = NO;
                if (isRefresh == NO) {
                    //下拉加载更多
                    _pageIndex -= 1;
                }
            }
            
            if (isRefresh) {
                _addPageObjects = listArray;
                [self.list removeAllObjects];
                [self.list addObjectsFromArray:listArray];
            }
            else {//加载更多
                _addPageObjects = listArray;
                [self.list addObjectsFromArray:listArray];
            }
        }
        else {
            _pageIndex = isRefresh? pageIndex : _curFetchIndex;
        }
        
    
        if (isRefresh) {
            if ([self.delegate respondsToSelector:@selector(onDataModelRefresh:)]) {
                [self.delegate onDataModelRefresh:self];
            }
        }
        else {
            if ([self.delegate respondsToSelector:@selector(onDataModelFetchMore:)]) {
                [self.delegate onDataModelFetchMore:self];
            }
        }
    }];
}

#pragma mark - Getter
- (NSMutableArray *)list {
    if (!_list) {
        _list = [NSMutableArray array];
    }
    return _list;
}

@end


