//
//  SLDownloadTool.h
//  SLToolObjCKit
//
//  Created by CoderSLZeng on 2019/5/30.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, SLDownloadState) {
    SLDownloadStatePause,
    SLDownloadStateDownloading,
    SLDownloadStateSuccess,
    SLDownloadStateFailure,
};

typedef void(^DownloadInfoBlock)(NSInteger totalSize);
typedef void(^DownloadProgressBlock)(float progress);
typedef void(^DownloadSuccessBlock)(NSString * _Nonnull filePath);
typedef void(^DownloadFailureBlock)(void);
typedef void(^DownloadStateBlock)(SLDownloadState state);

NS_ASSUME_NONNULL_BEGIN

@interface SLDownloadTool : NSObject

- (void)downloadWithURL:(NSURL *)URL
   info:(DownloadInfoBlock)info
           progress:(DownloadProgressBlock)progress
            success:(DownloadSuccessBlock)success
             failure:(DownloadFailureBlock)failure;

/**
 下载网络资源

 @param URL 资源路径
 */
- (void)downloadWithURL:(NSURL *)URL;

/**
 继续下载
 */
- (void)resumeDownload;

/**
 暂停下载
 */
- (void)pauseDownload;

/**
 取消下载
 */
- (void)cancelDownload;

/**
 取消下载，并清理资源
 */
- (void)cancelDownloadAndCleanCaches;

/** 下载状态 */
@property (assign, nonatomic, readonly) SLDownloadState state;

/** 下载进度 */
@property (nonatomic, assign, readonly) NSInteger progress;

@end

NS_ASSUME_NONNULL_END
