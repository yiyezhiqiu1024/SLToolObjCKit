//
//  SLProxy.m
//  SLToolObjCKit
//
//  Created by CoderSLZeng on 2019/3/8.
//

#import "SLProxy.h"

@implementation SLProxy

+ (instancetype)sl_proxyWithTarget:(id)targe {
    SLProxy *proxy = [SLProxy alloc];
    proxy.target = targe;
    return proxy;
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)sel {
    return [self.target methodSignatureForSelector:sel];
}

- (void)forwardInvocation:(NSInvocation *)invocation {
    [invocation invokeWithTarget:self.target];
}

@end
