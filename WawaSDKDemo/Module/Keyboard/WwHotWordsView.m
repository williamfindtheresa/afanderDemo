//
//  WwHotWordsView.m
//

#import "WwHotWordsView.h"
#import "WwHotWordsCell.h"

#import "WwMessageBar.h"

@interface WwHotWordsView () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UIView *hSpeView;

@property (nonatomic, strong) UICollectionView *hotsCollectionView;

@property (nonatomic, strong) NSMutableArray<NSString *> *hots;

@end

@implementation WwHotWordsView

- (void)dealloc
{
    NSLog(@"%s",__func__);
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.hots = [NSMutableArray array];
        [self.hots addObjectsFromArray:@[@"123",@"hahha",@"666"]];
        [self customUI];
    }
    return self;
}

#pragma mark - Layout
- (void)customUI
{
    self.backgroundColor = WwColorGen(@"#fafafa");
    [self hotsCollectionView];
    [self.hotsCollectionView reloadData];
    
    [self hSpeView];
}


#pragma mark - UICollectionViewDelegate UICollectionViewDataSource

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.hots.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    WwHotWordsCell * cell  = [collectionView dequeueReusableCellWithReuseIdentifier:WwHotWordsViewCellID forIndexPath:indexPath];
    
    NSString *word = [self.hots safeObjectAtIndex:indexPath.row];
    [cell loadWithData:word];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    //选择了热词，发热词
    NSString *word = [self.hots safeObjectAtIndex:indexPath.row];
    if (word) {
        [self.bar hotwordClick:word];
    }
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //hei 30, width +30
    NSString *word = [self.hots safeObjectAtIndex:indexPath.row];
    
    CGSize size = [word sizeWithFont:font(17) andMaxSize:CGSizeMake(ScreenWidth, 30)];
    size.width += 24;
    size.height = 28;
    return size;
}


#pragma mark - Getter Setter
- (UICollectionView *)hotsCollectionView
{
    if (!_hotsCollectionView) {
        
        UICollectionViewFlowLayout *flowlayout = [[UICollectionViewFlowLayout alloc] init];
        flowlayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        
        flowlayout.minimumLineSpacing = 12;
        flowlayout.minimumInteritemSpacing = 16;
        
        flowlayout.sectionInset = UIEdgeInsetsMake(15, 10, 10, 10);
        
        _hotsCollectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:flowlayout];
 
        [self addSubview:_hotsCollectionView];
        _hotsCollectionView.backgroundColor = [UIColor clearColor];
        
        [_hotsCollectionView registerClass:[WwHotWordsCell class] forCellWithReuseIdentifier:WwHotWordsViewCellID];
        
        _hotsCollectionView.showsHorizontalScrollIndicator = NO;
        _hotsCollectionView.showsVerticalScrollIndicator = NO;
        
        _hotsCollectionView.delegate = self;
        _hotsCollectionView.dataSource = self;
        
        [_hotsCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
    }
    return _hotsCollectionView;
}

- (UIView *)hSpeView
{
    if (!_hSpeView) {
        _hSpeView = [[UIView alloc] init];
        [self addSubview:_hSpeView];
        _hSpeView.backgroundColor = WwColorGen(@"#aeaeae");
        [_hSpeView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self);
            make.height.equalTo(@(1));
            make.top.equalTo(self);
        }];
    }
    return _hSpeView;
}

@end
