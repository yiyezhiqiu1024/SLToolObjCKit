//
//  SLFileTool.h
//  SLToolObjCKit
//
//  Created by CoderSLZeng on 2017/11/22.
//  文件管理工具类
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SLFileTool : NSObject

/**
 文件是否存在
 
 @param filePath 文件路径
 */
+ (BOOL)fileExist:(NSString *)filePath;

/**
 获取文件的大小

 @param filePath 文件路径
 @return 文件大小
 */
+ (NSInteger)fileSize:(NSString *)filePath;

/**
 删除文件
 
 @param filePath 文件路径
 */
+ (void)removeFile:(NSString *)filePath;

/**
 移动文件

 @param atPath 所在路径
 @param toPath 目标路径
 */
+ (void)moveFile:(NSString *)atPath toPath:(NSString *)toPath;

/**
 获取文件夹的大小

 @param directoryPath 文件夹路径
 @param completion 完成之后的回调
 */
+ (void)directorySize:(NSString *)directoryPath completion:(void(^)(NSInteger))completion;


/**
 删除文件夹所有文件

 @param directoryPath 文件夹路径
 */
+ (void)removeDirectory:(NSString *)directoryPath;


NS_ASSUME_NONNULL_END

@end
