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
+ (instancetype)sharedInstance;

/**
 下载网络资源

 @param URL 网络资源路径
 @param info 下载信息
 @param progress 下载进度
 @param success 下载成功
 @param failure 下载失败
 */
- (void)downloadWithURL:(NSURL *)URL
                      info:(DownloadInfoBlock)info
                  progress:(DownloadProgressBlock)progress
                   success:(DownloadSuccessBlock)success
                   failure:(DownloadFailureBlock)failure;

/**
 暂停下载

 @param URL 资源路径
 */
- (void)pauseWithURL:(NSURL *)URL;

/**
 继续下载

 @param URL 资源路径
 */
- (void)resumeWithURL:(NSURL *)URL;

/**
 取消下载

 @param URL 资源路径
 */
- (void)cancelWithURL:(NSURL *)URL;

/**
 取消下载并且清除缓存文件

 @param URL 网络资源
 */
- (void)cancelAndCleanCachesWithURL:(NSURL *)URL;

/**
 暂停所有下载
 */
- (void)pauseAll;

/**
 继续所有下载
 */
- (void)resumeAll;

/**
 取消所有下载
 */
- (void)cancelAll;

/**
 徐晓所有下载并且清除所有缓存文件
 */
- (void)cancelAndCleanCachesAll;
@end

NS_ASSUME_NONNULL_END
