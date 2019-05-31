//
//  NSString+SLMD5.m
//  SLCategoryObjCKit
//
//  Created by CoderSLZeng on 2019/5/31.
//

#import "NSString+SLMD5.h"
#import <SLCategoryObjCKit/NSString+SLExtension.h>
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (SLMD5)

- (NSString *)sl_md5 {
    const char *data = self.UTF8String;
    int count = CC_MD5_DIGEST_LENGTH;
    unsigned char md5[count];
    // 把C语言的字符串 -> md5 c字符串
    CC_MD5(data, (CC_LONG)strlen(data), md5);
    
    // 32
    NSMutableString *result = [NSMutableString stringWithCapacity:count << 1];
    for (int i = 0; i < count; i++) {
        [result appendFormat:@"%02x", md5[i]];
    }
    return result;
    
    
}

@end
