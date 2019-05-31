//
//  SLProgressHUDTool.h
//  SLToolObjCKit
//
//  Created by CoderSLZeng on 2018/1/5.
//
//  对SVProgressHUD框架封装的工具类
//

#import <Foundation/Foundation.h>

// Libs
#import <SVProgressHUD/SVProgressHUD.h>

@interface SLProgressHUDTool : NSObject

/**
 *  显示纯文本 加一个转圈
 *
 *  @param aText 要显示的文本
 */
- (void)showText:(NSString *)aText;


/**
 *  显示纯文本
 *
 *  @param aText 要显示的文本
 */
- (void)showInfoText:(NSString *)aText;

/**
 *  显示错误信息
 *
 *  @param aText 错误信息文本
 */
- (void)showErrorText:(NSString *)aText;

/**
 *  显示成功信息
 *
 *  @param aText 成功信息文本
 */
- (void)showSuccessText:(NSString *)aText;

/**
 *  只显示一个加载框
 */
- (void)showLoading;

/**
 *  隐藏加载框（所有类型的加载框 都可以通过这个方法 隐藏）
 */
- (void)dismissLoading;

/**
 *  显示百分比
 *
 *  @param progress 百分比（整型 100 = 100%）
 */
- (void)showProgress:(NSInteger)progress;

/**
 *  显示图文提示
 *
 *  @param image 自定义的图片
 *  @param aText 要显示的文本
 */
- (void)showImage:(UIImage*)image text:(NSString*)aText;


/**
 设置默认风格

 @param style 风格
 */
- (void)setDefaultStyle:(SVProgressHUDStyle)style;

/**
 设置消失时间
 
 @param interval 时间
 */
- (void)setMinimumDismissTimeInterval:(NSTimeInterval)interval;

@end
