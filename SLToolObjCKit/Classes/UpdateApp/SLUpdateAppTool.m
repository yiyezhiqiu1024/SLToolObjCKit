//
//  SLUpdateAppTool.h
//  PartyConstruction
//
//  Created by CoderSLZeng on 2017/11/3.
//  Copyright © 2017年 amass. All rights reserved.
//  封装更新App版本工具类

#import "SLUpdateAppTool.h"

@implementation SLUpdateAppTool
+ (void)sl_updateWithAPPID:(NSString *)appid block:(void(^)(NSString *currentVersion,NSString *storeVersion, NSString *openUrl,BOOL isUpdate))block
{
    // 1.从网络获取appStore版本号
    NSString *urlStr = [NSString stringWithFormat:@"http://itunes.apple.com/cn/lookup?id=%@",appid];
    NSURL *url = [NSURL URLWithString:urlStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLSessionDataTask *dataTask =  [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            NSLog(@"请求数据错误%@\n", error);
            return;
        }
        
        if (data == nil) {
            NSLog(@"你没有连接网络哦\n");
            return;
        }
        
        NSError *subError;
        
        NSDictionary *appInfoDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&subError];
        if (subError) {
            NSLog(@"UpdateAppError:%@\n",error);
            return;
        }
        NSLog(@"%@\n",appInfoDict);
        NSArray *array = appInfoDict[@"results"];
        
        if (array.count < 1) {
            NSLog(@"此APPID为未上架的APP或者查询不到\n");
            return;
        }
        
        NSDictionary *dic = array[0];
        NSString *appStoreVersion = dic[@"version"];
        
        // 2.获取当前工程项目版本号
        NSBundle *currentBundle = [NSBundle bundleForClass:[self class]];
        NSDictionary *infoDic = [currentBundle infoDictionary];
        NSString *currentVersion = infoDic[@"CFBundleShortVersionString"];
        
        // 3.打印版本号
        NSLog(@"当前版本号:%@\n商店版本号:%@\n", currentVersion,appStoreVersion);
        
        // 4.当前版本号与商店版本号,不一样就更新
        if([appStoreVersion isEqualToString:currentVersion]) { // 一样：不更新
            block(currentVersion, dic[@"version"], [NSString stringWithFormat:@"https://itunes.apple.com/us/app/id%@?ls=1&mt=8", appid], NO);
            
        } else { // 不一样：更新
            
            block(currentVersion, dic[@"version"], [NSString stringWithFormat:@"https://itunes.apple.com/us/app/id%@?ls=1&mt=8", appid], YES);
        }
        
    }];
    
    [dataTask resume];
}
@end
