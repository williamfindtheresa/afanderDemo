//
//  WwPlayOperationView.h
//

#import <UIKit/UIKit.h>
#include "OBShapedButton.h"

typedef NS_ENUM(NSInteger, CameraDirection) {
    CameraDirection_Front = 0, // 前
    CameraDirection_Left,   // 左
    CameraDirection_Right, // 右
};


@protocol WwPlayOperationViewDelegate <NSObject>

- (void)onPlayDirection:(PlayDirection)direction operationType:(PlayOperationType)type;

@end

@interface WwPlayOperationView : UIView

@property (nonatomic, assign) BOOL operationDisable;
@property (nonatomic, assign) CameraDirection cameraDir;
@property (weak, nonatomic) IBOutlet OBShapedButton *upBtn;
@property (weak, nonatomic) IBOutlet OBShapedButton *leftBtn;
@property (weak, nonatomic) IBOutlet OBShapedButton *downBtn;
@property (weak, nonatomic) IBOutlet OBShapedButton *rightBtn;
@property (weak, nonatomic) IBOutlet OBShapedButton *confirmBtn;

@property (nonatomic, weak) id<WwPlayOperationViewDelegate> delegate;
+ (instancetype)operationView;
@end

