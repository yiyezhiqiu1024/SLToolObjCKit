//
//  SLDownloadViewController.m
//  SLToolObjCKit_Example
//
//  Created by CoderSLZeng on 2019/5/30.
//  Copyright © 2019 CoderSLZeng. All rights reserved.
//

#import "SLDownloadViewController.h"

#import <SLToolObjCKit/SLDownloadToolManager.h>

@interface SLDownloadViewController ()
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
    
    [[SLDownloadToolManager sharedInstance] downloadWithURL:URL info:^(NSInteger totalSize) {
        NSLog(@"下载信息--%ld", (long)totalSize);
    } progress:^(float progress) {
        NSLog(@"下载进度--%f", progress);
    } success:^(NSString * _Nonnull filePath) {
         NSLog(@"下载成功--路径:%@", filePath);
    } failure:^{
        NSLog(@"下载失败了");
    }];
    
    [[SLDownloadToolManager sharedInstance] downloadWithURL:URL2 info:^(NSInteger totalSize) {
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
    [[SLDownloadToolManager sharedInstance] pauseAll];
}

- (IBAction)cancel {
    [[SLDownloadToolManager sharedInstance] cancelAll];
}

- (IBAction)cancelAndClean {
    [[SLDownloadToolManager sharedInstance] cancelAndCleanCachesAll];
}

- (void)update {

}





@end
