//
//  NSString+SLMD5.h
//  SLCategoryObjCKit
//
//  Created by CoderSLZeng on 2019/5/31.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (SLMD5)

/**
 计算md5值计
 
 @return md5值
 */
- (NSString *)sl_md5;

@end

NS_ASSUME_NONNULL_END
