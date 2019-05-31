//
//  SLTimer.h
//  SLToolObjCKit
//
//  Created by CoderSLZeng on 2019/3/9.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SLTimer : NSObject

/**
 执行一个定时器任务
 
 @param task 任务的回调
 @param start 开始时间
 @param interval 延时时间
 @param isRepeats 是否重复
 @param isAsync 是否在异步执行
 @return 定时器标识
 */
+ (NSString *)excuteTask:(void(^)(void))task
                   start:(NSTimeInterval)start
                interval:(NSTimeInterval)interval
               isRepeats:(BOOL)isRepeats
                 isAsync:(BOOL)isAsync;

/**
 执行一个定时器任务
 
 @param target 执行任务对象
 @param selector 执行任务方法选择器
 @param start 开始时间
 @param interval 延时时间
 @param isRepeats 是否重复
 @param isAsync 是否在异步执行
 @return 定时器标识
 */
+ (NSString *)excuteTaskWithTarget:(id)target
                          selector:(SEL)selector
                             start:(NSTimeInterval)start
                          interval:(NSTimeInterval)interval
                         isRepeats:(BOOL)isRepeats
                           isAsync:(BOOL)isAsync;

/**
 取消定时器任务
 
 @param name 定时器标识
 */
+ (void)cancelTask:(NSString *)name;

@end

NS_ASSUME_NONNULL_END
