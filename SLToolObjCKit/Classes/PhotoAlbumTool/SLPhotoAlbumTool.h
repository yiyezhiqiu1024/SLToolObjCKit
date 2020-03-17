//
//  SLPhotoAlbumTool.h
//  SLToolObjCKit
//
//  Created by CoderSLZeng on 2018/11/1.
//  Copyright © 2018年 SLToolObjCKit. All rights reserved.
//  相册工具类
//

#import <Foundation/Foundation.h>

@interface SLPhotoAlbumTool : NSObject


/**
 保存图片到当前应用名的相册

 @param img 图片
 */
+ (void)sl_saveCurrentAppPhotosAlubmWithImage:(UIImage *)img;


/**
 保存图片到系统默认相册

 @param img 图片
 */
+ (void)sl_saveSystemPhotosAlbumWithImage:(UIImage *)img;
@end
