//
//  SLDownloadToolManager.m
//  SLToolObjCKit
//
//  Created by CoderSLZeng on 2019/5/31.
//

#import "SLDownloadToolManager.h"
#import "NSString+SLMD5.h"
#import "SLDownloadTool.h"

@interface SLDownloadToolManager () <NSCopying, NSMutableCopying>

@property (strong, nonatomic) NSMutableDictionary *downloadInfoDict;

@end

@implementation SLDownloadToolManager

static SLDownloadToolManager *_shareInstance;

+ (instancetype)shareInstance {
    if (!_shareInstance) {
        _shareInstance = [[self alloc] init];
    }
    return _shareInstance;
}

- (void)downloadWithURL:(NSURL *)URL
                      info:(DownloadInfoBlock)info
                  progress:(DownloadProgressBlock)progress
                   success:(DownloadSuccessBlock)success
                   failure:(DownloadFailureBlock)failure {
    NSString *URLMD5 = [URL.absoluteString sl_md5];
    
    SLDownloadTool *downloadTool = self.downloadInfoDict[URLMD5];
    if (downloadTool == nil) {
        downloadTool = [[SLDownloadTool alloc] init];
        self.downloadInfoDict[URLMD5] = downloadTool;
    }
    
    __weak typeof(self) weakSelf = self;
    [downloadTool downloadWithURL:URL info:info progress:progress success:^(NSString * _Nonnull filePath) {
        [weakSelf.downloadInfoDict removeObjectForKey:URLMD5];
        success(filePath);
    } failure:failure];
}

- (void)pauseWithURL:(NSURL *)URL {
    NSString *URLMD5 = [URL.absoluteString sl_md5];
    SLDownloadTool *downloadTool = self.downloadInfoDict[URLMD5];
    [downloadTool pauseDownload];
}

- (void)resumeWithURL:(NSURL *)URL {
    NSString *URLMD5 = [URL.absoluteString sl_md5];
    SLDownloadTool *downloadTool = self.downloadInfoDict[URLMD5];
    [downloadTool resumeDownload];
}

- (void)cancelWithURL:(NSURL *)URL {
    NSString *URLMD5 = [URL.absoluteString sl_md5];
    SLDownloadTool *downloadTool = self.downloadInfoDict[URLMD5];
    [downloadTool cancelDownload];
}

- (void)cancelAndClearCachesWithURL:(NSURL *)URL {
    NSString *URLMD5 = [URL.absoluteString sl_md5];
    SLDownloadTool *downloadTool = self.downloadInfoDict[URLMD5];
    [downloadTool cancelDownloadAndCleanCaches];
}

- (void)pauseAll {
    [self.downloadInfoDict.allValues performSelector:@selector(pauseDownload) withObject:nil];
}

- (void)resumeAll {
    [self.downloadInfoDict.allValues performSelector:@selector(resumeDownload) withObject:nil];
}

- (void)cancelAll {
    [self.downloadInfoDict.allValues performSelector:@selector(cancelDownload) withObject:nil];
}

- (void)cancelAndClearCachesAll {
    [self.downloadInfoDict.allValues performSelector:@selector(cancelDownloadAndCleanCaches) withObject:nil];
}


+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    if (!_shareInstance) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            _shareInstance = [super allocWithZone:zone];
        });
    }
    return _shareInstance;
}

- (id)copyWithZone:(NSZone *)zone {
    return _shareInstance;
}

- (id)mutableCopyWithZone:(NSZone *)zone {
    return _shareInstance;
}



@end
