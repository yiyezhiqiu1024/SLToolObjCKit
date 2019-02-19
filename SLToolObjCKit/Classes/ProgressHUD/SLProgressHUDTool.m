//
//  SLProgressHUDTool.m
//  PartyConstruction
//
//  Created by CoderSLZeng on 2018/1/5.
//  Copyright © 2018年 linson. All rights reserved.
//

#import "SLProgressHUDTool.h"

@implementation SLProgressHUDTool

- (void)sl_showText:(NSString *)aText
{
    [SVProgressHUD showWithStatus:aText];    
}

- (void)sl_showInfoText:(NSString *)aText
{
    [SVProgressHUD showInfoWithStatus:aText];
}


- (void)sl_showErrorText:(NSString *)aText
{
    [SVProgressHUD showErrorWithStatus:aText];
}

- (void)sl_showSuccessText:(NSString *)aText
{
    [SVProgressHUD showSuccessWithStatus:aText];
}

- (void)sl_showLoading
{
    [SVProgressHUD show];
}


- (void)sl_dismissLoading
{
    [SVProgressHUD dismiss];
}

- (void)sl_showProgress:(NSInteger)progress
{
    [SVProgressHUD showProgress:progress/100.0 status:[NSString stringWithFormat:@"%li%%",(long)progress]];
}

- (void)sl_showImage:(UIImage*)image text:(NSString*)aText
{
    [SVProgressHUD showImage:image status:aText];
}

- (void)sl_setDefaultStyle:(SVProgressHUDStyle)style
{
    [SVProgressHUD setDefaultStyle:style];
}

- (void)sl_setMinimumDismissTimeInterval:(NSTimeInterval)interval
{
    [SVProgressHUD setMinimumDismissTimeInterval:interval];
}
@end
