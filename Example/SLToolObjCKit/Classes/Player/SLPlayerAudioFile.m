//
//  SLPlayerAudioFile.m
//  SLToolObjCKit_Example
//
//  Created by CoderSLZeng on 2019/6/3.
//  Copyright © 2019 CoderSLZeng. All rights reserved.
//

#import "SLPlayerAudioFile.h"
#import <MobileCoreServices/MobileCoreServices.h>

#define kCachePath NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject
#define kTempPath NSTemporaryDirectory()

@implementation SLPlayerAudioFile

+ (NSString *)cacheFilePath:(NSURL *)URL {
    return [kCachePath stringByAppendingPathComponent:URL.lastPathComponent];
}


+ (long long)cacheFileSize:(NSURL *)URL {
    if (![self cacheFileExists:URL]) return 0;
    
    NSString *path = [self cacheFilePath:URL];
    NSDictionary *fileInfoDict = [[NSFileManager defaultManager] attributesOfItemAtPath:path error:nil];
    return [fileInfoDict[NSFileSize] longLongValue];
}

+ (BOOL)cacheFileExists:(NSURL *)URL {
    NSString *path = [self cacheFilePath:URL];
    return [[NSFileManager defaultManager] fileExistsAtPath:path];
}

+ (NSString *)tempFilePath:(NSURL *)URL {
    return [kTempPath stringByAppendingPathComponent:URL.lastPathComponent];
}

+ (long long)tempFileSize:(NSURL *)URL {
    if (![self tempFileExists:URL]) return 0;
    
    NSString *path = [self tempFilePath:URL];
    NSDictionary *fileInfoDict = [[NSFileManager defaultManager] attributesOfItemAtPath:path error:nil];
    return [fileInfoDict[NSFileSize] longLongValue];
}

+ (BOOL)tempFileExists:(NSURL *)URL {
    NSString *path = [self tempFilePath:URL];
    return [[NSFileManager defaultManager] fileExistsAtPath:path];
}

+ (void)cleanTempFile:(NSURL *)URL {
    NSString *path = [self tempFilePath:URL];
    BOOL isDirectory = YES;
    BOOL isExist = [[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&isDirectory];
    if (isExist && !isDirectory) {
        [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
    }
}

+ (NSString *)contentType:(NSURL *)URL {
    NSString *path = [self cacheFilePath:URL];
    NSString *fileExtension = path.pathExtension;
    
    CFStringRef contentTypeCF = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, (__bridge CFStringRef _Nonnull)(fileExtension), NULL);
    NSString *contentType = CFBridgingRelease(contentTypeCF);
    return contentType;
}

+ (void)moveTempPathToCachePath:(NSURL *)URL {
    NSString *tempPath = [self tempFilePath:URL];
    NSString *cachePath = [self cacheFilePath:URL];
    [[NSFileManager defaultManager] moveItemAtPath:tempPath toPath:cachePath error:nil];
}

@end
