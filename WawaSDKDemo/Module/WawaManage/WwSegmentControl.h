//
//  WwSegmentControl.h
//  WawaSDKDemo
//


#import <UIKit/UIKit.h>

static const NSInteger HeightOfSegmentControl = 44.f;

@protocol WwSegmentControlDelegate< NSObject>
@optional
/// 外界调用获取点击下标
-(void)segmentSelectionChange:(NSInteger)selection;
@end


@interface WwSegmentControl : UIView
@property (nonatomic, weak) id <WwSegmentControlDelegate>delegate;
@property (nonatomic, assign) NSInteger selectSegment;
@property (nonatomic, strong) NSMutableArray<UIButton *> *buttonArray;/**< 对应的标题文字 */
/**
 *  @param segment 手动切换下标位置
 */
-(void)selectTheSegment:(NSInteger)segment;

/// 设置下划线颜色
- (void)lineColor:(UIColor *)color;

// 设置底线显示
- (void)setBottomLineVisible:(BOOL)visible;

/**
 *  指定初始化方法
 *  @param frame         frame
 *  @param titleArray    显示的标题数组
 *  @param defaultSelect 默认选中的标题下标,默认选中第一个
 *   34 ---默认高度,可以根据项目需求自己更改
 */
+ (instancetype)segmentWithFrame:(CGRect)frame
                      titleArray:(NSArray *)titleArray
                   defaultSelect:(NSInteger)defaultSelect;
/**
 *  设置颜色
 *  @param titleColor       标题颜色  默认黑色
 *  @param selectTitleColor 选中标题颜色 默认 黑色
 *  @param BackGroundColor  整体背景颜色  默认白色
 *  @param size             标题字体大小 默认14
 */
- (void)setTitleColor:(UIColor *)titleColor
     selectTitleColor:(UIColor *)selectTitleColor
      BackGroundColor:(UIColor *)BackGroundColor
        titleFontSize:(CGFloat)size;


/**
 * 刷新title
 * @param array <#array description#>
 */
- (void)refreshSegmentTitleWithArray:(NSArray *)array;
- (void)refreshSegmentTitle:(NSString *)title atIndex:(NSInteger)index;
@end
