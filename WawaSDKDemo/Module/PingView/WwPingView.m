//
//  WwPingView.m
//

#import "WwPingView.h"
#import "Reachability.h"

static NSInteger kTerriblePing = 999;
static NSInteger kPingDurtion = 5;

@interface WwPingView()

@property (nonatomic, strong) NSString * logInfo;

@property (nonatomic, assign) BOOL isPing;                          /**< 是否正在ping*/

@end

@implementation WwPingView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self handlePingNum:0];
        [self startReachNetworkStatus];
    }
    return self;
}

- (void)dealloc
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Public
- (void)startPing {
    if (self.isPing) {
        return;
    }
    self.isPing = YES;
    [[WwGameManager GameMgrInstance] enablePing:YES];
}

- (void)endPing {
    self.isPing = NO;
    [[WwGameManager GameMgrInstance] enablePing:NO];
}

- (BOOL)isNetOK {
    return self.ping <= 100;
}

- (void)handlePingNum:(NSInteger)ping {
    safe_async_main((^{
        BOOL pingStutasChanged = NO;
        if (ping <= 100) {
            self.backgroundColor = WwColorGen(@"#37e077");
            pingStutasChanged = self.ping > 100;
        } else if (ping <= 300) {
            self.backgroundColor = WwColorGen(@"#f3be29");
            pingStutasChanged = self.ping > 300 || self.ping <= 100;
        } else {
            self.backgroundColor = WwColorGen(@"#ff5a45");
            pingStutasChanged = self.ping <= 300;
        }
        self.ping = ping;
        if (pingStutasChanged && [self.delegate respondsToSelector:@selector(netStatusDidChangd:)]) {
            // 通知外界
            [self.delegate netStatusDidChangd:self];
        }
    }));
}

#pragma mark - 网络状态监控
- (void)startReachNetworkStatus {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reachabilityChanged:)
                                                 name:kReachabilityChangedNotification
                                               object:nil];
    
    Reachability * firstStatus = [Reachability reachabilityForInternetConnection];
    [self handleNetStatus:firstStatus.currentReachabilityStatus];
}


// 网络状态变化
- (void)reachabilityChanged:(NSNotification *)notif
{
    Reachability *curReach = [notif object];
    if (![curReach isKindOfClass:[Reachability class]]) {
        return;
    }
    [self handleNetStatus:curReach.currentReachabilityStatus];
}

- (void)handleNetStatus:(NetworkStatus)status {
    if (status == NotReachable) {
        [self handlePingNum:kTerriblePing];
        [self endPing];
    } else {
        [self startPing];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
