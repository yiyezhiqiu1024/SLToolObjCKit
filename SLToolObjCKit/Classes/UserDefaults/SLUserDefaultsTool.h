//
//  SLUserDefaultsTool.h
//  PartyConstruction
//
//  Created by CoderSLZeng on 2017/12/13.
//  Copyright © 2017年 linson. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SLUserDefaultsTool : NSObject
+ (void)sl_saveObject:(NSString *)object key:(NSString *)key;
+ (void)sl_clearObjectForKey:(NSString *)key;
+ (void)sl_saveBool:(BOOL )value key:(NSString *)key;
@end
