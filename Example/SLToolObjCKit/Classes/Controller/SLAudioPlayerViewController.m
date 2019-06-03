//
//  SLAudioPlayerViewController.m
//  SLToolObjCKit_Example
//
//  Created by CoderSLZeng on 2019/5/31.
//  Copyright © 2019 CoderSLZeng. All rights reserved.
//

#import "SLAudioPlayerViewController.h"
#import "SLAudioPlayer.h"

@interface SLAudioPlayerViewController ()
@property (weak, nonatomic) IBOutlet UIButton *playOrResumeBtn;

/** 播放时间 */
@property (weak, nonatomic) IBOutlet UILabel *currentTimeLabel;
/** 总时长 */
@property (weak, nonatomic) IBOutlet UILabel *durationLabel;
/** 加载进度 */
@property (weak, nonatomic) IBOutlet UIProgressView *loadProgressView;
/** 播放控制滑块 */
@property (weak, nonatomic) IBOutlet UISlider *playSlider;
/** 静音按钮 */
@property (weak, nonatomic) IBOutlet UIButton *mutedBtn;
/** 音量控制滑块 */
@property (weak, nonatomic) IBOutlet UISlider *volumeSlider;
/** 定时器 */
@property (nonatomic, weak) NSTimer *timer;
@end

@implementation SLAudioPlayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self timer];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];

    [[SLAudioPlayer sharedInstance] stop];
    [self.timer invalidate];
    self.timer = nil;
    NSLog(@"%s", __func__);
}

- (void)dealloc {
    NSLog(@"%s", __func__);
}

- (NSURL *)remoteAudioURL {
    return [NSURL URLWithString:@"http://audio.xmcdn.com/group23/M04/63/C5/wKgJNFg2qdLCziiYAGQxcTOSBEw402.m4a"];
}

- (NSURL *)locationAudioURL {
    NSString *mp3Path = [[NSBundle mainBundle] pathForResource:@"localtionAudio" ofType:@"mp3"];
    return [NSURL fileURLWithPath:mp3Path];
}

- (IBAction)play:(UIButton *)btn {
    
    if ([btn.currentTitle isEqualToString:@"播放"]) {
        [[SLAudioPlayer sharedInstance] playWithURL:self.remoteAudioURL isCache:YES];
        btn.selected = YES;
    } else {
        [[SLAudioPlayer sharedInstance] resume];
    }
    
}

- (IBAction)pause:(UIButton *)btn {
    [[SLAudioPlayer sharedInstance] pause];
}

- (IBAction)stop:(UIButton *)btn {
    [[SLAudioPlayer sharedInstance] stop];
    self.playOrResumeBtn.selected = NO;
}

- (IBAction)kuaijin:(UIButton *)btn {
    [[SLAudioPlayer sharedInstance] seekWithTimeDiffer:15];
}

- (IBAction)progress:(UISlider *)slider {
    [[SLAudioPlayer sharedInstance] seekWithProgress:slider.value];
}

- (IBAction)rate:(UIButton *)btn {
    [[SLAudioPlayer sharedInstance] setRate:2];
}

- (IBAction)muted:(UIButton *)btn {
    btn.selected = !btn.selected;
    [[SLAudioPlayer sharedInstance] setMuted:btn.selected];
}

- (IBAction)volume:(UISlider *)slider {
    [[SLAudioPlayer sharedInstance] setVolume:slider.value];
}

#pragma mark - Action
- (void)update {
     NSLog(@"%zd", [SLAudioPlayer sharedInstance].state);
    // 68
    // 01:08
    // 设计数据模型的
    // 弱业务逻辑存放位置的问题
    self.currentTimeLabel.text =  [SLAudioPlayer sharedInstance].currentTimeFormat;
    self.durationLabel.text = [SLAudioPlayer sharedInstance].durationFormat;
    
    self.playSlider.value = [SLAudioPlayer sharedInstance].progress;
    
    self.volumeSlider.value = [SLAudioPlayer sharedInstance].volume;
    
    self.loadProgressView.progress = [SLAudioPlayer sharedInstance].loadProgress;

    self.mutedBtn.selected = [SLAudioPlayer sharedInstance].isMuted;    
}

#pragma mark - Getter
- (NSTimer *)timer {
    if (!_timer) {
        NSTimer *timer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(update) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
        _timer = timer;
    }
    return _timer;
}

@end
