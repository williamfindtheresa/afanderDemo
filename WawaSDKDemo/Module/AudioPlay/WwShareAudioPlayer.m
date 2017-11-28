//
//  WwShareAudioPlayer.m
//  prizeClaw
//
//  Created by 刘昊 on 2017/10/10.
//  Copyright © 2017年 QuanMin.ShouYin. All rights reserved.
//

#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>
#import "WwShareAudioPlayer.h"

@interface WwShareAudioPlayer() <AVAudioPlayerDelegate>

@property (nonatomic, strong) AVAudioPlayer * backPlayer;                       /**< 背景音乐播放器*/

@property (nonatomic, strong) AVAudioPlayer * clickPlayer;                      /**< 按钮音乐播放器*/

@property (nonatomic, strong) AVAudioPlayer * resultPlayer;                     /**< 结果音乐播放器*/

@property (nonatomic, strong) NSMutableDictionary * resDic;                     /**< 资源容器*/

@property (nonatomic, strong) NSOperationQueue * queue;                         /**< 队列*/

@property (nonatomic, strong) NSString * lastBackAudioFile;                     /**< 最后一次播放的背景音乐的文件名*/

@property (nonatomic, strong) NSString * lastBackFileType;                      /**< 最后一次播放的背景音乐的拓展名*/

@property (nonatomic, assign) BOOL needReplay;                                  /**< 是否需要恢复播放*/

@end

@implementation WwShareAudioPlayer

#pragma mark - Public
+ (instancetype)shareAudioPlayer {
    static WwShareAudioPlayer * audioPlayer = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        audioPlayer = [[WwShareAudioPlayer alloc] init];
    });
    return audioPlayer;
}

/**< 播放背景音乐,
 fileName是音乐名称,为空则用默认
 type,音乐文件的类型,为空则默认为WAV, 如果fileName为默认, 则此处不管传什么都是默认*/
- (void)playBackGroundAudioWithFile:(NSString *)fileName ofType:(NSString *)type {
    self.lastBackAudioFile = fileName;
    self.lastBackFileType = type;
    
    // 先停止正在播放的
    [self stopBackGroundPlayer];
    
    @weakify(self);
    [self.queue addOperationWithBlock:^{
        @strongify(self);
        
        NSString * path = [self justiflablePathWithFile:fileName ofType:type defaultFile:@"music_game_backGround"];
        NSData * data = [self audioDataWithPath:path];
        
        // 生成一个循环播放的播放器
        self.backPlayer = [[AVAudioPlayer alloc] initWithData:data error:nil];
        self.backPlayer.delegate = self;
        self.backPlayer.numberOfLoops = -1;
        self.backPlayer.meteringEnabled = YES;
        
        [self.backPlayer prepareToPlay];
        BOOL success = [self.backPlayer play];
        NSLog(@"背景音效播放%@",success ? @"成功" : @"失败");
    }];
}

- (void)replayBackGroundAudio {
    [self playBackGroundAudioWithFile:self.lastBackAudioFile ofType:self.lastBackFileType];
}

/**< 播放按钮点击音效, 调用会立刻停止正在播放的上一个按钮点击音, 参数规则同上*/
- (void)playClickAudioWithFile:(NSString *)fileName ofType:(NSString *)type {
    
    // 先停止正在播放的
    [self stopClickPlayer];
    
    @weakify(self);
    [self.queue addOperationWithBlock:^{
        @strongify(self);
        
        NSString * path = [self justiflablePathWithFile:fileName ofType:type defaultFile:@"music_touch_up"];
        NSData * data = [self audioDataWithPath:path];
        
        // 生成一个循环播放的播放器
        self.clickPlayer = [[AVAudioPlayer alloc] initWithData:data error:nil];
        self.clickPlayer.delegate = self;
        self.clickPlayer.meteringEnabled = YES;
    
        [self.clickPlayer prepareToPlay];
        BOOL success = [self.clickPlayer play];
        NSLog(@"点击音效播放%@",success ? @"成功" : @"失败");
    }];
}

/**< 播放结果音效, 调用同及参数按钮播放*/
- (void)playResultAudioWithFile:(NSString *)fileName ofType:(NSString *)type {
    
    // 先停止正在播放的
    [self stopResultPlayer];
    @weakify(self);
    [self.queue addOperationWithBlock:^{
        @strongify(self);
        
        NSString * path = [self justiflablePathWithFile:fileName ofType:type defaultFile:@"music_game_countdown"];
        NSData * data = [self audioDataWithPath:path];
        // 生成一个循环播放的播放器
        self.resultPlayer = [[AVAudioPlayer alloc] initWithData:data error:nil];
        self.resultPlayer.delegate = self;
//        self.resultPlayer.numberOfLoops = MAXFLOAT;
        self.resultPlayer.meteringEnabled = YES;
        
        [self.resultPlayer prepareToPlay];
        BOOL success = [self.resultPlayer play];
        NSLog(@"结果音效播放%@",success ? @"成功" : @"失败");
    }];
}

- (void)stopBackGroundPlayer {
    if (![self.backPlayer isPlaying]) return;
    [self.backPlayer stop];
    self.backPlayer = nil;
}

- (void)stopClickPlayer {
    if (![self.clickPlayer isPlaying]) return;
    [self.clickPlayer stop];
    self.clickPlayer = nil;
}

- (void)stopResultPlayer {
    if (![self.resultPlayer isPlaying]) return;
    [self.resultPlayer stop];
    self.resultPlayer = nil;
}

- (void)stopAllAudioPlayer {
    [self.queue cancelAllOperations];
    [self stopBackGroundPlayer];
    [self stopClickPlayer];
    [self stopResultPlayer];
}

- (BOOL)backPlayerIsPlaying {
    if (self.backPlayer) {
        return self.backPlayer.isPlaying;
    }
    return NO;
}

- (void)enterToBack {
    if (self.backPlayer.isPlaying) {
        [self.backPlayer pause];
        self.needReplay = YES;
    }
}

- (void)becomeFront {
    if (self.needReplay) {
        [self.backPlayer play];
        self.needReplay = NO;
    }
}

#pragma mark - Private
// 根据传入的的文件名和类型取出对应的数据
- (NSData *)audioDataWithPath:(NSString *)filePath {
    NSString * key = filePath;
    NSData * resData = [self.resDic objectForKey:key];
    if (!resData) {
        resData = [NSData dataWithContentsOfFile:filePath];
        if (resData) {
            [self.resDic setObject:resData forKey:key];
        }
    }
    return resData;
}

- (NSString *)justiflablePathWithFile:(NSString *)fileName ofType:(NSString *)type defaultFile:(NSString *)defFile {
    NSString * fPath = nil;
    if (!realString(fileName).length) {
        fPath = [[NSBundle mainBundle] pathForResource:defFile ofType:@"mp3"];
    } else if (!realString(type).length) {
        fPath = [[NSBundle mainBundle] pathForResource:fileName ofType:@"mp3"];
    } else {
        fPath = [[NSBundle mainBundle] pathForResource:fileName ofType:type];
    }
    return fPath;
}

#pragma mark - AVAudioPlayerDelegate
- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error {
    NSLog(@"播放音频文件失败,error : %@",error);
}

#pragma mark - SetterAndGetter
- (NSMutableDictionary *)resDic {
    if (!_resDic) {
        _resDic = [NSMutableDictionary dictionary];
    }
    return _resDic;
}

- (NSOperationQueue *)queue {
    if (!_queue) {
        _queue = [[NSOperationQueue alloc] init];
        _queue.maxConcurrentOperationCount = 1;
    }
    return _queue;
}

@end
