//
//  SLUserDefaultsTool.m
//  SLToolObjeCKit
//
//  Created by CoderSLZeng on 2017/12/13.
//

#import "SLUserDefaultsTool.h"

@implementation SLUserDefaultsTool
+ (void)saveObject:(NSString *)object key:(NSString *)key
{
    NSUserDefaults *Defaults = [NSUserDefaults standardUserDefaults];
    [Defaults setObject:object forKey:key];
    [Defaults synchronize];
}

+ (void)clearObjectForKey:(NSString *)key
{
    NSUserDefaults *Defaults = [NSUserDefaults standardUserDefaults];
    [Defaults removeObjectForKey:key];
    [Defaults synchronize];
}

+ (void)saveBool:(BOOL )value key:(NSString *)key
{
    NSUserDefaults *Defaults = [NSUserDefaults standardUserDefaults];
    [Defaults setBool:value forKey:key];
    [Defaults synchronize];
}

@end
