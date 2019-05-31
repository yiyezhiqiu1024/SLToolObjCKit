//
//  SLDownloadViewController.m
//  SLToolObjCKit_Example
//
//  Created by CoderSLZeng on 2019/5/30.
//  Copyright © 2019 CoderSLZeng. All rights reserved.
//

#import "SLDownloadViewController.h"
#import "SLDownloadToolManager.h"

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
    
    NSURL *URL2 = [NSURL URLWithString:@"http://free2.macx.cn:8281/tools/photo/Sip44.dmg"];
    
    [[SLDownloadToolManager shareInstance] downloadWithURL:URL info:^(NSInteger totalSize) {
        NSLog(@"下载信息--%ld", (long)totalSize);
    } progress:^(float progress) {
        NSLog(@"下载进度--%f", progress);
    } success:^(NSString * _Nonnull filePath) {
         NSLog(@"下载成功--路径:%@", filePath);
    } failure:^{
        NSLog(@"下载失败了");
    }];
    
    [[SLDownloadToolManager shareInstance] downloadWithURL:URL2 info:^(NSInteger totalSize) {
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
    [[SLDownloadToolManager shareInstance] pauseAll];
}

- (IBAction)cancel {
    [[SLDownloadToolManager shareInstance] cancelAll];
}

- (IBAction)cancelAndClean {
    [[SLDownloadToolManager shareInstance] cancelAndClearCachesAll];
}

- (void)update {

}





@end
