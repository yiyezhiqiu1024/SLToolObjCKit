//
//  SLUUIDTool.h
//  SLToolObjCKit_Example
//
//  Created by CoderSLZeng on 2019/6/27.
//  Copyright © 2019 CoderSLZeng. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SLUUIDTool : NSObject

/**
 获取设备UUID，每次获得一个新的UUID标识符

 @return UUID
 */
+ (NSString *)UUID;

/**
 获取到UUID后存入系统中的keychain中，保证以后每次可以得到相同的唯一标志
 不用添加plist文件，当程序删除后重装，仍可以得到相同的唯一标示
 但是当系统升级或者刷机后，系统中的钥匙串会被清空，再次获取的UUID会与之前的不同
 
 @return keychain中存储的UUID
 */
+ (NSString *)UUIDByKeychainForClass:(Class)aClass;

/**
 删除存储在keychain中的UUID
 如果删除后，重新获取用户的UUID会与之前的UUID不同
 */
+ (void)deleteUUIDByKeyChain:(NSString *)bundleIdentifier;

@end

NS_ASSUME_NONNULL_END
