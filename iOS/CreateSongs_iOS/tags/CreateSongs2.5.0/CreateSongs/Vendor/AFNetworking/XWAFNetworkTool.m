//
//  XWAFNetworkTool.m
//  Test
//
//  Created by 奚旺 on 15/11/6.
//  Copyright (c) 2015年 奚旺. All rights reserved.
//

#import "XWAFNetworkTool.h"
#import "AFNetworking.h"
#import "Reachability.h"
#import "SDImageCache.h"
#import "AFNetworkActivityIndicatorManager.h"




@implementation XWAFNetworkTool

// 带进度的get请求
+(void)getUrl:(NSString *)url body:(id)body response:(XWResposeStyle)style
requestHeadFile:(NSDictionary *)headFile progress:(void (^)(NSProgress * _Nonnull downloadProgress))progress success:(void (^)(NSURLSessionDataTask *task, id resposeObjects))success
      failure:(void (^)(NSURLSessionDataTask * task,NSError * error))failure
{
    //1获取单例的网络管理对象
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = TIMEOUTINTERVAL;
    // 2,根据style的类型，取选择返回值类型
    switch (style) {
        case XWJSON:
            manager.responseSerializer =[AFJSONResponseSerializer serializer];
            break;
        case XWXML:
            manager.responseSerializer = [AFXMLParserResponseSerializer serializer];
            break;
        case XWData:
            manager.responseSerializer = [AFHTTPResponseSerializer serializer];
            break;
            
            
        default:
            break;
    }
    if (headFile) {
        
        for (NSString * key in headFile.allKeys) {
            [manager.requestSerializer setValue:headFile[key] forHTTPHeaderField:key];
        }
        
    }
    
    // 转码
    // 3. 设置响应数据支持类型
    [manager.responseSerializer setAcceptableContentTypes:[NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/css",@"text/plain", @"application/javascript",@"application/x-www-form-urlencoded",@"application/x-javascript",@"audio/midi", nil]];
    url = [url stringByAddingPercentEncodingWithAllowedCharacters:
           [NSCharacterSet URLQueryAllowedCharacterSet]];
    //  3,发送get请求
    
    [manager GET:url parameters:body progress:^(NSProgress * _Nonnull downloadProgress) {
        
        NSLog(@"%lf", downloadProgress.fractionCompleted);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (progress) {
                progress(downloadProgress);
            }
        });
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        /* ************************************************** */
        //如果请求成功 , 回调请求到的数据 , 同时 在这里 做本地缓存
        NSString *path = [NSString stringWithFormat:@"%ld.plist", [url hash]];
        // 存储的沙盒路径
        NSString *path_doc = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
        // 归档
        [NSKeyedArchiver archiveRootObject:responseObject toFile:[path_doc stringByAppendingPathComponent:path]];
        
        /* if判断， 防止success 为空 */
        if (success) {
            
            success(task, responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (error.code == -1001) {
            //[SVProgressHUD showErrorWithStatus:@"网络不给力"];
        }
        if (error) {
            
            /* *************************************************** */
            // 在这里读取本地缓存
            NSString *path = [NSString stringWithFormat:@"%ld.plist", [url hash]];
            NSString *path_doc = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
            
            id result = [NSKeyedUnarchiver unarchiveObjectWithFile:[path_doc stringByAppendingPathComponent:path]];
            
            if (result) {
                success(task, result);
            }else{
                failure(task,error);
            }
            
            //            failure(task, error);
        }
    }];
}

+(NSURLSessionDataTask *)getUrl:(NSString *)url body:(id)body response:(XWResposeStyle)style
requestHeadFile:(NSDictionary *)headFile success:(void (^)(NSURLSessionDataTask *task, id resposeObjects))success
      failure:(void (^)(NSURLSessionDataTask * task,NSError * error))failure
{
    // 网路请求菊花显示
//    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    //1获取单例的网络管理对象
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = TIMEOUTINTERVAL;
    // 2,根据style的类型，取选择返回值类型
    switch (style) {
        case XWJSON:
            manager.responseSerializer =[AFJSONResponseSerializer serializer];
            break;
            case XWXML:
            manager.responseSerializer = [AFXMLParserResponseSerializer serializer];
            break;
            case XWData:
            manager.responseSerializer = [AFHTTPResponseSerializer serializer];
            break;
           
            
        default:
            break;
    }
    if (headFile) {
        
        for (NSString * key in headFile.allKeys) {
             [manager.requestSerializer setValue:headFile[key] forHTTPHeaderField:key];
        }
        
    }
    // 转码
    // 3. 设置响应数据支持类型
    [manager.responseSerializer setAcceptableContentTypes:[NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/css",@"text/plain", @"application/javascript",@"application/x-www-form-urlencoded",@"application/x-javascript",@"audio/midi", nil]];
    url = [url stringByAddingPercentEncodingWithAllowedCharacters:
           [NSCharacterSet URLQueryAllowedCharacterSet]];
        //  3,发送get请求
    NSURLSessionDataTask *task =[manager GET:url parameters:body success:^(NSURLSessionDataTask *task, id responseObject) {
        
        /* ************************************************** */
        
        // 网络请求消失
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
        //如果请求成功 , 回调请求到的数据 , 同时 在这里 做本地缓存
        NSString *path = [NSString stringWithFormat:@"%ld.plist", [url hash]];
        // 存储的沙盒路径
        NSString *path_doc = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
        // 归档
        [NSKeyedArchiver archiveRootObject:responseObject toFile:[path_doc stringByAppendingPathComponent:path]];
        
        /* if判断， 防止success 为空 */
        if (success) {
            
            success(task, responseObject);
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        // 网络请求消失
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
        if (error.code == -1001) {
            //[SVProgressHUD showErrorWithStatus:@"网络不给力"];
        }
        if (error) {
            
            /* *************************************************** */
            // 在这里读取本地缓存
            NSString *path = [NSString stringWithFormat:@"%ld.plist", [url hash]];
            NSString *path_doc = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
            
            id result = [NSKeyedUnarchiver unarchiveObjectWithFile:[path_doc stringByAppendingPathComponent:path]];
            
            if (result) {
                success(task, result);
            }else{
                failure(task,error);
            }
            
            //            failure(task, error);
        }
        
    }];
    return task;
}
+ (void)postUrlString:(NSString *)url
body:(id)body
response:(XWResposeStyle)style
bodyStyle:(XWRequestStyle)bodyStyle
requestHeadFile:(NSDictionary *)headFile
success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure
    {
        // 1.获取Session管理对象
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.requestSerializer.timeoutInterval = TIMEOUTINTERVAL;

        // 2.设置网络请求返回时, responseObject的数据类型
        switch (style) {
            case XWJSON:
                manager.responseSerializer = [AFJSONResponseSerializer serializer];
                break;
            case XWXML:
                manager.responseSerializer = [AFXMLParserResponseSerializer serializer];
                break;
            case XWData:
                manager.responseSerializer = [AFHTTPResponseSerializer serializer];
                break;
            default:
                break;
        }
        // 3.判断body体的类型
        switch (bodyStyle) {
            case XWRequestJSON:
                // 以JSON格式发送
                manager.requestSerializer = [AFHTTPRequestSerializer serializer];
                break;
            case XWRequestString:
                // 保持字符串样式
                [manager.requestSerializer setQueryStringSerializationWithBlock:^NSString *(NSURLRequest *request, id parameters, NSError *__autoreleasing *error) {
                    return parameters;
                }];
            case XWRequestDefault:
                // 默认情况会把JSON拼接成字符串, 但是没有顺序
                break;
                
            default:
                break;
        }
        // 4.给网络请求加请求头
        if (headFile) {
            for (NSString *key in headFile.allKeys) {
                [manager.requestSerializer setValue:headFile[key] forHTTPHeaderField:key];
            }
        }
        // 5.设置支持的响应头格式
        [manager.responseSerializer setAcceptableContentTypes:[NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/css",@"text/plain", @"application/javascript", nil]];
        // 6.发送网络请求
        
        [manager POST:url parameters:body progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if (success) {
                success(task, responseObject);
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            if (error.code == -1001) {
                //[SVProgressHUD showErrorWithStatus:@"网络不给力"];
            }
            if (failure) {
                failure(task, error);
            }
        }];

        
//        [manager GET:url parameters:body success:^(NSURLSessionDataTask *task, id responseObject) {
//            if (success) {
//                success(task, responseObject);
//            }
//            
//        } failure:^(NSURLSessionDataTask *task, NSError *error) {
//            if (error.code == -1001) {
//                //[SVProgressHUD showErrorWithStatus:@"网络不给力"];
//            }
//            if (failure) {
//                failure(task, error);
//            }
//        }];
        
}
+ (BOOL)checkNetwork{
    Reachability *r = [Reachability reachabilityWithHostName:@"www.baidu.com"];
    switch ([r currentReachabilityStatus]) {
        case NotReachable:
            return NO;
            break;
        case ReachableViaWWAN:
            return YES;
            break;
        case ReachableViaWiFi:
            return YES;
            break;
        default:
            return NO;
    }
}

+ (void)postUploadWithUrl:(NSString *)urlStr fileData:(NSData *)fileData fileUrl:(NSURL *)fileURL paramter:(id)paramter fileName:(NSString *)fileName fileType:(NSString *)fileTye success:(void (^)(id responseObject))success fail:(void (^)())fail {
    
    // 本地上传给服务器时,没有确定的URL,不好用MD5的方式处理
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    //@"http://localhost/demo/upload.php"
    
    [manager POST:urlStr parameters:paramter constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        if (fileData) {
            [formData appendPartWithFileData:fileData name:@"file" fileName:fileName mimeType:fileTye];
        } else {
            [formData appendPartWithFileURL:fileURL name:@"file" fileName:fileName mimeType:fileTye error:NULL];
        }
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [[SDImageCache sharedImageCache] clearDisk];
        [[SDImageCache sharedImageCache] clearMemory];
        
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (fail) {
            NSLog(@"!!!!!!!!!!!!!!!!!!!!!!!%@", error.description);
            fail();
        }
    }];
    
}

+ (NSString *)md5HexDigest:(NSString*)input {
    if (input == nil) {
        NSLog(@"----------MD5加密字符串为空----------");
        return @"";
    }
    const char* str = [input UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(str, (CC_LONG)strlen(str), result);
    NSMutableString *ret = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i = 0; i<CC_MD5_DIGEST_LENGTH; i++) {
        [ret appendFormat:@"%02x",result[i]];
    }
    return ret;
}


+ (void)postInfoWithUrl:(NSString *)url paramter:(NSDictionary *)param success:(void (^)(id responseObject))success fail:(void (^)())fail {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    // manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [manager POST:url parameters:param progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(responseObject);
        }

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (fail) {
            NSLog(@"%@", error.description);
            fail(error);
        }
    }];
}


@end
