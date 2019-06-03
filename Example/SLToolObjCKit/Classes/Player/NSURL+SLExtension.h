//
//  NSURL+SLExtension.h
//  SLToolObjCKit_Example
//
//  Created by CoderSLZeng on 2019/6/3.
//  Copyright © 2019 CoderSLZeng. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSURL (SLExtension)
/**
 @return steaming协议的资源
 */
- (NSURL *)sl_sreamingURL;

/**
 @return http协议的资源
 */
- (NSURL *)sl_httpURL;
@end

NS_ASSUME_NONNULL_END
