//
//  SLProgressHUDTool.m
//  SLToolObjCKit
//
//  Created by CoderSLZeng on 2018/1/5.
//

#import "SLProgressHUDTool.h"

@implementation SLProgressHUDTool

- (void)showText:(NSString *)aText {
    [SVProgressHUD showWithStatus:aText];    
}

- (void)showInfoText:(NSString *)aText {
    [SVProgressHUD showInfoWithStatus:aText];
}

- (void)showErrorText:(NSString *)aText {
    [SVProgressHUD showErrorWithStatus:aText];
}

- (void)showSuccessText:(NSString *)aText {
    [SVProgressHUD showSuccessWithStatus:aText];
}

- (void)showLoading {
    [SVProgressHUD show];
}

- (void)dismissLoading {
    [SVProgressHUD dismiss];
}

- (void)showProgress:(NSInteger)progress {
    [SVProgressHUD showProgress:progress/100.0 status:[NSString stringWithFormat:@"%li%%",(long)progress]];
}

- (void)showImage:(UIImage*)image text:(NSString*)aText {
    [SVProgressHUD showImage:image status:aText];
}

- (void)setDefaultStyle:(SVProgressHUDStyle)style {
    [SVProgressHUD setDefaultStyle:style];
}

- (void)setMinimumDismissTimeInterval:(NSTimeInterval)interval {
    [SVProgressHUD setMinimumDismissTimeInterval:interval];
}
@end
