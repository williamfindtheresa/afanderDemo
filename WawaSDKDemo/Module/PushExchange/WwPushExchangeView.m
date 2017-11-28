//
//  WwPushExchangeView.m
//

#import "WwPushExchangeView.h"
#import "WwLiveViewController.h"

#import "WwSoundShockView.h"

#import "WwLiveInteractiveView.h"

typedef NS_ENUM(NSUInteger, WwPushExchangeStatus)
{
    WwPushExchangeStatusIdle = 1,  /**< 默认状态， 显示默认图像，eg 娃娃*/
    WwPushExchangeStatusPullStream, /**< 有人开播，去拉取游戏者头像*/
    WwPushExchangeStatusPusher, /**< 自己推流*/
};



@interface WwPushExchangeView ()

@property (weak, nonatomic) IBOutlet UILabel *nickName;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (weak, nonatomic) IBOutlet UIView *gameUserContainer;

@property (nonatomic, strong) WwSoundShockView *soundShock;

//播放器容器
@property (weak, nonatomic) IBOutlet UIView *txLayer;

//@property (nonatomic, weak) WwTXPlayerViewController *playerVc;
//@property (nonatomic, weak) WwTXPushStreamViewController *pushVc;

@property (nonatomic, assign) WwPushExchangeStatus status;

@property (nonatomic, assign) WwPusherType pullType; /**< 拉流类型*/

@property (nonatomic, assign) NSInteger clickCount; /**< 翻转次数*/

@property (nonatomic, copy) NSString * pullStreamUrl; /**< 啦流地址url*/

/**< 玩游戏的人， 自己推流的不算*/
@property (nonatomic, strong) WwUserModel *watchPlayerUser;

@end

@implementation WwPushExchangeView

- (void)dealloc
{
    NSLog(@"%s",__func__);
    [self clearPusher];
    [self clearPlayer];
}

+ (instancetype)pushExchangeView {
    
    NSArray *views = [[NSBundle mainBundle] loadNibNamed:@"WwPushExchangeView" owner:nil options:nil];
    for (id view in views) {
        if ([view isKindOfClass:[WwPushExchangeView class]]) {
            return view;
        }
    }
    return nil;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    //添加一个声音层
//    self.soundShock = [[WwSoundShockView alloc] initWithFrame:(CGRect){50,95-20,44,20}];
//    [self addSubview:self.soundShock];
//    self.soundShock.hidden = YES;
    
    self.gameUserContainer.layer.cornerRadius = 3.0;
    self.gameUserContainer.layer.masksToBounds = YES;
    
    self.layer.cornerRadius = 3.0;
    self.layer.masksToBounds = YES;
    
    self.pushType = [self originConfigAuth];
    self.txLayer.clipsToBounds = YES;
}

- (IBAction)tapAction:(UIButton *)sender
{
    if (self.status != WwPushExchangeStatusPusher) {
        //如果有观看的player，要显示小卡片
        if (self.watchPlayerUser) {
            [self.liveVC.interV  showUserCardWithData:self.watchPlayerUser];
        }
        return;
    }
}

#pragma mark - Helper
//qcloud://qcloud.rtmp?hd=rtmp%3A%2F%2F11505.liveplay.myqcloud.com%2Flive%2F11505_33_1245489220_2017101423123430843891411000&normal=rtmp%3A%2F%2F11505.liveplay.myqcloud.com%2Flive%2F11505_33_1245489220_2017101423123430843891411000&flag=1
- (NSString *)playerUrlFromOriginUrlString:(NSString *)ori
{
    NSArray *compontens = [ori componentsSeparatedByString:@"|"];
    NSString *firstStr = realString([compontens safeObjectAtIndex:0]);
    
    //url decode 编码。 腾讯云 不能播放编码后的 url地址
    NSString *decodedString = (__bridge_transfer NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(NULL, (__bridge CFStringRef)firstStr,CFSTR(""),CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding));
    
    return decodedString;
}


-(NSString *)valueForKey:(NSString *)key fromSourceString:(NSString *)sourceString
{
    NSArray  * qerryArray = [sourceString componentsSeparatedByString:@"&"];
    NSString * value = nil;
    for (NSString * para in qerryArray) {
        if ([para rangeOfString:key].location != NSNotFound) {
            NSArray  *keyValueArr = [para componentsSeparatedByString:@"="];
            value = [keyValueArr safeObjectAtIndex:1];
            break;
        }
    }
    return value;
}


- (NSString *)deleteParameter:(NSString *)parameter WithOriginUrl:(NSString *)originUrl
{
    
    NSString *finalStr = [NSString string];
    NSMutableString * mutStr = [realString(originUrl) mutableCopy];
    NSArray *strArray = [mutStr componentsSeparatedByString:parameter];
    NSMutableString *firstStr = [strArray safeObjectAtIndex:0];
    
    NSMutableString *lastStr = [strArray lastObject];
    NSRange characterRange = [lastStr rangeOfString:@"&"];
    
    if (characterRange.location != NSNotFound) {
        
        NSArray *lastArray = [lastStr componentsSeparatedByString:@"&"];
        NSMutableArray *mutArray = [NSMutableArray arrayWithArray:lastArray];
        [mutArray safeRemoveObjectAtIndex:0];
        NSString *modifiedStr = [mutArray componentsJoinedByString:@"&"];
        finalStr = [firstStr stringByAppendingString:modifiedStr];
    }
    else {

        finalStr = firstStr;
    }
    
    return finalStr;
}


- (void)clearPlayer
{
}

- (void)clearPusher
{
    
  
}


- (void)freshPusherUIAfterClick
{
//    if (self.pushType & WwPusherTypeDisableVIDEO) {
//        //将视频画面隐藏
//        self.pushVc.view.hidden = YES;
//        self.soundShock.hidden = NO;
//    }
//    else {
//        self.pushVc.view.hidden = NO;
//        self.soundShock.hidden = YES;
//    }
}

- (void)freshPullUIAfterNotify
{
//    if (self.pullType & WwPusherTypeDisableVIDEO ) {
//        self.playerVc.view.hidden = YES;
//        self.soundShock.hidden = NO;
//    }
//    else {
//        self.playerVc.view.hidden = NO;
//        self.soundShock.hidden = YES;
//    }
}


/**< 获取初始的 视频 和 音频权限*/
- (NSInteger)originConfigAuth
{
    // TODO
    return 1;
}

- (void)animateForPlayer
{
//    [self.layer removeAllAnimations];
//    [UIView transitionWithView:self duration:1.0 options:UIViewAnimationOptionTransitionFlipFromLeft animations:nil completion:nil];
//     NSLog(@"pull - animate");
}



#pragma mark - WwAnchorInfoProtocol
- (void)freshPullStream:(NSString *)playStream andGameUser:(WwUserModel *)gameUser isSocketNotify:(BOOL)isNotify
{
    safe_async_main(^{
        

//        //TODO 流地址 对象化
//        //自己在推流，除非自己主动断线。否则不主动去播放
//        if (self.status == WwPushExchangeStatusPusher) {
//
//            NSLog(@"pull - NO return");
//            return;
//        }
//
//        //当是自己的时候，也返回
//        if (gameUser.uid == kZXUid) {
//            NSLog(@"pull - NO return self");
//            return;
//        }
        
        self.status = WwPushExchangeStatusPullStream;
        if (isNotify) {
            [self setGameUser:gameUser];
        }
        
//
//        //带flag 带normal
//        NSString * url = [self playerUrlFromOriginUrlString:playStream];
//        
//        //播放地址
//        NSString *playUrl = [self  valueForKey:@"normal" fromSourceString:url];
//
//        NSString *deleteOri = [self deleteParameter:@"flag" WithOriginUrl:playUrl];
//        NSString *deleteLocal = [self deleteParameter:@"flag" WithOriginUrl:self.pullStreamUrl];
//        
//        NSString *flag = [self valueForKey:@"flag" fromSourceString:url];
//        NSInteger flagValue = [flag integerValue];
//        
//        //有没有换人，有换人，就不旋转。
//        if ([self hasChangePlayer:gameUser]) {
//            
//        }
//        else {
//            NSLog(@"pull -  老权限%zi,新权限 %zi",_pullType,flagValue);
//
//            if ((_pullType & WwPusherTypeDisableVIDEO) != (flagValue & WwPusherTypeDisableVIDEO)) {
//                [self animateForPlayer]; //两次视频权限不一致，就翻转下
//            }
//        }
//        
//        self.pullType = flagValue;
//        
//        NSLog(@"pull - stream %@ \n deleteOri %@ \n  deleteLocal %@ \n flag %zi",playStream,deleteOri,deleteLocal, flagValue);
//        
//        if ([deleteOri isEqualToString:deleteLocal] ) {
//         
//            [self freshPullUIAfterNotify];
//            
//            NSLog(@"pull -  相同的流");
//            
//            return;
//        }
//        else {
//            
//            //不相等，新的流地址
//        }
//        
//        if ([ZXCommonTool zx_strIsEmpty:url] == YES) {
//            return;
//        }
//        
//        self.status = WwPushExchangeStatusPullStream;
//        [self clearPlayer];
//        [self clearPusher];
//        
//        NSLog(@"pull - playerUrl %@",url);
//        
//        WwTXPlayerViewController *playerVc = [[WwTXPlayerViewController alloc] init];
//        [self.liveVC addChildViewController:playerVc];
//        self.playerVc = playerVc;
//        
//        playerVc.view.frame = self.txLayer.bounds;
//        [self.txLazyer insertSubview:playerVc.view atIndex:0]; //播放预览
//
//        playerVc.delegate = self;
//        
//        [playerVc playWithUrl:playUrl];
//        self.pullStreamUrl = playUrl;
//        
//        [self freshPullUIAfterNotify];
//        
//        if (isNotify) {
//            [self setGameUser:gameUser];
//        }
    });
}

//去推流
- (void)freshPushStream:(NSString *)pushUrl
{
//    [[WwShareAudioPlayer shareAudioPlayer] stopAllAudioPlayer];
    safe_async_main(^{
        
        self.status = WwPushExchangeStatusPusher;
        [self setGameUser:kZXUserInfo];
        
//        if ([ZXCommonTool zx_strIsEmpty:pushUrl] == YES) {
//            return;
//        }
//        
//        self.status = WwPushExchangeStatusPusher;
//        
//        [self clearPusher];
//        [self clearPlayer];
//        
//        WwTXPushStreamViewController *pushVc = [[WwTXPushStreamViewController alloc] init];
//        [self.liveVC  addChildViewController:pushVc];
//        self.pushVc = pushVc;
//        pushVc.pushDelegate = self;
//        
//        [self.txLayer insertSubview:pushVc.view atIndex:0]; //将流放在最底部. 有预览的
//        pushVc.view.frame = self.txLayer.bounds;
//        pushVc.pushUrl = pushUrl;
//        
//        [pushVc startSession:^(BOOL success) {
//            NSLog(@"txpush - %zi",success);
//        }];
//        
//        [self freshPusherUIAfterClick];
//        [self setGameUser:kZXUserInfo];
    });
    
   
}

//没有其他人拉操作。显示默认的图像
- (void)freshDefaultUIIsSocketNotify:(BOOL)isNotify
{
    safe_async_main(^{
    
        if (isNotify) {
            //自己推流中，socket 推送拉流信息，忽略
            if (self.status == WwPushExchangeStatusPusher) {
                NSLog(@"pull - NO return");
                return;
            }
        }
        else {
            //自己主动断开, 自己必须是推流者，否则认为是多次点击开始抓，失败
            if (self.status != WwPushExchangeStatusPusher) {
                return;
            }
        }
        
        self.status = WwPushExchangeStatusIdle;
        self.wawa = self.roomData.wawa;
        
//        [self clearPlayer];
//        [self clearPusher];
//        self.soundShock.hidden = YES;
    });
}

#pragma mark - WwPlayerDelegate
- (void)zyPlayerReady
{
    /**< 将游戏者 画面隐藏*/
//    [self.txLayer addSubview:self.playerVc.view];
}

- (void)zyPlayerDidHaveAudio:(BOOL)have
{
}

#pragma mark  WwTXPuserDelegate
- (void)zyPusherDidHaveAudio:(BOOL)have
{
}

#pragma mark - Getter Setter

- (void)setRoomData:(WwRoomModel *)roomData
{
    _roomData = roomData;
    
    self.wawa = roomData.wawa; //设置默认虚伪以待
    
    //进入房间的时候，根据房间数据，拉取房间内 是否有流信息
    if (!roomData) {
        return;
    }
    
//    //只去拉流
//    NSString *url = [WwCommonRoomStream stringByAppendingPathComponent:[@([roomData ID]) stringValue]];
//    @weakify(self);
//    [ZXHttpTask GET:url parameters:nil taskResponse:^(WwHttpResponse *response) {
//        @strongify(self);
//        NSLog(@"%@",response.data);
//        if(response.code != 0) {
//            return;
//        }
//        WwRoomStreamModel *model = [WwRoomStreamModel mj_objectWithKeyValues:response.data];
//        BOOL canUse = [model checkCanUsePlayerStream];
//        if (canUse && ([ZXCommonTool zx_strIsEmpty:model.streamPlayer] == NO)) {
//            [self freshPullStream:model.streamPlayer andGameUser:model.user isSocketNotify:NO];
//        }
//    }];
    
    @weakify(self);
    //只做房间user
    [[WawaSDK WawaSDKInstance].gameMgr requestRoomInfo:[roomData ID] complete:^(BOOL success, NSInteger code, WwRoomModel *roomInfo) {
        @strongify(self);
        if(success == NO) {
            return;
        }
        if ((roomInfo.state >= 3) && (roomInfo.state <= 6)) {
            WwUserModel *user = [[WwUserModel alloc] init];
            user.uid = roomInfo.user.uid;
            user.nickname = roomInfo.user.nickname;
            user.portrait = roomInfo.user.portrait;
            [self setGameUser:user];
        }
    }];
}

- (void)setWawa:(WwWawaItem *)wawa
{
    //设置 默认头像
    self.imageView.image = [UIImage imageNamed:@"avatar_default_medium"];
    self.nickName.text = @"虚位以待";
    self.watchPlayerUser = nil;
}

- (void)setGameUser:(WwUserModel *)user
{
    if ([self hasChangePlayer:user]) {
        [self animateForPlayer];
    }
    if (user == nil) {
        [self setWawa:nil];
    }
    else {
        [self.imageView sd_setImageWithURL:[NSURL URLWithString:realString(user.portrait)] placeholderImage:[UIImage imageNamed:@"room_pull_default"]];
        
        self.nickName.text = user.nickname;
    }
    self.watchPlayerUser = user;
}

- (BOOL)hasChangePlayer:(WwUserModel *)playerNew
{
    NSLog(@"pull - newid %zi , olderid %zi",playerNew.uid,self.watchPlayerUser.uid);
    if (playerNew.uid != self.watchPlayerUser.uid) {
        return YES;
    }
    else {
        return NO;
    }
}

- (void)setStatus:(WwPushExchangeStatus)status {
    if (_status == status) {
        return;
    }
    _status = status;
}

- (WwUserModel *)watchPlayer
{
    if (_watchPlayerUser) {
        return _watchPlayerUser;
    }
    return nil;
}

@end
