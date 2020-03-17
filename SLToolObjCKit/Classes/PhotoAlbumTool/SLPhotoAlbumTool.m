//
//  SLPhotoAlbumTool.m
//  PartyConstruction
//
//  Created by CoderSLZeng on 2018/11/1.
//  Copyright © 2018年 linson. All rights reserved.
//

#import "SLPhotoAlbumTool.h"

#import <Photos/Photos.h>

@implementation SLPhotoAlbumTool


+ (void)sl_saveCurrentAppPhotosAlubmWithImage:(UIImage *)img {
    /*
     PHAuthorizationStatusNotDetermined,     用户还没有做出选择
     PHAuthorizationStatusDenied,            用户拒绝当前应用访问相册(用户当初点击了"不允许")
     PHAuthorizationStatusAuthorized         用户允许当前应用访问相册(用户当初点击了"好")
     PHAuthorizationStatusRestricted,        因为家长控制, 导致应用无法方法相册(跟用户的选择没有关系)
     */
    
    // 判断授权状态
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    if (status == PHAuthorizationStatusRestricted) { // 因为家长控制, 导致应用无法方法相册(跟用户的选择没有关系)
        NSLog(@"SLPhotoAlbumTool.m:27 --- 因为系统原因, 无法访问相册");
    } else if (status == PHAuthorizationStatusDenied) { // 用户拒绝当前应用访问相册(用户当初点击了"不允许")
        NSLog(@"SLPhotoAlbumTool.m:29 ---提醒用户去[设置-隐私-照片-xxx]打开访问开关");
    } else if (status == PHAuthorizationStatusAuthorized) { // 用户允许当前应用访问相册(用户当初点击了"好")
        [self sl_startSaveImage:img];
    } else if (status == PHAuthorizationStatusNotDetermined) { // 用户还没有做出选择
        // 弹框请求用户授权
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            if (status == PHAuthorizationStatusAuthorized) { // 用户点击了好
                [self sl_startSaveImage:img];
            }
        }];
    }
}

+ (void)sl_startSaveImage:(UIImage *)img {
    // PHAsset : 一个资源, 比如一张图片\一段视频
    // PHAssetCollection : 一个相簿
    
    // PHAsset的标识, 利用这个标识可以找到对应的PHAsset对象(图片对象)
    __block NSString *assetLocalIdentifier = nil;
    
    // 如果想对"相册"进行修改(增删改), 那么修改代码必须放在[PHPhotoLibrary sharedPhotoLibrary]的performChanges方法的block中
    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
        // 1.保存图片A到"相机胶卷"中
        // 创建图片的请求
        assetLocalIdentifier = [PHAssetCreationRequest creationRequestForAssetFromImage:img].placeholderForCreatedAsset.localIdentifier;
    } completionHandler:^(BOOL success, NSError * _Nullable error) {
        if (success == NO) {
            NSLog(@"SLPhotoAlbumTool.m:57 --- 保存[图片]到[相机胶卷]失败!失败信息-%@", error);
            return;
        }
        
        // 2.获得相簿
        PHAssetCollection *createdAssetCollection = [self sl_createdAssetCollection];
        if (createdAssetCollection == nil) {
            NSLog(@"SLPhotoAlbumTool.m:64 --- 创建相簿失败!");
            return;
        }
        
        [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
            // 3.添加"相机胶卷"中的图片A到"相簿"D中
            
            // 获得图片
            PHAsset *asset = [PHAsset fetchAssetsWithLocalIdentifiers:@[assetLocalIdentifier] options:nil].lastObject;
            
            // 添加图片到相簿中的请求
            PHAssetCollectionChangeRequest *request = [PHAssetCollectionChangeRequest changeRequestForAssetCollection:createdAssetCollection];
            
            // 添加图片到相簿
            [request addAssets:@[asset]];
        } completionHandler:^(BOOL success, NSError * _Nullable error) {
            if (success == NO) {
                NSLog(@"SLPhotoAlbumTool.m:81 --- 保存图片失败!");
            } else {
                NSLog(@"SLPhotoAlbumTool.m:83 --- 保存图片成功!");
            }
        }];
    }];
    
}

/**
 *  获得相簿
 */
+ (PHAssetCollection *)sl_createdAssetCollection {
    // 从已存在相簿中查找这个应用对应的相簿
    PHFetchResult<PHAssetCollection *> *assetCollections = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    // 获取当前应用名称作为相册名称
    NSString *title = [NSBundle mainBundle].infoDictionary[@"CFBundleDisplayName"];
    for (PHAssetCollection *assetCollection in assetCollections) {
        if ([assetCollection.localizedTitle isEqualToString:title]) {
            return assetCollection;
        }
    }
    
    // 没有找到对应的相簿, 得创建新的相簿
    
    // 错误信息
    NSError *error = nil;
    
    // PHAssetCollection的标识, 利用这个标识可以找到对应的PHAssetCollection对象(相簿对象)
    __block NSString *assetCollectionLocalIdentifier = nil;
    [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
        // 获取当前应用名称作为相册名称
        NSString *title = [NSBundle mainBundle].infoDictionary[@"CFBundleDisplayName"];
        // 创建相簿的请求
        assetCollectionLocalIdentifier = [PHAssetCollectionChangeRequest creationRequestForAssetCollectionWithTitle:title].placeholderForCreatedAssetCollection.localIdentifier;
    } error:&error];
    
    // 如果有错误信息
    if (error) return nil;
    
    // 获得刚才创建的相簿
    return [PHAssetCollection fetchAssetCollectionsWithLocalIdentifiers:@[assetCollectionLocalIdentifier] options:nil].lastObject;
}

/**
 *  保存图片到相机胶卷
 */
+ (void)sl_saveSystemPhotosAlbumWithImage:(UIImage *)img {
    // UIImageWriteToSavedPhotosAlbum(self.imageView.image, self, @selector(a:b:c:), nil);
    UIImageWriteToSavedPhotosAlbum(img, self, @selector(sl_image:didFinishSavingWithError:contextInfo:), nil);
}

/**
 *  通过UIImageWriteToSavedPhotosAlbum函数写入图片完毕后就会调用这个方法
 *
 *  @param image       写入的图片
 *  @param error       错误信息
 *  @param contextInfo UIImageWriteToSavedPhotosAlbum函数的最后一个参数
 */
+ (void)sl_image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    if (error) {
        NSLog(@"SLPhotoAlbumTool.m:145 --- 图片保存失败!");
    } else {
        NSLog(@"SLPhotoAlbumTool.m:147 ---图片保存成功!");
    }
    
}

@end
