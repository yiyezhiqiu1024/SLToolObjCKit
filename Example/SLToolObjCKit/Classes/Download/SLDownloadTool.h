//
//  SLDownloadTool.h
//  SLToolObjCKit_Example
//
//  Created by CoderSLZeng on 2019/5/30.
//  Copyright © 2019 CoderSLZeng. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, SLDownloadState) {
    SLDownloadStatePause,
    SLDownloadStateDownloading,
    SLDownloadStateSuccess,
    SLDownloadStateFailed,

};

NS_ASSUME_NONNULL_BEGIN

@interface SLDownloadTool : NSObject

/**
 下载网络资源

 @param url 资源路径
 */
- (void)sl_downloadWithURL:(NSURL *)url;

/**
 暂停任务
 */
- (void)sl_pauseTask;

/**
 取消任务
 */
- (void)sl_cancelTask;

/**
 取消任务，并清理资源
 */
- (void)sl_cancelTaskAndCleanCaches;

/** 下载状态 */
@property (assign, nonatomic) SLDownloadState state;

@end

NS_ASSUME_NONNULL_END
