//
//  SLNetworkTool.h
//  SLToolObjCKit
//
//  Created by CoderSLZeng on 2017/11/22.
//  对AFN网络请求封装工具类
//

#import <AFNetworking/AFNetworking.h>

/**
 请求类型
 
 - SLRequestTypeGET: GET 请求
 - SLRequestTypePOST: POST 请求
 */
typedef NS_ENUM(NSInteger, SLRequestType) {
    SLRequestTypeGET = 0,
    SLRequestTypePOST = 1
};

@interface SLNetworkTool : AFHTTPSessionManager

+ (instancetype)sharedNetworkTool;

/**
 使用证书相关处理
 @param cerName 导入证书名称
 @param isByPassSLL 设置是否绕过SLL
 */
+ (void)customSecurityPolicyWithCerName:(NSString *)cerName isByPassSLL:(BOOL)isByPassSLL;
/**
 请求方式
 
 @param methodType 请求类型
 @param urlString  地址
 @param parameters 参数
 @param finished 请求完成的回调
 */
- (void)requestMethodType:(SLRequestType)methodType
                urlString:(NSString *)urlString
               parameters:(NSDictionary *)parameters
                 finished:(void (^)(NSDictionary *result, NSError *error))finished;

/**
 上传文件
 
 @param urlString 地址
 @param parameters 参数
 @param finished 请求完成的回调
 */
- (void)upLoadFileWithUrlString:(NSString *)urlString
                     parameters:(NSDictionary *)parameters
                       finished:(void (^)(id<AFMultipartFormData> formData, NSDictionary *result, NSError *error))finished;


/**
 上传一张图片
 
 @param image 图片
 @param urlString 地址
 @param parameters 参数
 @param finished 请求完毕的回调
 */
- (void)uploadImage:(UIImage *)image
          urlString:(NSString *)urlString
         parameters:(NSDictionary *)parameters
           finished:(void (^)(NSDictionary *result))finished;


/**
 上传多张照片
 
 @param imagesArray 装载照片的数组
 @param urlString 地址
 @param parameters 参数
 @param finished 请求完毕的回调
 */
- (void)uploadImages:(NSArray<UIImage *> *)imagesArray
           urlString:(NSString *)urlString
          parameters:(NSDictionary *)parameters
            finished:(void (^)(NSDictionary *result))finished;

@end
