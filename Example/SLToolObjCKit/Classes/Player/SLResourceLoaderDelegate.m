//
//  SLResourceLoaderDelegate.m
//  SLToolObjCKit
//
//  Created by CoderSLZeng on 2019/6/3.
//

#import "SLResourceLoaderDelegate.h"
#import "SLAudioDownloader.h"
#import "NSURL+SLExtension.h"
#import "SLPlayerAudioFile.h"

@interface SLResourceLoaderDelegate ()<SLAudioDownloaderDelegate>
/** 下载器 */
@property (strong, nonatomic) SLAudioDownloader *downloader;

/** 正在加载请求数据的容器 */
@property (strong, nonatomic) NSMutableArray *loadingRequests;

@end

@implementation SLResourceLoaderDelegate

// 当外界, 需要播放一段音频资源时, 会跑一个请求, 给这个对象
// 这个对象, 到时候, 只需要根据请求信息, 抛数据给外界
- (BOOL)resourceLoader:(AVAssetResourceLoader *)resourceLoader
shouldWaitForLoadingOfRequestedResource:(AVAssetResourceLoadingRequest *)loadingRequest {
    
    // 1.下载需要使用http协议
    NSURL *URL = [loadingRequest.request.URL sl_httpURL];
    
    // 2.获取加载开始时间位置
    long long requestOffset = loadingRequest.dataRequest.requestedOffset;
    long long currentOffset = loadingRequest.dataRequest.currentOffset;
    if (requestOffset != currentOffset) {
        requestOffset = currentOffset;
    }
    
    // 2. 判断, 本地有没有该音频资源的缓存文件
    if ([SLPlayerAudioFile cacheFilePath:URL]) {
        // 直接根据本地缓存, 向外界响应数据(3个步骤) return
        [self handleLoadingRequest:loadingRequest];
        return YES;
    }
    
    // 3.记录所有的请求
    [self.loadingRequests addObject:loadingRequest];
    
    // 4.判断有没有正在下载
    if (0 == self.downloader.loadedSize) {
        [self.downloader downloadWithURL:URL offset:requestOffset];
        return YES;
    }
    
    // 3.判断当前是否需要重新下载
    // 3.1 当资源的请求, 开始点 < 下载的开始点
    // 3.2 当资源的请求, 开始点 > 下载的开始点 + 下载的长度 + 666
    if (requestOffset < self.downloader.offset || requestOffset > (self.downloader.offset + self.downloader.loadedSize + 666)) {
        [self.downloader downloadWithURL:URL offset:requestOffset];
        return YES;
    }
    
    // 4.开始处理资源请求（在下载过程当中也要不断的判断)
    [self handleAllLoadingRequest];
    
    return YES;
}

// 取消请求
- (void)resourceLoader:(AVAssetResourceLoader *)resourceLoader
didCancelLoadingRequest:(nonnull AVAssetResourceLoadingRequest *)loadingRequest {
    NSLog(@"取消某个请求");
    [self.loadingRequests removeObject:loadingRequest];
}

#pragma mark - SLAudioDownloaderDelegate
- (void)downloading {
    [self handleAllLoadingRequest];
}

#pragma mark - Private methond
- (void)handleAllLoadingRequest {
    
    NSMutableArray *deleteRequests = [NSMutableArray array];
    for (AVAssetResourceLoadingRequest *loadingRequest in self.loadingRequests) {
        // 1.填充内容信息头
        NSURL *URL = loadingRequest.request.URL;
        loadingRequest.contentInformationRequest.contentLength = self.downloader.totalSize;
        loadingRequest.contentInformationRequest.contentType = self.downloader.MIMEType;
        loadingRequest.contentInformationRequest.byteRangeAccessSupported = YES;
        
        // 2.填充数据
        // 2.1.先从临时文件中取数据
        NSData *data = [NSData dataWithContentsOfFile:[SLPlayerAudioFile tempFilePath:URL]
                                              options:NSDataReadingMappedIfSafe
                                                error:nil];
        // 2.2.如果临时文件没有，表示下载完成，到缓存文件中取数据
        if (data == nil) {
            data = [NSData dataWithContentsOfFile:[SLPlayerAudioFile cacheFilePath:URL]
                                          options:NSDataReadingMappedIfSafe
                                            error:nil];
        }
        
        // 2.3.获取加载的请求时间点
        long long requestOffest = loadingRequest.dataRequest.requestedOffset;
        // 2.4.当前正在加载的请求时间点
        long long currentOffset = loadingRequest.dataRequest.currentOffset;
        if (requestOffest != currentOffset) {
            requestOffest = currentOffset;
        }
        
        // 2.5.请求的加载时间长度
        NSInteger requestedLength = loadingRequest.dataRequest.requestedLength;
        
        // 2.6.计算加载时间的区间
        long long reponseOffset = requestOffest - self.downloader.offset;
        long long reponseLength = MIN(self.downloader.offset + self.downloader.loadedSize - requestOffest, requestedLength);
        NSData *subData = [data subdataWithRange:NSMakeRange((NSUInteger)reponseOffset, (NSUInteger)reponseLength)];
        [loadingRequest.dataRequest respondWithData:subData];
        
        // 3.完成请求（必须把所有的关于这个请求的区间数据，都返回之后，才能完成这个请求）
        if (requestedLength == requestOffest) {
            [loadingRequest finishLoading];
            [deleteRequests addObject:loadingRequest];
        }
    }
    
    [self.loadingRequests removeObjectsInArray:deleteRequests];
    
}

- (void)handleLoadingRequest:(AVAssetResourceLoadingRequest *)loadingRequest {
    // 1.填充相应的信息头信息
    NSURL *URL = loadingRequest.request.URL;
    long long contentLength = [SLPlayerAudioFile cacheFileSize:URL];
    loadingRequest.contentInformationRequest.contentLength = contentLength;
    
    NSString *contentType = [SLPlayerAudioFile contentType:URL];
    loadingRequest.contentInformationRequest.contentType = contentType;
    
    loadingRequest.contentInformationRequest.byteRangeAccessSupported = YES;
    
    // 2.相应数据给外界
    NSData *data = [NSData dataWithContentsOfFile:[SLPlayerAudioFile cacheFilePath:URL]
                                          options:NSDataReadingMappedIfSafe
                                            error:nil];
    
    long long requesetOffset = loadingRequest.dataRequest.requestedOffset;
    NSInteger requesetLength = loadingRequest.dataRequest.requestedLength;
    
    NSData *subData = [data subdataWithRange:NSMakeRange((NSUInteger)requesetOffset, requesetLength)];
    [loadingRequest.dataRequest respondWithData:subData];
    
    // 3.完成本次请求（一旦，所有的数据都给完了，才能调用完成请求方法）
    [loadingRequest finishLoading];
}

#pragma mark - Getter
- (SLAudioDownloader *)downloader {
    if (!_downloader) {
        _downloader = [[SLAudioDownloader alloc] init];
        _downloader.delegate = self;
    }
    
    return _downloader;
}

- (NSMutableArray *)loadingRequests {
    if (!_loadingRequests) _loadingRequests = [NSMutableArray array];
    
    return _loadingRequests;
}


@end
