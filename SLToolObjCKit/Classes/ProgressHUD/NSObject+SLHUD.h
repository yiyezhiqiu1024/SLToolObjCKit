//
//  NSObject+SLHUD.h
//  PartyConstruction
//
//  Created by CoderSLZeng on 2018/1/19.
//  Copyright © 2018年 linson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SLProgressHUD.h"

@interface NSObject (SLHUD)
/**
 *  显示纯文本 加一个转圈
 *
 *  @param aText 要显示的文本
 */
- (void)sl_showText:(NSString *)aText;


/**
 *  显示纯文本
 *
 *  @param aText 要显示的文本
 */
- (void)sl_showInfoText:(NSString *)aText;

/**
 *  显示错误信息
 *
 *  @param aText 错误信息文本
 */
- (void)sl_showErrorText:(NSString *)aText;

/**
 *  显示成功信息
 *
 *  @param aText 成功信息文本
 */
- (void)sl_showSuccessText:(NSString *)aText;

/**
 *  只显示一个加载框
 */
- (void)sl_showLoading;

/**
 *  隐藏加载框（所有类型的加载框 都可以通过这个方法 隐藏）
 */
- (void)sl_dismissLoading;

/**
 *  显示百分比
 *
 *  @param progress 百分比（整型 100 = 100%）
 */
- (void)sl_showProgress:(NSInteger)progress;

/**
 *  显示图文提示
 *
 *  @param image 自定义的图片
 *  @param aText 要显示的文本
 */
- (void)sl_showImage:(UIImage*)image text:(NSString*)aText;


/**
 设置默认风格
 
 @param style 风格
 */
- (void)sl_setDefaultStyle:(SVProgressHUDStyle)style;


/**
 设置消失时间

 @param interval 时间
 */
- (void)sl_setMinimumDismissTimeInterval:(NSTimeInterval)interval;
@end
