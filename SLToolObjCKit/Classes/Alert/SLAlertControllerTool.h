//
//  SLAlertTool.h
//  SLToolObjCKit
//
//  Created by CoderSLZeng on 2018/1/26.
//  弹框提示的控制器工具类
//

#import <Foundation/Foundation.h>

@interface SLAlertControllerTool : NSObject

+ (void)alertTitle:(NSString *)titile
              type:(UIAlertControllerStyle)alertType
           message:(NSString *)message
     didCancelTask:(void(^)(void))cancelTask
       didDoneTask:(void(^)(void))doneTask;

+ (void)alertTitle:(NSString *)titile
              type:(UIAlertControllerStyle)alertType
           message:(NSString *)message
       didDoneTask:(void(^)(void))doneTask;

+ (void)alertTitle:(NSString *)titile
              type:(UIAlertControllerStyle)alertType
           message:(NSString *)message
        controller:(UIViewController *)controller
       didDoneTask:(void(^)(void))doneTask;

+ (void)alertTitle:(NSString *)titile
              type:(UIAlertControllerStyle)alertType
           message:(NSString *)message
        controller:(UIViewController *)controller
     didCancelTask:(void(^)(void))cancelTask
       didDoneTask:(void(^)(void))doneTask;
@end
