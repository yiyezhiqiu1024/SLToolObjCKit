//
//  SLAlertTool.h
//  PartyConstruction
//
//  Created by CoderSLZeng on 2018/1/26.
//  Copyright © 2018年 linson. All rights reserved.
//  弹框提示的控制器工具类
//

#import <Foundation/Foundation.h>

@interface SLAlertControllerTool : NSObject

+ (void)sl_alertTitle:(NSString *)titile type:(UIAlertControllerStyle)alertType message:(NSString *)message didCancelTask:(void(^)(void))cancelTask didDoneTask:(void(^)(void))doneTask;

+ (void)sl_alertTitle:(NSString *)titile type:(UIAlertControllerStyle)alertType message:(NSString *)message didDoneTask:(void(^)(void))doneTask;

+ (void)sl_alertTitle:(NSString *)titile type:(UIAlertControllerStyle)alertType message:(NSString *)message controller:(UIViewController *)controller didDoneTask:(void(^)(void))doneTask;

+ (void)sl_alertTitle:(NSString *)titile type:(UIAlertControllerStyle)alertType message:(NSString *)message controller:(UIViewController *)controller didCancelTask:(void(^)(void))cancelTask didDoneTask:(void(^)(void))doneTask;
@end
