//
//  SLPermenantThread.m
//  SLToolObjCKit
//
//  Created by CoderSLZeng on 2019/3/7.
//

#import "SLPermenantThread.h"
#import "SLProxy.h"

@interface SLThread : NSThread
@end

@implementation SLThread

- (void)dealloc {
    //    NSLog(@"%s", __func__);
}
@end

@interface SLPermenantThread ()

/** 自定义线程 */
@property (strong, nonatomic) SLThread *innerThread;
/** 是否停止线程 */
@property (assign, nonatomic, getter=isStopped) BOOL stopped;

@end

@implementation SLPermenantThread

#pragma mark - Public methods

/**
 初始化线程，默认开启
 
 @return 线程
 */
- (instancetype)init {
    if (self = [super init]) {
        self.stopped = NO;
        
        if (@available(iOS 10.0, *)) {
            
            __weak typeof(self) weakSelf = self;
            self.innerThread = [[SLThread alloc] initWithBlock:^{
                
                // 往RunLoop里面添加Source\Timer\Observer
                [[NSRunLoop currentRunLoop] addPort:[[NSPort alloc] init]
                                            forMode:NSDefaultRunLoopMode];
                
                while (weakSelf && !weakSelf.isStopped) {
                    
                    [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode
                                             beforeDate:[NSDate distantFuture]];
                }
                
                /*
                 // C语言
                 // 创建上下文（要初始化一下结构体）
                 CFRunLoopSourceContext context = { 0 };
                 
                 // 创建source
                 CFRunLoopSourceRef sourceRef = CFRunLoopSourceCreate(kCFAllocatorDefault, 0, &context);
                 
                 // 往Runloop中添加source
                 CFRunLoopAddSource(CFRunLoopGetCurrent(), sourceRef, kCFRunLoopDefaultMode);
                 
                 // 销毁source
                 CFRelease(sourceRef);
                 
                 // 启动
                 CFRunLoopRunInMode(kCFRunLoopDefaultMode, 1.0e10, false);
                 
                 //    while (weakSelf && !weakSelf.isStopped) {
                 //        // 第3个参数：returnAfterSourceHandled，设置为true，代表执行完source后就会退出当前loop
                 //        CFRunLoopRunInMode(kCFRunLoopDefaultMode, 1.0e10, true);
                 //    }
                 
                 NSLog(@"线程结束");
                 */
            }];
        } else {
            
            self.innerThread = [[SLThread alloc] initWithTarget:[SLProxy proxyWithTarget:self]
                                                       selector:@selector(__addRunloop)
                                                         object:nil];
        }
        
        
        [self.innerThread start];
    }
    
    return self;
}

- (void)executeTask:(SLPermenantThreadTask)task {
    
    if (!self.innerThread || !task) return;
    
    [self performSelector:@selector(__executeTask:)
                 onThread:self.innerThread
               withObject:task
            waitUntilDone:NO];
}

- (void)stop {
    
    if (!self.innerThread) return;
    
    [self performSelector:@selector(__stop)
                 onThread:self.innerThread
               withObject:nil
            waitUntilDone:YES];
}

- (void)dealloc {
    //    NSLog(@"%s", __func__);
    [self stop];
}

#pragma mark - Private methods
- (void)__executeTask:(SLPermenantThreadTask)task {
    task();
}

- (void)__stop {
    
    self.stopped = YES;
    CFRunLoopStop(CFRunLoopGetCurrent());
    self.innerThread = nil;
}

- (void)__addRunloop {
    
    //    NSLog(@"开启线程");
    
    [[NSRunLoop currentRunLoop] addPort:[[NSPort alloc] init]
                                forMode:NSDefaultRunLoopMode];
    
    while (self && !self.isStopped) {
        //        NSLog(@"self = %@", self);
        //        NSLog(@"stopped = %d", self.isStopped);
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode
                                 beforeDate:[NSDate distantFuture]];
    }
    
    //    NSLog(@"结束线程");
}



@end



