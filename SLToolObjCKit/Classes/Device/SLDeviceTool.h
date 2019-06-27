//
//  SLDeviceTool.h
//  SLToolObjCKit_Example
//
//  Created by CoderSLZeng on 2019/6/27.
//  Copyright © 2019 CoderSLZeng. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SLDeviceTool : NSObject
/**
 获取App版本

 @param aClass 类名
 @return App版本
 */
+ (NSString *)appVersionWithBundleForClass:(Class)aClass;

/**
 获取当前App的BundleIdentifier
 
 @param aClass 类名
 @return BundleIdentifier
 */
+ (NSString *)bundleIdentifierWithBundleForClass:(Class)aClass;
/**
 获取当前时间的时间戳

 @return 时间戳
 */
+ (int)getDateByInt;

/**
 获取设备信息

 @return 设备信息
 */
+ (NSDictionary *)deviceInfo;

/**
 获取设备

 @return 设备mac地址
 */
+ (nullable NSString *)macAddress;

//
/**
 获取设备IP地址

 @param v4 是否v4
 @return ip 地址
 */
+ (NSString *)ipAddressIsV4:(BOOL)v4;

/**
 获取设备信息 产品名称

 @return 设备信息 产品名称
 */
+ (NSString *)deviceName;

/**
 获取设备模式
 
 @return 设备模式
 */
+ (NSString *)deviceModel;

/**
 获取机型信息
 
 @return 机型信息
 */
+ (NSString *)deviceModelName;

/**
 是否越狱

 @return 是否越狱
 */
+ (BOOL)jailbroken;

/**
 查看运营商

 @return 运营商
 */
+ (NSString *)chinaMobileModel;

/**
 获取系统版本
 
 @return 系统版本
 */
+ (NSString *)systemVersion;

/**
 判断当前网络连接状态

 @return 网络连接状态
 */
+(NSString *)netWorkStates;

@end

NS_ASSUME_NONNULL_END

