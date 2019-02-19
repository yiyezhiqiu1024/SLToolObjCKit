//
//  SLUserDefaultsTool.m
//  PartyConstruction
//
//  Created by CoderSLZeng on 2017/12/13.
//  Copyright © 2017年 linson. All rights reserved.
//

#import "SLUserDefaultsTool.h"

@implementation SLUserDefaultsTool
+ (void)sl_saveObject:(NSString *)object key:(NSString *)key
{
    NSUserDefaults *Defaults = [NSUserDefaults standardUserDefaults];
    [Defaults setObject:object forKey:key];
    [Defaults synchronize];
}

+ (void)sl_clearObjectForKey:(NSString *)key
{
    NSUserDefaults *Defaults = [NSUserDefaults standardUserDefaults];
    [Defaults removeObjectForKey:key];
    [Defaults synchronize];
}

+ (void)sl_saveBool:(BOOL )value key:(NSString *)key
{
    NSUserDefaults *Defaults = [NSUserDefaults standardUserDefaults];
    [Defaults setBool:value forKey:key];
    [Defaults synchronize];
}

@end
