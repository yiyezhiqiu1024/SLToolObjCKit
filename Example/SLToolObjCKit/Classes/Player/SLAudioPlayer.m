//
//  SLAudioPlayer.m
//  SLToolObjCKit_Example
//
//  Created by CoderSLZeng on 2019/5/31.
//  Copyright © 2019 CoderSLZeng. All rights reserved.
//

#import "SLAudioPlayer.h"
#import <AVFoundation/AVFoundation.h>

@interface SLAudioPlayer()<NSCopying, NSMutableCopying>

/** 播放器 */
@property (strong, nonatomic) AVPlayer *player;

@end

@implementation SLAudioPlayer

static SLAudioPlayer *instance_;

+ (instancetype)sharedInstance {
    if (!instance_) {
        instance_ = [[self alloc] init];
    }
    return instance_;
}

- (void)playWithURL:(NSURL *)URL {
    
    // 1.资源请求
    AVAsset *asset = [AVURLAsset assetWithURL:URL];
    // 2.资源组织
    AVPlayerItem *item = [AVPlayerItem playerItemWithAsset:asset];
    [item addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    // 3.资源播放
    self.player = [AVPlayer playerWithPlayerItem:item];
}

- (void)pause {
    [self.player pause];
}

- (void)resume {
    [self.player play];
}

- (void)stop {
    [self pause];
    self.player = nil;
}

- (void)seekWithTimeDiffer:(NSTimeInterval)timeDiffer {
    // 1.当前音频资源的总时长
    CMTime totalTime = self.player.currentItem.duration;
    NSTimeInterval totalTimeSec = CMTimeGetSeconds(totalTime);
    // 2.当前音频，已经播放的时长
    CMTime playTime = self.player.currentItem.currentTime;
    NSTimeInterval playTimeSec = CMTimeGetSeconds(playTime);
    playTimeSec += timeDiffer;
    
    [self seekWithProgress:playTimeSec / totalTimeSec];
}

- (void)seekWithProgress:(float)progress {
    if (progress < 0 || progress > 1) return;
    
    // 1.当前音频资源的总时长
    CMTime totalTime = self.player.currentItem.duration;
    // 2.当前音频，已经播放的时长
    NSTimeInterval totalSec = CMTimeGetSeconds(totalTime);
    NSTimeInterval playTimeSec = totalSec * progress;
    CMTime currentTime = CMTimeMake(playTimeSec, 1);
    
    [self.player seekToTime:currentTime completionHandler:^(BOOL finished) {
        if (finished) {
            NSLog(@"确定加载这个时间点的音频资源");
        } else {
            NSLog(@"取消加载这个时间点的音频资源");
        }
    }];
}

- (void)setRate:(float)rate {
    self.player.rate = rate;
}

- (void)setMuted:(BOOL)muted {
    self.player.muted = muted;
}

- (void)setVolume:(float)volume {
    if (volume < 0 || volume > 1) return;
    
    if (volume > 0) [self setMuted:NO];
    
    self.player.volume = volume;
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

#pragma mark - KVO
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
            NSLog(@"状态未知");
        }
    }
}

@end
