//
//  SLFileTool.h
//  SLToolKit
//
//  Created by CoderSLZeng on 2017/11/22.
//  文件管理工具类
//

#import <Foundation/Foundation.h>

@interface SLFileTool : NSObject

/**
 *  根据一个文件夹路径计算出文件夹的大小
 *
 *  @param directoryPath 文件夹路径
 *  @param completion    完成之后的回调
 */
+ (void)sl_getFileSize:(NSString *)directoryPath completion:(void(^)(NSInteger))completion;


/**
 *  删除文件夹所有文件
 *
 *  @param directoryPath 文件夹路径
 */
+ (void)sl_removeDirectoryPath:(NSString *)directoryPath;

@end
