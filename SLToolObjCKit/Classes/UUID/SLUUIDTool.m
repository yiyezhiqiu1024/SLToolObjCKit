//
//  SLUUIDTool.m
//  SLToolObjCKit_Example
//
//  Created by CoderSLZeng on 2019/6/27.
//  Copyright © 2019 CoderSLZeng. All rights reserved.
//

#import "SLUUIDTool.h"

@implementation SLUUIDTool

+ (NSString *)UUID {
    CFUUIDRef UUIDRef = CFUUIDCreate(nil);
    CFStringRef stringRef = CFUUIDCreateString(nil, UUIDRef);
    NSString *result = (NSString *)CFBridgingRelease(CFStringCreateCopy(NULL, stringRef));
    CFRelease(UUIDRef);
    CFRelease(stringRef);
    return result;
}


+ (NSString *)UUIDByKeychainForClass:(Class)aClass {
    
    // 1.直接从keychain中获取UUID
    NSDictionary *infoDict = [NSBundle bundleForClass:aClass].infoDictionary;
    NSString *kUUIDKey = [infoDict objectForKey:@"CFBundleIdentifier"];
    NSString *getUDIDInKeychain = (NSString *)[self load:kUUIDKey];
//    NSLog(@"从keychain中获取UUID%@", getUDIDInKeychain);
    
    // 2.如果获取不到，需要生成UUID并存入系统中的keychain
    if (!getUDIDInKeychain || [getUDIDInKeychain isEqualToString:@""] || [getUDIDInKeychain isKindOfClass:[NSNull class]]) {
        // 2.1 生成UUID
        NSString *UUID = [self UUID];
        
//        NSLog(@"生成UUID：%@", UUID);
        // 2.2 将生成的UUID保存到keychain中
        [self save:kUUIDKey data:UUID];
        // 2.3 从keychain中获取UUID
        getUDIDInKeychain = (NSString *)[self load:kUUIDKey];
    }
    return getUDIDInKeychain;
}

    
+ (void)deleteUUIDByKeyChain:(NSString *)bundleIdentifier {
    [self delete:bundleIdentifier];
}


#pragma mark - 私有方法
+ (NSMutableDictionary *)queryByKeyChain:(NSString *)bundleIdentifier {
    return [NSMutableDictionary dictionaryWithObjectsAndKeys:(id)kSecClassGenericPassword, (id)kSecClass, bundleIdentifier, (id)kSecAttrService, bundleIdentifier, (id)kSecAttrAccount, (id)kSecAttrAccessibleAfterFirstUnlock,(id)kSecAttrAccessible, nil];
}

// 从keychain中获取UUID
+ (id)load:(NSString *)bundleIdentifier {
    id ret = nil;
    NSMutableDictionary *keychainQuery = [self queryByKeyChain:bundleIdentifier];
    [keychainQuery setObject:(id)kCFBooleanTrue forKey:(id)kSecReturnData];
    [keychainQuery setObject:(id)kSecMatchLimitOne forKey:(id)kSecMatchLimit];
    CFDataRef keyData = NULL;
    if (SecItemCopyMatching((CFDictionaryRef)keychainQuery, (CFTypeRef *)&keyData) == noErr) {
        @try {
            ret = [NSKeyedUnarchiver unarchiveObjectWithData:(__bridge NSData *)keyData];
        }
        @catch (NSException *exception) {
            NSLog(@"Unarchive of %@ failed: %@", bundleIdentifier, exception);
        }
        @finally {
            NSLog(@"finally");
        }
    }
    
    if (keyData) {
        CFRelease(keyData);
    }
//    NSLog(@"ret = %@", ret);
    return ret;
}

+ (void)delete:(NSString *)bundleIdentifier {
    NSMutableDictionary *keychainDict = [self queryByKeyChain:bundleIdentifier];
    SecItemDelete((CFDictionaryRef)keychainDict);
}

// 将生成的UUID保存到keychain中
+ (void)save:(NSString *)bundleIdentifier data:(id)data {
    NSMutableDictionary *keychainDict = [self queryByKeyChain:bundleIdentifier];
    SecItemDelete((CFDictionaryRef)keychainDict);
    [keychainDict setObject:[NSKeyedArchiver archivedDataWithRootObject:data] forKey:(id)kSecValueData];
    SecItemAdd((CFDictionaryRef)keychainDict, NULL);
}
@end
