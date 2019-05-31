//
//  SLDownloadToolManager.h
//  SLToolObjCKit
//
//  Created by CoderSLZeng on 2019/5/31.
//

#import <Foundation/Foundation.h>
#import "SLDownloadTool.h"

NS_ASSUME_NONNULL_BEGIN

@interface SLDownloadToolManager : NSObject
+ (instancetype)shareInstance;

- (void)downloadWithURL:(NSURL *)URL
                      info:(DownloadInfoBlock)info
                  progress:(DownloadProgressBlock)progress
                   success:(DownloadSuccessBlock)success
                   failure:(DownloadFailureBlock)failure;

- (void)pauseWithURL:(NSURL *)URL;
- (void)resumeWithURL:(NSURL *)URL;
- (void)cancelWithURL:(NSURL *)URL;
- (void)cancelAndClearCachesWithURL:(NSURL *)URL;

- (void)pauseAll;
- (void)resumeAll;
- (void)cancelAll;
- (void)cancelAndClearCachesAll;
@end

NS_ASSUME_NONNULL_END
