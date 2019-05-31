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
@property (weak, nonatomic) IBOutlet UILabel *playTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalTimeLabel;

@property (weak, nonatomic) IBOutlet UIProgressView *loadPV;
@end

@implementation SLAudioPlayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (NSURL *)remoteAudioURL {
    return [NSURL URLWithString:@"http://audio.xmcdn.com/group23/M04/63/C5/wKgJNFg2qdLCziiYAGQxcTOSBEw402.m4a"];
}

- (NSURL *)locationAudioURL {
    NSString *mp3Path = [[NSBundle mainBundle] pathForResource:@"localtionAudio" ofType:@"mp3"];
    return [NSURL fileURLWithPath:mp3Path];
}

- (IBAction)play:(UIButton *)btn {
    
    [[SLAudioPlayer sharedInstance] playWithURL:self.locationAudioURL];
}

- (IBAction)pause:(UIButton *)btn {
    [[SLAudioPlayer sharedInstance] pause];
}

- (IBAction)resume:(UIButton *)btn {
    [[SLAudioPlayer sharedInstance] resume];
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

@end
