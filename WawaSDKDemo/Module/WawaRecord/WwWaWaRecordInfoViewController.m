//
//  WwWaWaRecordInfoViewController.m
//  F_Sky
//


#import "WwWaWaRecordInfoViewController.h"
#import "WwWawaParticularsSuperViewController.h"
#import "WwWawaRecordListSuperViewController.h"
#import "WwWawaRecordInfoNavBar.h"
#import "WwBaseViewController.h"

@interface WwWaWaRecordInfoViewController ()<WwWawaRecordInfoNavBarDelegate,UIScrollViewDelegate>
//contentView
@property (nonatomic, strong) UIView *contentView;
//导航条
@property (nonatomic, strong) WwWawaRecordInfoNavBar *navBarView;
//UIScrollView
@property (nonatomic, strong) UIScrollView *contentScrollView;
//标题
@property (nonatomic, strong) NSArray *titleArray;
//控制器类
@property (nonatomic, strong) NSDictionary *childClassDict;

@property (nonatomic, weak) WwWawaRecordListSuperViewController * recordListVC;                      /**< 仅仅是记录一下最近抓中控制器*/

@end

@implementation WwWaWaRecordInfoViewController

- (NSArray *)titleArray {
    if (!_titleArray) {
        _titleArray = @[@"娃娃详情", @"最近抓中"];
    }
    return _titleArray;
}

- (NSDictionary *)childClassDict {
    if (!_childClassDict) {
        _childClassDict = @{
                            @"娃娃详情" : @"WwWawaParticularsSuperViewController",
                            @"最近抓中" : @"WwWawaRecordListSuperViewController"
                            };
    }
    return _childClassDict;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

- (void)setupUI {
    self.view.height = screenViewHeight - 37*(ScreenHeight/667.0);
    self.view.backgroundColor = [UIColor clearColor];
    //内容View
    [self.view addSubview:self.contentView];
    //导航栏
    [self.contentView addSubview:self.navBarView];
    //UIScrollView
    [self.contentView addSubview:self.contentScrollView];
    //添加子控制器
    [self setupAddChildTitles:self.titleArray childClass:self.childClassDict];
}

- (void)setupAddChildTitles:(NSArray *)titleArray childClass:(NSDictionary *)dict {
    NSInteger count = titleArray.count;
    // 添加子控制器
    for (NSInteger i = 0; i < count; i++) {
        NSString *key = titleArray[i];
        if (!key) {
            break;
        }
        NSString *vcClassStr = dict[key];
        if (!vcClassStr) {
            break;
        }
        Class vcClass = NSClassFromString(vcClassStr);
        WwBaseViewController *subVC = [vcClass new];
        if ([subVC isKindOfClass:NSClassFromString(@"WwWawaRecordListSuperViewController")]) {
            self.recordListVC = (WwWawaRecordListSuperViewController *)subVC;
        }
        //设置控制器标识
        subVC.identificationName = titleArray[i];
        [self addChildViewController:subVC];
    }
    
    // 自控制器的view添加到 scrollBaseV 上
    for (NSInteger i = 0; i < count; i++) {
        if (i >= self.childViewControllers.count) {
            break;
        }
        WwBaseViewController *subVC = self.childViewControllers[i];
        NSString *identificationName = subVC.identificationName;

        for (NSInteger j = 0; j < count; j++) {
            NSString *titleName = titleArray[j];
            // title和控制器的标识相同
            if ([identificationName isEqualToString:titleName]) {
                CGRect rect = CGRectZero;
                rect.size = self.contentScrollView.contentSize;
                rect.size.width = self.contentScrollView.width;
                rect.origin.x = j * self.contentScrollView.width;
                [subVC.view setFrame:rect];
                [self.contentScrollView addSubview:subVC.view];
                break;
            }
        }
    }
}
- (void)selectIndex:(NSInteger)index {
    [self.contentScrollView setContentOffset:CGPointMake(self.contentScrollView.width*index, 0) animated:NO];
    [self.navBarView wawaRecordInfoNavBarSelectIndex:index];
}
#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGFloat index = scrollView.contentOffset.x / scrollView.width;
    [self.navBarView wawaRecordInfoNavBarSelectIndex:index];
}

#pragma mark - WwWawaRecordInfoNavBarDelegate返回代理
- (void)wawaRecordInfoNavBarDelegate:(WwWawaRecordInfoNavBar *)navBar selectButton:(UIButton *)btn {
    [self.contentScrollView setContentOffset:CGPointMake(btn.tag *self.contentScrollView.width, 0) animated:YES];
}

#pragma mark - 懒加载

- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] initWithFrame:CGRectMake(12, -10, ScreenWidth - 24, ScreenHeight - 58)];
        _contentView.backgroundColor = [UIColor whiteColor];
        _contentView.layer.cornerRadius = 8.0;
        _contentView.layer.masksToBounds = YES;
    }
    return _contentView;
}

- (WwWawaRecordInfoNavBar *)navBarView {
    if (!_navBarView) {
        _navBarView = [[WwWawaRecordInfoNavBar alloc] initWithFrame:CGRectMake(0, 0, self.contentView.width, 47)];
        _navBarView.backgroundColor = [UIColor whiteColor];
        _navBarView.delegate = self;
        [_navBarView wawaRecordInfoNavBarTitles:self.titleArray];
    }
    return _navBarView;
}

- (UIScrollView *)contentScrollView {
    if (!_contentScrollView) {
        CGFloat scrollHeight = self.contentView.height - self.navBarView.bottom;
        _contentScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.navBarView.bottom, self.contentView.width, scrollHeight)];
        _contentScrollView.bounces = NO;
        _contentScrollView.contentSize = CGSizeMake(self.titleArray.count * self.contentView.width, scrollHeight);
        _contentScrollView.pagingEnabled = YES;
        _contentScrollView.delegate = self;
        _contentScrollView.showsVerticalScrollIndicator = NO;
        _contentScrollView.showsHorizontalScrollIndicator = NO;
    }
    return _contentScrollView;
}

@end
