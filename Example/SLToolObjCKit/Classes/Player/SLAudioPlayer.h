//
//  SLAudioPlayer.h
//  SLToolObjCKit
//
//  Created by CoderSLZeng on 2019/5/31.
//

#import <Foundation/Foundation.h>

/**
 播放器状态
 因为UI界面需要加载状态显示, 所以需要提供加载状态

 - SLAudioPlayerStateUnknown: 未知（比如都没有开始播放音乐）
 - SLAudioPlayerStateLoading: 正在加载
 - SLAudioPlayerStatePlaying: 正在播放
 - SLAudioPlayerStateStopped: 停止
 - SLAudioPlayerStatePause:   暂停
 - SLAudioPlayerStateFailed: 失败（比如没有网络缓存失败, 地址找不到）
 */
typedef NS_ENUM(NSInteger, SLAudioPlayerState) {
    SLAudioPlayerStateUnknown = 0,
    SLAudioPlayerStateLoading = 1,
    SLAudioPlayerStatePlaying = 2,
    SLAudioPlayerStateStopped = 3,
    SLAudioPlayerStatePause   = 4,
    SLAudioPlayerStateFailed  = 5
};

NS_ASSUME_NONNULL_BEGIN

@interface SLAudioPlayer : NSObject

+ (instancetype)sharedInstance;

/**
 开始播放资源

 @param URL 资源
 */
- (void)playWithURL:(NSURL *)URL isCache:(BOOL)isCache;

/**
 暂停播放
 */
- (void)pause;

/**
 继续播放
 */
- (void)resume;

/**
 停止播放
 */
- (void)stop;

/**
 播放指定的时间

 @param timeDiffer 指定的时间
 */
- (void)seekWithTimeDiffer:(NSTimeInterval)timeDiffer;

/**
 播放进度

 @param progress 进度
 */
- (void)seekWithProgress:(float)progress;

/** 是否静音 */
@property (assign, nonatomic, getter=isMuted) BOOL muted;
/** 音量 */
@property (assign, nonatomic) float volume;
/** 倍速 */
@property (assign, nonatomic) float rate;

/** 总时长 */
@property (assign, nonatomic, readonly) NSTimeInterval duration;
/** 总时长字符串 */
@property (copy, nonatomic, readonly) NSString *durationFormat;
/** 当前时间 */
@property (assign, nonatomic, readonly) NSTimeInterval currentTime;
/** 当前时间字符串 */
@property (copy, nonatomic, readonly) NSString *currentTimeFormat;

/** 进度 */
@property (assign, nonatomic, readonly) float progress;
/** 资源 */
@property (strong, nonatomic, readonly) NSURL *URL;
/** 加载进度 */
@property (assign, nonatomic, readonly) float loadProgress;

/** 播放状态 */
@property (assign, nonatomic, readonly) SLAudioPlayerState state;


@end

NS_ASSUME_NONNULL_END
