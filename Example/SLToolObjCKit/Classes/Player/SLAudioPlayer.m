//
//  SLAudioPlayer.m
//  SLToolObjCKit
//
//  Created by CoderSLZeng on 2019/5/31.
//

#import "SLAudioPlayer.h"
#import <AVFoundation/AVFoundation.h>
#import "NSURL+SLExtension.h"
#import "SLResourceLoaderDelegate.h"

@interface SLAudioPlayer()<NSCopying, NSMutableCopying>
{
    BOOL _isUserPause; // 是否被用户暂停
}

/** 播放器 */
@property (strong, nonatomic) AVPlayer *player;
/** 代理 */
@property (strong, nonatomic) SLResourceLoaderDelegate *delegate;
@end

@implementation SLAudioPlayer

static SLAudioPlayer *instance_;

+ (instancetype)sharedInstance {
    if (!instance_) {
        instance_ = [[self alloc] init];
    }
    return instance_;
}

- (void)playWithURL:(NSURL *)URL isCache:(BOOL)isCache {

    NSURL *currentURL = [(AVURLAsset *)self.player.currentItem.asset URL];
    if ([URL isEqual:currentURL]) {
        NSLog(@"当前播放任务已经存在");
        [self resume];
        return;
    }
    
    if (self.player.currentItem) [self removeObserver];
    
    _URL = URL;
    
    if (isCache) URL = [URL sl_sreamingURL];
    
    // 1.资源请求
    AVURLAsset *asset = [AVURLAsset assetWithURL:URL];
    
    // 关于网络音频的请求, 是通过这个对象, 调用代理的相关方法, 进行加载的
    // 拦截加载的请求, 只需要, 重新修改它的代理方法就可以
    self.delegate = [[SLResourceLoaderDelegate alloc] init];
    [asset.resourceLoader setDelegate:self.delegate queue:dispatch_get_main_queue()];
    
    // 2.资源组织
    AVPlayerItem *item = [AVPlayerItem playerItemWithAsset:asset];
    [item addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    [item addObserver:self forKeyPath:@"playbackLikelyToKeepUp" options:NSKeyValueObservingOptionNew context:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playEnd)
                                                 name:AVPlayerItemDidPlayToEndTimeNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playInterrupt)
                                                 name:AVPlayerItemPlaybackStalledNotification
                                               object:nil];
    
    // 3.资源播放
    self.player = [AVPlayer playerWithPlayerItem:item];
}

- (void)pause {
    if (!self.player) return;
    [self.player pause];
    _isUserPause = YES;
    self.state = SLAudioPlayerStatePause;
}

- (void)resume {
    // 判断当前播放器是否存在, 并且数据组织者里面的数据准备已经足够播放了
    if (!self.player && !self.player.currentItem.playbackLikelyToKeepUp) return;
    [self.player play];
    _isUserPause = NO;
    self.state = SLAudioPlayerStatePlaying;
}

- (void)stop {
    if (!self.player) return;
    [self pause];
    self.state = SLAudioPlayerStateStopped;
    self.player = nil;
}

- (void)seekWithTimeDiffer:(NSTimeInterval)timeDiffer {
    // 1.当前音频资源的总时长
    NSTimeInterval duration = self.duration;
    // 2.当前音频，已经播放的时长
    NSTimeInterval currentTime = self.currentTime;
    currentTime += timeDiffer;
    [self seekWithProgress:currentTime / duration];
}

- (void)seekWithProgress:(float)progress {
    if (progress < 0 || progress > 1 || !self.player) return;
    
    // 1.当前音频资源的总时长
    NSTimeInterval totalTime = self.duration;
    // 2.当前音频，已经播放的时长
    NSTimeInterval playTime= totalTime * progress;
    CMTime currentTime = CMTimeMake(playTime, 1);
    
    [self.player seekToTime:currentTime completionHandler:^(BOOL finished) {
        if (finished) {
            NSLog(@"确定加载这个时间点的音频资源");
        } else {
            NSLog(@"取消加载这个时间点的音频资源");
        }
    }];
}

- (NSTimeInterval)currentTime {
    CMTime currentTime = self.player.currentItem.currentTime;
    return [self convertCMTime:currentTime];
}

- (NSTimeInterval)duration {
    CMTime totlaTime = self.player.currentItem.duration;
    return [self convertCMTime:totlaTime];
}

- (NSString *)currentTimeFormat {
    return [NSString stringWithFormat:@"%02d:%02d", (int)self.currentTime / 60, (int)self.currentTime % 60];
}

- (NSString *)durationFormat {
    return [NSString stringWithFormat:@"%02d:%02d", (int)self.duration / 60, (int)self.duration % 60];
}

- (float)progress {
    if (0 == self.duration) return 0;
    
    return self.currentTime / self.duration;
}

- (float)loadProgress {
    if (0 == self.duration) return 0;
    
    CMTimeRange timeRange = self.player.currentItem.loadedTimeRanges.lastObject.CMTimeRangeValue;
    CMTime loadTime = CMTimeAdd(timeRange.start, timeRange.duration);
    NSTimeInterval loadTimeSec = CMTimeGetSeconds(loadTime);
    return loadTimeSec / self.duration;
}

#pragma mark - Settet and Getter
- (void)setRate:(float)rate {
    self.player.rate = rate;
}

- (float)rate {
    return self.player.rate;
}

- (void)setMuted:(BOOL)muted {
    self.player.muted = muted;
}

- (BOOL)isMuted {
    return self.player.isMuted;
}

- (void)setVolume:(float)volume {
    if (volume < 0 || volume > 1) return;
    
    if (volume > 0) [self setMuted:NO];
    
    self.player.volume = volume;
}

- (float)volume {
    return self.player.volume;
}

#pragma mark - Private methond
- (NSTimeInterval)convertCMTime:(CMTime)aCMTime {
    NSTimeInterval time = CMTimeGetSeconds(aCMTime);
    // 判断音频时间是否为空
    if (isnan(time)) return 0;
    return time;
}

- (void)setState:(SLAudioPlayerState)state {
    _state = state;
}

/**
 移除KVO
 */
- (void)removeObserver {
    [self.player.currentItem removeObserver:self forKeyPath:@"status"];
    [self.player.currentItem removeObserver:self forKeyPath:@"playbackLikelyToKeepUp"];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

/**
 播放完成
 */
- (void)playEnd {
    self.state = SLAudioPlayerStateStopped;
}

/**
 播放被打断
 */
- (void)playInterrupt {
    self.state = SLAudioPlayerStatePause;
}

#pragma mark KVO
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary<NSKeyValueChangeKey,id> *)change
                       context:(void *)context {
    
    if ([keyPath isEqualToString:@"status"]) {
        AVPlayerItemStatus status = [change[NSKeyValueChangeNewKey] integerValue];
        if (status == AVPlayerItemStatusReadyToPlay) {
            NSLog(@"资源准备好了, 这时候播放就没有问题");
            [self.player play];
        } else {
            NSLog(@"未知-%ld", status);
        }
    } else if ([keyPath isEqualToString:@"playbackLikelyToKeepUp"]) {
        BOOL ptk = [change[NSKeyValueChangeNewKey] boolValue];
        if (ptk) {
            NSLog(@"当前的资源, 准备的已经足够播放了");
            
            // 用户的手动暂停的优先级最高
            if (!_isUserPause) {
                [self resume];
            }
        } else {
            NSLog(@"资源还不够, 正在加载过程当中");
            self.state = SLAudioPlayerStateLoading;
        }
    }
}

#pragma mark - Override
+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    if (!instance_) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            instance_ = [super allocWithZone:zone];
        });
    }
    return instance_;
}

- (id)copyWithZone:(NSZone *)zone {
    return instance_;
}

- (id)mutableCopyWithZone:(NSZone *)zone {
    return instance_;
}

@end
