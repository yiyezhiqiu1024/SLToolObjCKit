//
//  SLNetworkTool.m
//  SLToolKit
//
//  Created by CoderSLZeng on 2017/11/20.
//  

#import "SLNetworkTool.h"

#import "NSString+SLExtension.h"
#import <SVProgressHUD/SVProgressHUD.h>

@implementation SLNetworkTool

static SLNetworkTool *instance_;

+ (__kindof SLNetworkTool*)sl_sharedNetworkTool
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance_ = [[self alloc] initWithBaseURL:nil sessionConfiguration:NSURLSessionConfiguration.defaultSessionConfiguration];
        instance_.requestSerializer = [AFJSONRequestSerializer serializer];
        
        instance_.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:
                                                               @"application/json",
                                                               @"text/json",
                                                               @"text/javascript",
                                                               @"text/html",
                                                               @"text/plain",
                                                               @"multipart/form-data",
                                                               @"image/jpeg",
                                                               @"image/png",
                                                               @"application/octet-stream",
                                                               nil];
    });
    return instance_;
}

+ (void)sl_customSecurityPolicyWithCerName:(NSString *)cerName isByPassSLL:(BOOL)isByPassSLL {
    
    // 先导入证书 证书由服务端生成，具体由服务端人员操作
    NSString *cerPath = [[NSBundle mainBundle] pathForResource:cerName ofType:@"cer"];
    
    if (cerPath == nil) {
        NSException *excp = [NSException exceptionWithName:@"pathError"
                                                    reason:@"证书不存在，调用此方法必须先检查是否导入.cer证书资源"
                                                  userInfo:nil];
        [excp raise];
        return;
    }
    
    NSData *cerData = [NSData dataWithContentsOfFile:cerPath];
    
    if (cerData == nil) {
        NSException *excp = [NSException exceptionWithName:@"pathError"
                                                    reason:@"证书数据解析出错，调用此方法必须先检查.cer证书是否有效"
                                                  userInfo:nil];
        [excp raise];
        return;
    }
    
    AFSecurityPolicy *securityPolicy;
    
    if (isByPassSLL) { // 绕过SSL认证
        securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    } else { // 使用证书验证模式
        securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
    }
    
    /*
     allowInvalidCertificates 是否允许无效证书（也就是自建的证书），默认为NO
     如果是需要验证自建证书，需要设置为YES
     */
    securityPolicy.allowInvalidCertificates = YES;
    
    /*
     validatesDomainName 是否需要验证域名，默认为YES;
     假如证书的域名与你请求的域名不一致，需把该项设置为NO；如设成NO的话，即服务器使用其他可信任机构颁发的证书，也可以建立连接，这个非常危险，建议打开。
     置为NO，主要用于这种情况：客户端请求的是子域名，而证书上的是另外一个域名。因为SSL证书上的域名是独立的，假如证书上注册的域名是www.google.com，那么mail.google.com是无法验证通过的；当然，有钱可以注册通配符的域名*.google.com，但这个还是比较贵的。
     如置为NO，建议自己添加对应域名的校验逻辑。
     */
    securityPolicy.validatesDomainName = NO;
    
    securityPolicy.pinnedCertificates = [[NSSet alloc] initWithObjects:cerData, nil];
    
    if (instance_ == nil) {
        [self sl_sharedNetworkTool];
    }
    [instance_ setSecurityPolicy:securityPolicy];
}

- (void)sl_requestMethodType:(SLRequestType)methodType
                   urlString:(NSString *)urlString
                  parameters:(NSDictionary *)parameters
                    finished:(void (^)(NSDictionary *result, NSError *error))finished
{
    // 1.检查网络
    if (![self checkNetWorking]) return;
    
    // 2.定义成功的回调
    void (^successCallBack)(NSURLSessionDataTask *task, id result) = ^(NSURLSessionDataTask *task, id result) {
        finished(result, nil);
    };
    
    // 3.定义失败的回调
    void (^failureCallBack)(NSURLSessionDataTask *task, NSError *error) = ^(NSURLSessionDataTask *task, NSError *error) {
        finished(nil, error);
    };
    
    NSMutableDictionary *baseParameters= [NSMutableDictionary dictionary];
    baseParameters[@"submitTime"] = [NSString sl_getNowTimeTimeStamp2Millisecond];
    
    [parameters enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        baseParameters[key] = obj;
    }];
    
    // 4.发送网络请求
    if (methodType == SLRequestTypeGET) {
        [self GET:urlString
       parameters:baseParameters
         progress:nil
          success:successCallBack
          failure:failureCallBack];
    } else {
        [self POST:urlString
        parameters:baseParameters
          progress:nil
           success:successCallBack
           failure:failureCallBack];
    }
}

- (void)sl_requestMethodType:(SLRequestType)methodType
                   urlString:(NSString *)urlString
                  parameters:(NSDictionary *)parameters
                    progress:(void (^)(NSProgress * _Nonnull))progress
                    finished:(void (^)(NSDictionary *result, NSError *error))finished
{
    // 1.检查网络
    if (![self checkNetWorking]) return;
    
    // 2.定义成功的回调
    void (^successCallBack)(NSURLSessionDataTask *task, id result) = ^(NSURLSessionDataTask *task, id result) {
        finished(result, nil);
    };
    
    // 3.定义失败的回调
    void (^failureCallBack)(NSURLSessionDataTask *task, NSError *error) = ^(NSURLSessionDataTask *task, NSError *error) {
        finished(nil, error);
    };
    
    NSMutableDictionary *baseParameters= [NSMutableDictionary dictionary];
    baseParameters[@"submitTime"] = [NSString sl_getNowTimeTimeStamp2Millisecond];
    
    [parameters enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        baseParameters[key] = obj;
    }];
    
    // 4.发送网络请求
    if (methodType == SLRequestTypeGET) {
        [self GET:urlString
       parameters:baseParameters
         progress:progress
          success:successCallBack
          failure:failureCallBack];
    } else {
        [self POST:urlString
        parameters:baseParameters
          progress:progress
           success:successCallBack
           failure:failureCallBack];
    }
}

- (void)sl_upLoadFileWithUrlString:(NSString *)urlString
                        parameters:(NSDictionary *)parameters
                          finished:(void (^)(id<AFMultipartFormData> formData, NSDictionary *result, NSError *error))finished
{
    // 1.检查网络
    if (![self checkNetWorking]) return;
    
    // 2.定义上传文件参数的回调
    void (^constructingBodyCallBack)(id<AFMultipartFormData>  _Nonnull formData) = ^(id<AFMultipartFormData>  _Nonnull formData) {
        finished(formData, nil, nil);
    };
    
    // 3.定义成功的回调
    void (^successCallBack)(NSURLSessionDataTask *task, id result) = ^(NSURLSessionDataTask *task, id result) {
        finished(nil, result, nil);
    };
    
    // 4.定义失败的回调
    void (^failureCallBack)(NSURLSessionDataTask *task, NSError *error) = ^(NSURLSessionDataTask *task, NSError *error) {
        finished(nil, nil, error);
    };
    
    NSMutableDictionary *baseParameters= [NSMutableDictionary dictionary];
    baseParameters[@"submitTime"] = [NSString sl_getNowTimeTimeStamp2Millisecond];
    
    [parameters enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        baseParameters[key] = obj;
    }];
    
    // 5.发送网络请求
    [self POST:urlString
    parameters:baseParameters
constructingBodyWithBlock:constructingBodyCallBack
      progress:nil
       success:successCallBack
       failure:failureCallBack];
}

- (void)sl_uploadImage:(UIImage *)image
             urlString:(NSString *)urlString
            parameters:(NSDictionary *)parameters
              finished:(void (^)(NSDictionary *result))finished
{
    
    if (image == nil) {
        NSException *excp = [NSException exceptionWithName:@"pathError" reason:@"调用此方法必须提供一个图片参数" userInfo:nil];
        [excp raise];
        return;
    }
    
    NSMutableDictionary *baseParameters= [NSMutableDictionary dictionary];
    baseParameters[@"submitTime"] = [NSString sl_getNowTimeTimeStamp2Millisecond];
    
    [parameters enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        baseParameters[key] = obj;
    }];
    
    self.requestSerializer.timeoutInterval = 20;
    [self sl_upLoadFileWithUrlString:urlString parameters:baseParameters finished:^(id<AFMultipartFormData> formData, NSDictionary *result, NSError *error) {
        
        if (error != nil)
        {
            NSLog(@"上传图片失败 - %@", error);
            [SVProgressHUD showErrorWithStatus:@"上传图片失败"];
            return;
        }
        
        NSData *imageData;
        if (UIImagePNGRepresentation(image) == nil) {
            UIGraphicsBeginImageContext(image.size);
            [image drawInRect:CGRectMake(0, 0, image.size.width, image.size.height)];
            UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            imageData = UIImageJPEGRepresentation(newImage, 0.5);
        } else {
            imageData = UIImageJPEGRepresentation(image, 0.5);
        }
        
        if (imageData != nil) {
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            formatter.dateFormat = @"yyyyMMddHHmmss";
            
            NSString *str = [formatter stringFromDate:[NSDate date]];
            NSString *fileName = [NSString stringWithFormat:@"%@.png", str];
            // NSLog(@"---fileName-%@",fileName);
            
            // [formData appendPartWithFileData:imageData name:name fileName:fileName mimeType:@"image/png"];
            [formData appendPartWithFileData:imageData name:@"0" fileName:fileName mimeType:@"application/octet-stream"];
        } else {
            NSLog(@"%@", imageData);
        }
        
        finished(result);
    }];
}

- (void)sl_uploadImages:(NSArray<UIImage *> *)imagesArray
              urlString:(NSString *)urlString
             parameters:(NSDictionary *)parameters
               finished:(void (^)(NSDictionary *result))finished
{
    if (imagesArray.count == 0) {
        NSException *excp = [NSException exceptionWithName:@"pathError" reason:@"调用此方法必须提供一个装载图片的数组参数" userInfo:nil];
        [excp raise];
        return;
    }
    
    [self sl_upLoadFileWithUrlString:urlString parameters:parameters finished:^(id<AFMultipartFormData> formData, NSDictionary *result, NSError *error) {
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyyMMddHHmmss";
        
        [imagesArray enumerateObjectsUsingBlock:^(UIImage * _Nonnull image, NSUInteger idx, BOOL * _Nonnull stop) {
            
            NSData *imageData;
            if (UIImagePNGRepresentation(image) == nil) {
                UIGraphicsBeginImageContext(image.size);
                [image drawInRect:CGRectMake(0, 0, image.size.width, image.size.height)];
                UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
                UIGraphicsEndImageContext();
                imageData = UIImageJPEGRepresentation(newImage, 0.5);
            } else {
                imageData = UIImageJPEGRepresentation(image, 0.5);
            }
            
            if (imageData != nil) {
                NSString *name = [NSString stringWithFormat:@"mFile%lu", (unsigned long)idx];
                
                NSString *str = [formatter stringFromDate:[NSDate date]];
                NSString *fileName = [NSString stringWithFormat:@"IMG%@%lu.jpg", str, (unsigned long)idx];
                NSLog(@"---fileName-%@",fileName);
                
                // [formData appendPartWithFileData:imageData name:name fileName:fileName mimeType:@"image/png"];
                [formData appendPartWithFileData:imageData name:name fileName:fileName mimeType:@"application/octet-stream"];
            } else {
                NSLog(@"%@", imageData);
            }
        }];
        
        
        finished(result);
    }];
}

#pragma mark - Private methond
/**
 检查网络
 
 @return 是否有网络
 */
- (BOOL)checkNetWorking{
    
    BOOL isReachable = YES;
    
    // 检测网络状态
    AFNetworkReachabilityManager *mgr = [AFNetworkReachabilityManager sharedManager];
    
    int status = mgr.networkReachabilityStatus;
    
    switch (status) {
        case AFNetworkReachabilityStatusUnknown: // 未知网络
            NSLog(@"未知网络");
            break;
            
        case AFNetworkReachabilityStatusNotReachable: // 没有网络(断网)
        {
            NSLog(@"没有网络(断网)");
            [SVProgressHUD showErrorWithStatus:@"网络异常，请检查网络设置！"];
            isReachable = NO ;
        }
            break;
            
        case AFNetworkReachabilityStatusReachableViaWWAN: // 手机自带网络
            NSLog(@"手机自带网络");
            break;
            
        case AFNetworkReachabilityStatusReachableViaWiFi: // WIFI
            NSLog(@"WIFI");
            break;
    }
    
    return isReachable;
}

@end

