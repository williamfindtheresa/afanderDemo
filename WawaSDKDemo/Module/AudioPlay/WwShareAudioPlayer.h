//
//  WwShareAudioPlayer.h
//

#import <Foundation/Foundation.h>

@interface WwShareAudioPlayer : NSObject

+ (instancetype)shareAudioPlayer;

/**< 播放背景音乐,
     fileName是音乐名称,为空则用默认
     type,音乐文件的类型,为空则默认为WAV, 如果fileName为默认, 则此处不管传什么都是默认*/
- (void)playBackGroundAudioWithFile:(NSString *)fileName ofType:(NSString *)type;

- (void)replayBackGroundAudio;

/**< 播放按钮点击音效, 调用会立刻停止正在播放的上一个按钮点击音, 参数规则同上*/
- (void)playClickAudioWithFile:(NSString *)fileName ofType:(NSString *)type;

/**< 播放结果音效, 调用同及参数按钮播放*/
- (void)playResultAudioWithFile:(NSString *)fileName ofType:(NSString *)type;

- (void)stopBackGroundPlayer;

- (void)stopClickPlayer;

- (void)stopResultPlayer;

- (void)stopAllAudioPlayer;

- (BOOL)backPlayerIsPlaying;

- (void)enterToBack;

- (void)becomeFront;

@end
