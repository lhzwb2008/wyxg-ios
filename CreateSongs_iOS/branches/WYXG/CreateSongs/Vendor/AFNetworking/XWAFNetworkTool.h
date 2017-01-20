//
//  XWAFNetworkTool.h
//  Test
//
//  Created by 奚旺 on 15/11/6.
//  Copyright (c) 2015年 奚旺. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>

#define TIMEOUTINTERVAL 60

typedef NS_ENUM(NSUInteger, XWRequestStyle) {
    XWRequestJSON,
    XWRequestString,
    XWRequestDefault
    
    
    
    
    
};

typedef NS_ENUM(NSUInteger, XWResposeStyle) {
    XWJSON,
    XWXML,
    XWData,
};

@interface XWAFNetworkTool : NSObject

// 带进度条的get请求
+(void)getUrl:(NSString *)url body:(id)body response:(XWResposeStyle)style
requestHeadFile:(NSDictionary *)headFile progress:(void (^)(NSProgress * _Nonnull downloadProgress))progress success:(void (^)(NSURLSessionDataTask *task, id resposeObjects))success
      failure:(void (^)(NSURLSessionDataTask * task,NSError * error))failure;

+ (void)postUrlString:(NSString *)url
                 body:(id)body
             response:(XWResposeStyle)style
            bodyStyle:(XWRequestStyle)bodyStyle
      requestHeadFile:(NSDictionary *)headFile
              success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
              failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;
+(NSURLSessionDataTask *)getUrl:(NSString *)url body:(id)body response:(XWResposeStyle)style  requestHeadFile:(NSDictionary *)headFile success:(void (^)(NSURLSessionDataTask *task, id resposeObject))success
      failure:(void (^)(NSURLSessionDataTask * task,NSError * error))failure;
+ (BOOL)checkNetwork;

+ (void)postUploadWithUrl:(NSString *)urlStr fileData:(NSData *)fileData fileUrl:(NSURL *)fileURL paramter:(id)paramter fileName:(NSString *)fileName fileType:(NSString *)fileTye success:(void (^)(id responseObject))success fail:(void (^)())fail;

+ (NSString *)md5HexDigest:(NSString*)input;

// 这里改成了get请求
+ (void)postInfoWithUrl:(NSString *)url paramter:(NSDictionary *)param success:(void (^)(id responseObject))success fail:(void (^)())fail;

@end
