//
//  SLUpdateAppTool.h
//  SLToolObjeCKit
//
//  Created by CoderSLZeng on 2017/11/3.
//  封装更新App版本工具类
//

#import <Foundation/Foundation.h>

@interface SLUpdateAppTool : NSObject
+ (void)updateWithAPPID:(NSString *)appid
                  block:(void(^)(NSString *currentVersion,
                                 NSString *storeVersion,
                                 NSString *openUrl,
                                 BOOL isUpdate))block;
@end
