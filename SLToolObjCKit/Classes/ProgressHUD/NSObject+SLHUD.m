//
//  NSObject+SLHUD.m
//  PartyConstruction
//
//  Created by CoderSLZeng on 2018/1/19.
//  Copyright © 2018年 linson. All rights reserved.
//

#import "NSObject+SLHUD.h"

@implementation NSObject (SLHUD)
- (void)sl_showText:(NSString *)aText
{
    [SLProgressHUD showWithStatus:aText];    
}

- (void)sl_showInfoText:(NSString *)aText
{
//    [SLProgressHUD showImage:nil status:aText];
    [SLProgressHUD showInfoWithStatus:aText];
}


- (void)sl_showErrorText:(NSString *)aText
{
    [SLProgressHUD showErrorWithStatus:aText];
}

- (void)sl_showSuccessText:(NSString *)aText
{
    [SLProgressHUD showSuccessWithStatus:aText];
}

- (void)sl_showLoading
{
    [SLProgressHUD show];
}


- (void)sl_dismissLoading
{
    [SLProgressHUD dismiss];
}

- (void)sl_showProgress:(NSInteger)progress
{
    [SLProgressHUD showProgress:progress/100.0 status:[NSString stringWithFormat:@"%li%%",(long)progress]];
}

- (void)sl_showImage:(UIImage*)image text:(NSString*)aText
{
    [SLProgressHUD showImage:image status:aText];
}

- (void)sl_setDefaultStyle:(SVProgressHUDStyle)style
{
    [SLProgressHUD setDefaultStyle:style];
}

- (void)sl_setMinimumDismissTimeInterval:(NSTimeInterval)interval
{
    [SLProgressHUD setMinimumDismissTimeInterval:interval];
}
@end
