//
//  SLPlayerAudioFile.h
//  SLToolObjCKit_Example
//
//  Created by CoderSLZeng on 2019/6/3.
//  Copyright © 2019 CoderSLZeng. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SLPlayerAudioFile : NSObject

+ (NSString *)cacheFilePath:(NSURL *)URL;
+ (long long)cacheFileSize:(NSURL *)URL;
+ (BOOL)cacheFileExists:(NSURL *)URL;

+ (NSString *)tempFilePath:(NSURL *)URL;
+ (long long)tempFileSize:(NSURL *)URL;
+ (BOOL)tempFileExists:(NSURL *)URL;
+ (void)cleanTempFile:(NSURL *)URL;

+ (NSString *)contentType:(NSURL *)URL;
+ (void)moveTempPathToCachePath:(NSURL *)URL;

@end

NS_ASSUME_NONNULL_END
