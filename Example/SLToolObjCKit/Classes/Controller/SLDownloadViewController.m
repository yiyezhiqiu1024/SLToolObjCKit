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
@end

@implementation SLDownloadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark - Action
- (IBAction)Downloading {
    NSURL *url = [NSURL URLWithString:@"http://free2.macx.cn:8281/tools/photo/SnapNDragPro418.dmg"];
    [self.downloadTool sl_downloadWithURL:url];
}

#pragma mark - Getter
- (SLDownloadTool *)downloadTool {
    if (!_downloadTool) _downloadTool = [[SLDownloadTool alloc] init];

    return _downloadTool;
}



@end
