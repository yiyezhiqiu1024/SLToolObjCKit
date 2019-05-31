//
//  SLDownloadViewController.m
//  SLToolObjCKit_Example
//
//  Created by CoderSLZeng on 2019/5/30.
//  Copyright © 2019 CoderSLZeng. All rights reserved.
//

#import "SLDownloadViewController.h"
#import "SLDownloadTool.h"

@interface SLDownloadViewController ()
/** 下载工具 */
@property (strong, nonatomic) SLDownloadTool *downloadTool;
/** 定时器 */
@property (weak, nonatomic) NSTimer *timer;
@end

@implementation SLDownloadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark - Action
- (IBAction)startOrResume {
    NSURL *URL = [NSURL URLWithString:@"http://free2.macx.cn:8281/tools/photo/SnapNDragPro418.dmg"];
//    [self.downloadTool sl_downloadWithURL:URL];
    
    [self.downloadTool sl_downloadWithURL:URL info:^(NSInteger totalSize) {
        NSLog(@"下载信息--%ld", (long)totalSize);
    } progress:^(float progress) {
        NSLog(@"下载进度--%f", progress);
    } success:^(NSString * _Nonnull filePath) {
         NSLog(@"下载成功--路径:%@", filePath);
    } failure:^{
        NSLog(@"下载失败了");
    }];
}

- (IBAction)pause {
    [self.downloadTool sl_pauseTask];
}

- (IBAction)cancel {
    [self.downloadTool sl_cancelTask];
}

- (IBAction)cancelAndClean {
    [self.downloadTool sl_cancelTaskAndCleanCaches];
}

- (void)update {
    NSLog(@"下载器的任务状态 %zd", self.downloadTool.state);
}

#pragma mark - Getter
- (SLDownloadTool *)downloadTool {
    if (!_downloadTool) _downloadTool = [[SLDownloadTool alloc] init];

    return _downloadTool;
}

- (NSTimer *)timer {
    if (!_timer) {
        NSTimer *timer = [NSTimer timerWithTimeInterval:1
                                                 target:self
                                               selector:@selector(update)
                                               userInfo:nil
                                                repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
        _timer = timer;
    }
    return _timer;
}



@end
