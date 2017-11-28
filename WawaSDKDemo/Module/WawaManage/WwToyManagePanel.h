//
//  WwToyManagePanel.h
//  F_Sky
//
//

#import <UIKit/UIKit.h>

static CGFloat  HeightOfToyManagePanel = 53.f;

static NSString * NotiToyManagePanelVisible = @"NotiToyManagePanelVisible";
static NSString * NotiToyManagePanelSelectChange = @"NotiToyManagePanelSelectChange";
static NSString * NotiToyManagePanelSelectValueChange = @"NotiToyManagePanelSelectValueChange";

// 不同类型的管理面板
typedef NS_ENUM(NSInteger, ToyManagePanelStyle) {
    ToyManagePanel_ToyChecking = 0, // 寄存管理
    ToyManagePanel_Exchange // 兑换
};

typedef NS_ENUM(NSInteger, ToyManagePanelAction) {
    ToyManagePanelAction_None = -1,    // 未知
    ToyManagePanelAction_SelectAll,    // 全选
    ToyManagePanelAction_UnselectAll,    // 反选
    ToyManagePanelAction_LeftAction,    // 左键
    ToyManagePanelAction_RightAction,    // 右键
};


@protocol ToyManagePanelDelegate <NSObject>

- (void)onToyManagePanelAction:(ToyManagePanelAction)action;

@end

@interface WwToyManagePanel : UIView

@property (nonatomic, strong) UILabel *selectLabel;
@property (nonatomic, strong) UIButton *selectAll;
@property (nonatomic, strong) UIButton *exchangeBtn;
@property (nonatomic, strong) UILabel *exchangeLabel;
@property (nonatomic, strong) UIButton *createOrderBtn;
@property (nonatomic, assign) NSInteger currentSelectNumber;
@property (nonatomic, weak) id<ToyManagePanelDelegate> delegate;
@property (nonatomic, assign, readonly) ToyManagePanelStyle style;
@property (nonatomic, assign) BOOL halfSelect; // 半选状态，只在初始时设置

+ (instancetype)createPanelWithFrame:(CGRect)frame andStyle:(ToyManagePanelStyle)style;

- (void)setAllSelect:(BOOL)allSelect;

- (void)setCurrentSelectNumber:(NSInteger)number withTotal:(NSInteger)total;

- (void)setSelectTotalValue:(NSInteger)value;
@end
