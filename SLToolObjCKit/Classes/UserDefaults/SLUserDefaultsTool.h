//
//  SLUserDefaultsTool.h
//  SLToolObjeCKit
//
//  Created by CoderSLZeng on 2017/12/13.
//

#import <Foundation/Foundation.h>

@interface SLUserDefaultsTool : NSObject
+ (void)saveObject:(NSString *)object key:(NSString *)key;
+ (void)clearObjectForKey:(NSString *)key;
+ (void)saveBool:(BOOL )value key:(NSString *)key;
@end
