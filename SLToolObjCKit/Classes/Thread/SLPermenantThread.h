//
//  SLPermenantThread.h
//  SLToolObjCKit
//
//  Created by CoderSLZeng on 2019/3/7.
//  永久线程（线程保活功能）
//

#import <Foundation/Foundation.h>

typedef void(^SLPermenantThreadTask)(void);

NS_ASSUME_NONNULL_BEGIN

/** 初始化默认开启线程 **/
@interface SLPermenantThread : NSObject

/**
 在当前子线程执行一个任务

 @param task 任务
 */
- (void)sl_executeTask:(SLPermenantThreadTask)task;

/**
 停止线程
 */
- (void)sl_stop;

@end

NS_ASSUME_NONNULL_END
