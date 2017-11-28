//
//  WwAudienceStudioView.m
//

#import "WwAudienceStudioView.h"
#import "NSTimer+EOCBlocksSupport.h"
#import "HandleAudienceRankModel.h"

//一页默认的人数
#define kDefaultNumberOfOnePage 20

@interface WwAudienceStudioView()<UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic, strong) UICollectionView * collectV;                      /**< 观众列表*/

@property (nonatomic, assign) NSInteger itemCount;                              /**< 总数*/

@property (nonatomic, strong) NSTimer * toHeaderTimer;                          /**< 滑动到最左侧定时器*/

@property (nonatomic, strong) NSTimer * requestTimer;                           /**< 数据请求定时器*/

@property (nonatomic, strong) NSMutableArray * audienceMarr;                    /**< 数据*/

@property (nonatomic, assign) NSInteger page;                                   /**< 页码*/

@end

@implementation WwAudienceStudioView

- (void)dealloc {
    [self endRequestTimer];
}

#pragma mark - Public
+ (instancetype)zyAudienceView {
    WwAudienceStudioView * audienceV = [[WwAudienceStudioView alloc] init];
    [audienceV customUI];
    return audienceV;
}

- (void)firstRequest {
    [self featchWithIsRefresh:YES needSort:NO];
    [self startRequestTimer];
}

#pragma mark - Private
- (void)customUI {
    // 添加瀑布流视图
    [self addSubview:self.collectV];
    // 添加约束
    [self customContraint];
}

- (void)customContraint {
    @weakify(self);
    [self.collectV mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.width.mas_equalTo(self);
        make.height.mas_equalTo(self);
        make.center.mas_equalTo(self);
    }];
}

// 开启滑动到头部定时器
- (void)startToHeaderTimer {
    @weakify(self);
    self.toHeaderTimer = [NSTimer eoc_scheduledTimerWithTimeInterval:6 block:^{
        @strongify(self);
        [self.collectV scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
        [self featchWithIsRefresh:YES needSort:YES];
        [self startRequestTimer];
    } repeats:NO];
}

// 结束滑动到头部定时器
- (void)endToHeaderTimer {
    if ([self.toHeaderTimer isValid]) {
        [self.toHeaderTimer invalidate];
    }
    self.toHeaderTimer = nil;
}

// 开启数据请求定时器
- (void)startRequestTimer {
    @weakify(self);
    self.requestTimer = [NSTimer eoc_scheduledTimerWithTimeInterval:10 block:^{
        @strongify(self);
        [self featchWithIsRefresh:YES needSort:YES];
    } repeats:YES];
}

// 结束数据请求定时器
- (void)endRequestTimer {
    if ([self.requestTimer isValid]) {
        [self.requestTimer invalidate];
    }
    self.requestTimer = nil;
}


#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
//    NSLog(@"CollectionView GetItems %ld",(long)self.itemCount);
    return self.itemCount;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(kCellWidth,kCellWidth);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    WwAudienceCell * cell = [collectionView  dequeueReusableCellWithReuseIdentifier:@"WwAudienceCell" forIndexPath:indexPath];
    cell.tag = indexPath.row+1001;

    WwUserModel *user = [self.audienceMarr safeObjectAtIndex:indexPath.row];
    cell.user = user;
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    // 正在滑动 判断是否加载更多
    if (self.audienceMarr.count <= 10) {
        return;
    }
    if (indexPath.row == (self.audienceMarr.count - 5)) {
        [self featchWithIsRefresh:NO needSort:NO];
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    WwUserModel *user = [self.audienceMarr safeObjectAtIndex:indexPath.row];
    if ([self.delegate respondsToSelector:@selector(audienceDidSelect:)]) {
        [self.delegate audienceDidSelect:user];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (self.collectV.contentOffset.x == 0) {
        if (self.audienceMarr.count >= 21) {
            NSInteger len =self.audienceMarr.count - 20;
            NSRange range = NSMakeRange(20, len);
            [self.audienceMarr removeObjectsInRange:range];
            self.itemCount = self.audienceMarr.count;
            [self.collectV reloadData];
            
            [self featchWithIsRefresh:YES needSort:YES];
        }
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self endRequestTimer];
    [self endToHeaderTimer];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self startToHeaderTimer];
}

#pragma mark - SetterAndGetter
- (UICollectionView *)collectV {
    if (!_collectV) {
        UICollectionViewFlowLayout * flowlayout = [[UICollectionViewFlowLayout alloc] init];
        flowlayout.itemSize = (CGSize){kCellWidth,kCellWidth};
        flowlayout.minimumLineSpacing = 5;
        flowlayout.minimumInteritemSpacing = 1;
        [flowlayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        
        _collectV = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, 100, kCellWidth) collectionViewLayout:flowlayout];
        _collectV.dataSource = self;
        _collectV.delegate = self;
        _collectV.backgroundView = nil;
        _collectV.backgroundColor = [UIColor clearColor];
        _collectV.showsHorizontalScrollIndicator = NO;
        [_collectV registerClass:[WwAudienceCell class] forCellWithReuseIdentifier:@"WwAudienceCell"];
    }
    return _collectV;
}

- (NSMutableArray *)audienceMarr {
    if (!_audienceMarr) {
        _audienceMarr = [NSMutableArray array];
    }
    return _audienceMarr;
}

#pragma mark - RequestAndDataHandle
- (void)featchWithIsRefresh:(BOOL)refresh needSort:(BOOL)needSort {
    if (refresh) {
        self.page = 1;
    } else {
        self.page ++;
    }
    NSInteger featchPage = self.page;
    [[WawaSDK WawaSDKInstance].gameMgr requestAudienceListWithRoomID:self.roomID page:featchPage complete:^(BOOL success, NSInteger code, NSArray<WwUserModel *> *waInfo) {
        
        if (code == WwErrorCodeSuccess) {
            // 不需要排序的话第一页直接加载
            if (featchPage == 1 && !needSort) {
                [self.audienceMarr removeAllObjects];
            }
            NSArray *kvArr = [WwUserModel mj_keyValuesArrayWithObjectArray:waInfo];
            NSMutableArray * mUsers = [NSMutableArray array];
            if ([kvArr isKindOfClass:[NSArray class]]) {
                mUsers = [WwUserModel mj_objectArrayWithKeyValuesArray:kvArr];
            }
            self.page = featchPage;
            
            
            if (featchPage > 1 || !needSort) {
                // 除了第一页的或是不需要排序的都是直接添加
                [self addAndReloadWith:mUsers];
            }
            else {
                // 需要排序的
                [self sortAndHandleData:mUsers];
            }
            
            // 通知外界,观众列表请求完成, 一共有多少人
            if ([self.delegate respondsToSelector:@selector(updateAudienceCount:)]) {
                [self.delegate updateAudienceCount:self.audienceMarr.count];
            }
        }
        else {
            if (featchPage > 1) {
                self.page = featchPage - 1;
            } else {
                self.page = 1;
            }
            
        }
    }];
}

- (void)addAndReloadWith:(NSArray *)arr {
    safe_async_main(^{
        NSMutableSet * mSet = [self uidsWithArray:self.audienceMarr];
        for (WwUserModel * user in arr) {
            if (![mSet containsObject:@(user.uid)]) {
                [self.audienceMarr addObject:user];
            }
        }
        self.itemCount = self.audienceMarr.count;
        [self.collectV reloadData];
    });
}

- (void)addFailetureFreshMe //失败刷新自己
{
    safe_async_main(^{
        
        if ([self array:self.audienceMarr containUid:kZXUid]) {
            return;
        }
        if (kZXUserInfo) {
            [self.audienceMarr insertObject:kZXUserInfo atIndex:0];
            self.itemCount = self.audienceMarr.count;
            [self.collectV reloadData];
        }
    });
}

- (void)sortAndHandleData:(NSMutableArray *)arr {
    // 只处理和传入的数组长度相同的数组
    safe_async_main(^{
        NSArray * handleList = [self rankModelByList:self.audienceMarr toDesireList:arr];
        @weakify(self);
        [handleList  enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            @strongify(self);
            HandleAudienceRankModel * model = obj;
            [self.collectV performBatchUpdates:^{
                @strongify(self);
                WwUserModel * user  = [model user];
                NSInteger rank = [model rank];
                [self zx_loadSocketData:user withRank:rank];
            } completion:nil];
        }];
    });
}

/*!
 Note: 3.0 之后，观众列表请求数据逻辑由socket 改为 纯 http请求
 1 10s 刷新一次 前20个
 2 对其中的变化 便利处理，之后 对origin数据，做删除处理
 a 0.2s 当做处理处理socket一次（现在没有必要了），在2步完成之后，处理一次 。
 b 滑动之后， 停留10s之后，回到index0 头部
 c。 考虑一个问题：如果客户端，再根据socket 来了消息，再次校准。 这个问题要做，a是有必要了
 1) 关注有一个 5s 的展示时间，5s之后，关注按钮动画收回
 
 
 eg: ABCDEF  :orgin
 10s之后      :desireList
 
 1> 0A0B00D0E0F
 2> A0B0C0D0E0F0
 3> AB0CD0EF
 4> 000000000000
 5> DF000000000
 6> 0000000A0B00
 7> BACD //送礼变化 现在不加入，
 
 以上7种可能考虑了全部情形；
 一个重要情景是，如果<20个（一页默认数量），有删除；其他是往后移动，非delete；delete时机是 往后翻动 回滚head时候
 */
- (NSArray<HandleAudienceRankModel *> *)rankModelByList:(NSArray<WwUserModel *> *)originUserList toDesireList:(NSArray<WwUserModel *> *)desireList
{
    NSMutableArray * mHandle = [@[] mutableCopy];
    NSMutableArray * origin = [NSMutableArray arrayWithArray:originUserList];
    //1 对desirelist 遍历一次
    WwUserModel * duser;
    WwUserModel * ouser;
    NSInteger olen = originUserList.count;
    for (int d = 0; d < desireList.count; d++) {
        HandleAudienceRankModel * hModel = [HandleAudienceRankModel new];
        duser = desireList[d];
        if (d >= olen) {
            hModel.user = desireList[d];
            hModel.rank = d; // maybe move or insert
            [mHandle addObject:hModel];
            continue;
        }
        ouser = origin[d];
        if (duser.uid == ouser.uid) {
            
        }
        else{
            hModel.user = desireList[d];
            hModel.rank = d;
            [origin insertObject:duser atIndex:d];
            [mHandle addObject:hModel]; // maybe move or insert
        }
    }
    
    // 删除originUserList 中，不在 desireList 中的 user
    NSArray * nopeats = [self checkforOriginList:desireList NoRepitive:originUserList withIndex:2];
    for (WwUserModel * deleteUsr  in nopeats) {
        HandleAudienceRankModel * hModel = [HandleAudienceRankModel new];
        hModel.user = deleteUsr;
        hModel.rank = -1;
        [mHandle addObject:hModel];
    }
    return mHandle;
}

#pragma mark - 刷新 观众列表
- (void)zx_loadSocketData:(WwUserModel *)user withRank:(NSInteger)rank
{
    NSArray * data = self.audienceMarr;
    // 删除
    if (rank == -1) {
        NSInteger row = self.audienceMarr.count + 1;
        for (WwUserModel * duser in data) {
            if (duser.uid == user.uid) {
                row = [self.audienceMarr indexOfObject:duser];
                break;
            }
        }
        if (row < self.audienceMarr.count) {
            
            [self.audienceMarr removeObjectAtIndex:row];
            self.itemCount = self.audienceMarr.count;
            [self.collectV deleteItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:row inSection:0]]];
        }
    }
    else{
        BOOL contain = NO;
        int idx2 = 0;
        WwUserModel * duser;
        
        for (int i=0; i<data.count; ++i) {
            duser = data[i];
            if (duser.uid == user.uid) {
                contain = YES;
                idx2 = i;
                break;
            }
        }
        if (contain) {
            if (rank != idx2) {
                [self.audienceMarr removeObjectAtIndex:idx2];
                self.itemCount = self.audienceMarr.count;
                
                if (rank > self.audienceMarr.count) {
                    [self.collectV deleteItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:idx2 inSection:0]]];
                    [self.audienceMarr addObject:user];
                    self.itemCount = self.audienceMarr.count;
                    [self.collectV insertItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:self.itemCount - 1 inSection:0]]];
                }
                else{
                    [self.audienceMarr insertObject:user atIndex:rank];
                    self.itemCount = self.audienceMarr.count;
                    NSIndexPath * sindex = [NSIndexPath indexPathForRow:idx2 inSection:0];
                    NSIndexPath * tindex = [NSIndexPath indexPathForRow:rank inSection:0];
                    
                    [self.collectV moveItemAtIndexPath:sindex toIndexPath:tindex];
                }
            }
            else {
                //如果相等，就刷新本itme。 头等舱需要
                self.itemCount = self.audienceMarr.count;
                NSIndexPath *index = [NSIndexPath indexPathForRow:idx2 inSection:0];
                [self.collectV reloadItemsAtIndexPaths:@[index]];
                NSLog(@"firstclass - equeue rank %zi user %@",idx2,user);
            }
        }
        else {
            if (rank > self.audienceMarr.count) {
                [self.audienceMarr addObject:user];
                self.itemCount = self.audienceMarr.count;
                NSIndexPath * tindex = [NSIndexPath indexPathForRow:self.itemCount-1 inSection:0];
                [self.collectV insertItemsAtIndexPaths:@[tindex]];
            }
            else {
                [self.audienceMarr  insertObject:user atIndex:rank];
                self.itemCount = self.audienceMarr.count;
                NSIndexPath * tindex = [NSIndexPath indexPathForRow:rank inSection:0];
                [self.collectV insertItemsAtIndexPaths:@[tindex]];
            }
        }
    }
}


- (BOOL)array:(NSArray<WwUserModel *> *)arr containUid:(NSInteger)uid
{
    __block BOOL container = NO;
    [arr enumerateObjectsUsingBlock:^(WwUserModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.uid == uid) {
            
            container = YES;
            *stop = YES;
        }
    }];
    return container;
}

#pragma mark  第一页列表数据排序
- (NSArray<WwUserModel *> *)sortList:(NSArray<WwUserModel *> *)userList
{
    //我们认为服务端数据数据顺序不可信，对list 顺序自己排一次。 按照经验 、uid 降
    NSSortDescriptor * level = [NSSortDescriptor sortDescriptorWithKey:@"level" ascending:NO];
    NSSortDescriptor * exp = [NSSortDescriptor sortDescriptorWithKey:@"exp" ascending:NO];
    NSSortDescriptor * uid = [NSSortDescriptor sortDescriptorWithKey:@"uid" ascending:NO];
    return [userList sortedArrayUsingDescriptors:@[level,exp,uid]];
}

#pragma mark - 直播间观众列表 去除重复后的数据
- (NSArray<WwUserModel *> *)checkforOriginList:(NSArray<WwUserModel *> *)originList NoRepitive:(NSArray<WwUserModel *> *)list withIndex:(NSInteger)pageIndex{
    if (pageIndex != 1) {
        NSArray * da = originList; //列表数据
        NSMutableArray * mu = [NSMutableArray arrayWithArray:list]; // 新数据
        WwUserModel * muser;
        BOOL findRepeat = NO;
        for (int i=0 ; i<mu.count;) { //遍历新数据
            muser = mu[i];
            findRepeat = NO;
            for (WwUserModel * user in da) {
                if ([muser  uid] == user.uid) {
                    [mu removeObject:muser];
                    findRepeat = YES;
                    break;
                }
            }
            if (!findRepeat) {
                i++;
            }
        }
        return mu;
    }
    return list;
}

#pragma mark - DataHelper
- (NSMutableSet *)uidsWithArray:(NSArray <WwUserModel *>*)array {
    NSMutableSet * mSet = [NSMutableSet setWithCapacity:array.count];
    for (WwUserModel * user in self.audienceMarr) {
        if ([user isKindOfClass:[WwUserModel class]]) {
            [mSet addObject:@(user.uid)];
        }
    }
    return mSet;
}


- (void)setRoomID:(NSInteger)roomID
{
    _roomID = roomID;
    [self firstRequest];
}

@end



