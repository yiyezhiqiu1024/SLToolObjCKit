//
//  SLFileTool.m
//  SLToolObjCKit
//
//  Created by CoderSLZeng on 2017/11/22.
//

#import "SLFileTool.h"

@implementation SLFileTool
+ (BOOL)fileExist:(NSString *)filePath {
    if (0 == filePath.length) return NO;
    return [[NSFileManager defaultManager] fileExistsAtPath:filePath];
}

+ (NSInteger)fileSize:(NSString *)filePath {
    if (0 == filePath.length) return 0;

    NSDictionary *fileInfo = [[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:nil];
    return (NSInteger)[fileInfo fileSize];
}

+ (void)moveFile:(NSString *)atPath toPath:(NSString *)toPath {
    if (atPath == toPath) return;
    [[NSFileManager defaultManager] moveItemAtPath:atPath toPath:toPath error:nil];
}

+ (void)removeFile:(NSString *)filePath {
    [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
}

+ (void)directorySize:(NSString *)directoryPath completion:(void(^)(NSInteger))completion {
    // 获取文件管理者
    NSFileManager *mgr = [NSFileManager defaultManager];
    BOOL isDirectory;
    BOOL isExist = [mgr fileExistsAtPath:directoryPath isDirectory:&isDirectory];
    
    if (!isExist || !isDirectory) {
        // 抛异常
        // name:异常名称
        // reason:报错原因
        NSException *excp = [NSException exceptionWithName:@"pathError" reason:@"需要传入的是文件夹路径,并且路径要存在" userInfo:nil];
        [excp raise];
        
    }
    
    // 开启异步线程
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
                
        // 获取文件夹下所有的子路径,包含子路径的子路径
        NSArray *subPaths = [mgr subpathsAtPath:directoryPath];
        
        NSInteger totalSize = 0;
        
        for (NSString *subPath in subPaths) {
            // 获取文件全路径
            NSString *filePath = [directoryPath stringByAppendingPathComponent:subPath];
            
            // 判断隐藏文件
            if ([filePath containsString:@".DS"]) continue;
            
            // 判断是否文件夹
            BOOL isDirectory;
            // 判断文件是否存在,并且判断是否是文件夹
            BOOL isExist = [mgr fileExistsAtPath:filePath isDirectory:&isDirectory];
            if (!isExist || isDirectory) continue;
            
            // 获取文件属性
            // attributesOfItemAtPath:只能获取文件,不能获取文件夹
            NSDictionary *fileInfo = [mgr attributesOfItemAtPath:filePath error:nil];
            
            // 获取文件尺寸
            NSInteger fileSize = (NSInteger)[fileInfo fileSize];
            
            totalSize += fileSize;
        }
        
        // 计算完成回调,回到主线程
        dispatch_sync(dispatch_get_main_queue(), ^{
            if (completion) {
                completion(totalSize);
            }
        });
    });
}

+ (void)removeDirectory:(NSString *)directoryPath {
    // 获取文件管理者
    NSFileManager *mgr = [NSFileManager defaultManager];
    
    BOOL isDirectory;
    BOOL isExist = [mgr fileExistsAtPath:directoryPath isDirectory:&isDirectory];
    
    if (!isExist || !isDirectory) {
        // 抛异常
        // name:异常名称
        // reason:报错原因
        NSException *excp = [NSException exceptionWithName:@"pathError" reason:@"需要传入的是文件夹路径,并且路径要存在" userInfo:nil];
        [excp raise];                
    }
    
    // 获取cache文件夹下所有文件,不包括子路径的子路径
    NSArray *subPaths = [mgr contentsOfDirectoryAtPath:directoryPath error:nil];
    
    for (NSString *subPath in subPaths) {
        // 拼接完成全路径
        NSString *filePath = [directoryPath stringByAppendingPathComponent:subPath];
        
        // 删除路径
        [mgr removeItemAtPath:filePath error:nil];
    }

}


@end
