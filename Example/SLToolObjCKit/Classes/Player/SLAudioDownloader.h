//
//  SLAudioDownloader.h
//  SLToolObjCKit_Example
//
//  Created by CoderSLZeng on 2019/6/3.
//  Copyright © 2019 CoderSLZeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SLAudioDownloaderDelegate <NSObject>

- (void)downloading;

@end

NS_ASSUME_NONNULL_BEGIN

@interface SLAudioDownloader : NSObject
/** 总大小 */
@property (assign, nonatomic) long long totalSize;
/** 已加载的大小 */
@property (assign, nonatomic) long long loadedSize;
/** 偏移量 */
@property (assign, nonatomic) long long offset;
/** 类型 */
@property (copy, nonatomic) NSString *MIMEType;

- (void)downloadWithURL:(NSURL *)URL offset:(long long)offset;

/** 代理 */
@property (weak, nonatomic) id<SLAudioDownloaderDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
