//
//  ZYWawaRecordListCell.m
//  WawaSDKDemo
//
//

#import "ZYWawaRecordListCell.h"
#import <WawaSDK/WawaSDK.h>

@interface ZYWawaRecordListCell ()
//头像
@property (weak, nonatomic) IBOutlet UIImageView *portraitImageView;
//昵称
@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;
//时间
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
//回放按钮
@property (weak, nonatomic) IBOutlet UIButton *replayBtn;

@property (nonatomic, strong) WwRoomRecordInfo *model;
@end

@implementation ZYWawaRecordListCell


- (void)wawaRecordListCellWith:(WwRoomRecordInfo *)recordInfo {
    _model = recordInfo;
//    [self.portraitImageView setUrl:recordInfo.user.portrait];
    [self.nickNameLabel setText:recordInfo.user.nickname];
    [self.timeLabel setText:recordInfo.dateline];
}

- (IBAction)watchButtonClick:(UIButton *)sender {
    
}

@end
