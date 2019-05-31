//
//  SLTimer.m
//  SLToolObjCKit
//
//  Created by CoderSLZeng on 2019/3/9.
//

#import "SLTimer.h"

@implementation SLTimer

static NSMutableDictionary *timers_;
static dispatch_semaphore_t semaphonre_;

+ (void)initialize {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        timers_ = [NSMutableDictionary dictionary];
        semaphonre_ = dispatch_semaphore_create(1);
    });
}

+ (NSString *)excuteTask:(void(^)(void))task
                   start:(NSTimeInterval)start
                interval:(NSTimeInterval)interval
               isRepeats:(BOOL)isRepeats
                 isAsync:(BOOL)isAsync {
    
    if (!task || start < 0 || (interval <= 0 && isRepeats)) return nil;
    
    // 队列
    dispatch_queue_t queue = isAsync ? dispatch_get_global_queue(0, 0) : dispatch_get_main_queue();
    
    // 创建定时器
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(timer, dispatch_time(DISPATCH_TIME_NOW, start * NSEC_PER_SEC), interval * NSEC_PER_SEC, 0);
    
    // 加锁
    dispatch_semaphore_wait(semaphonre_, DISPATCH_TIME_FOREVER);
    
    // 定时器的唯一标识
    NSString *name = [NSString stringWithFormat:@"%zd", timers_.count];
    // 存放到字典中
    timers_[name] = timer;
    
    // 解锁
    dispatch_semaphore_signal(semaphonre_);
    
    // 设置回调
    dispatch_source_set_event_handler(timer, ^{
        task();
        
        if (!isRepeats) { // 不重复的，取消任务
            [self cancelTask:name];
        }
    });
    
    // 启动定时器
    dispatch_resume(timer);
    
    return name;
}

+ (NSString *)excuteTaskWithTarget:(id)target
                          selector:(SEL)selector
                             start:(NSTimeInterval)start
                          interval:(NSTimeInterval)interval
                         isRepeats:(BOOL)isRepeats
                           isAsync:(BOOL)isAsync; {
    
    if (!target || !selector) return nil;
    
    return [self excuteTask: ^{
        
        if ([target respondsToSelector:selector])  {
            
            // 消除警告的处理
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks" // 警告消息
            [target performSelector:selector];
#pragma clang diagnostic pop
            
        }
    }
                      start:start
                   interval:interval
                  isRepeats:isRepeats
                    isAsync:isAsync];
}

+ (void)cancelTask:(NSString *)name {
    if (0 == name.length) return;
    
    // 加锁
    dispatch_semaphore_wait(semaphonre_, DISPATCH_TIME_FOREVER);
    
    dispatch_source_t timer = timers_[name];
    if (timer) {
        dispatch_source_cancel(timer);
        [timers_ removeObjectForKey:name];
    }
    
    // 解锁
    dispatch_semaphore_signal(semaphonre_);
    
}

@end
