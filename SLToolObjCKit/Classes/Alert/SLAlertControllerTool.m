//
//  SLAlertTool.m
//  SLToolObjCKit
//
//  Created by CoderSLZeng on 2018/1/26.
//

#import "SLAlertControllerTool.h"

@implementation SLAlertControllerTool
+ (void)alertTitle:(NSString *)titile
              type:(UIAlertControllerStyle)alertType
           message:(NSString *)message
     didCancelTask:(void(^)(void))cancelTask
       didDoneTask:(void(^)(void))doneTask {
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:titile message:message preferredStyle:alertType];
    
    UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        if (cancelTask) {
            cancelTask();
        }
    }];
    
    UIAlertAction *doneAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (doneTask) {
            doneTask();
        }
    }];
    
    [alertC addAction:cancleAction];
    [alertC addAction:doneAction];
    
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertC animated:YES completion:nil];
}

+ (void)alertTitle:(NSString *)titile
              type:(UIAlertControllerStyle)alertType
           message:(NSString *)message
       didDoneTask:(void(^)(void))doneTask {
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:titile message:message preferredStyle:alertType];
    
    UIAlertAction *doneAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (doneTask) {
            doneTask();
        }
    }];
    
    [alertC addAction:doneAction];
    
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertC animated:YES completion:nil];
}

+ (void)alertTitle:(NSString *)titile
              type:(UIAlertControllerStyle)alertType
           message:(NSString *)message
        controller:(UIViewController *)controller didDoneTask:(void(^)(void))doneTask {
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:titile message:message preferredStyle:alertType];
    
    UIAlertAction *doneAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (doneTask) {
            doneTask();
        }
    }];
    
    [alertC addAction:doneAction];
    
    [controller presentViewController:alertC animated:YES completion:nil];
}


+ (void)alertTitle:(NSString *)titile
              type:(UIAlertControllerStyle)alertType
           message:(NSString *)message
        controller:(UIViewController *)controller
     didCancelTask:(void(^)(void))cancelTask
       didDoneTask:(void(^)(void))doneTask {
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:titile message:message preferredStyle:alertType];
    
    UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        if (cancelTask) {
            cancelTask();
        }
    }];
    
    UIAlertAction *doneAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (doneTask) {
            doneTask();
        }
    }];
    
    [alertC addAction:cancleAction];
    [alertC addAction:doneAction];
    
    [controller presentViewController:alertC animated:YES completion:nil];
}
@end
