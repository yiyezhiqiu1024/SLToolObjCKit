//
//  SLProxy.h
//  SLToolObjCKit
//
//  Created by CoderSLZeng on 2019/3/8.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SLProxy : NSProxy

/** target */
@property (weak, nonatomic) id target;

+ (instancetype)proxyWithTarget:(id)targe;

@end

NS_ASSUME_NONNULL_END
