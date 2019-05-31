//
//  SLAudioPlayer.h
//  SLToolObjCKit_Example
//
//  Created by CoderSLZeng on 2019/5/31.
//  Copyright © 2019 CoderSLZeng. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SLAudioPlayer : NSObject

+ (instancetype)sharedInstance;

- (void)playWithURL:(NSURL *)URL;

- (void)pause;
- (void)resume;
- (void)stop;

- (void)seekWithTimeDiffer:(NSTimeInterval)timeDiffer;
- (void)seekWithProgress:(float)progress;

- (void)setRate:(float)rate;
- (void)setMuted:(BOOL)muted;
- (void)setVolume:(float)volume;

@end

NS_ASSUME_NONNULL_END
