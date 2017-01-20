//
//  TradeManager.m
//  CreateSongs
//
//  Created by axg on 16/8/16.
//  Copyright © 2016年 AXG. All rights reserved.
//

#import "TradeManager.h"
//#import "AlipayOrder.h"
//#import "DataSigner.h"
//#import <AlipaySDK/AlipaySDK.h>
#import "payRequsestHandler.h"
#import "WXApi.h"

@implementation TradeManager

+ (void)payByAlipayWithTitle:(NSString *)title orderId:(NSString *)orderId totalFee:(NSString *)fee resultCallback:(void (^)(NSDictionary *))callback {
//    /*============================================================================*/
//    /*=======================需要填写商户app申请的===================================*/
//    /*============================================================================*/
//    NSString *partner = @"2088901418733541";
//    NSString *seller = @"tontoutongdao@gmail.com";
//    NSString *privateKey = @"MIICdwIBADANBgkqhkiG9w0BAQEFAASCAmEwggJdAgEAAoGBALNEk9doNqA4AzqLlM77+GGc7g/RefDx7ftxQgCziu8zGpQeEMgunUFGpMRyo1AUt93AxG7LJLiy8zCshAoPVhXa5YbGpZajQ2a6ESZmGnx+Pgib1QY7NYoKeaC1oV7wVsofLJjUiqxvRCgpL0aNKxUdN9Q+VR3kpCzmza7xn349AgMBAAECgYAlCL7OGl5mnQu1tY5JcG5wo/3eULUzXJeAgXZUNMM4BUOxY8Ctykt8Z760QsaQTadqbV9nUBpG+dkZrhodBewPgUN3KdIvhHm1XlYcIVigYRuGPvQgz+h7iUoE50V0Mxul2Ysil2pMSes33JWluTrmJ4G/Af0TMhKt8pewP9UlVQJBANianAwWJjR6iqzGyLpf6JBrZRlVLLp3EIcaeQFGgXMflHuMyzRhvkNGi/cZBYQ+Wk6ZfiKHWVt+WX2JQdFLmYcCQQDT34wbIzOSvnaDZt7wQdpxduhdacANNWF8KDkE4PkfW4iCwwbjecTkDcMTLls5qJ1XGcxPRU2BQ+1xXe/F5osbAkEAjbpMlNQBV6E/D+JaASk0QRskYbkLtU6m79/wgVci6LMnMthjNfkmx1pnxt0GcQtjh76DfBBX9bfs0ml3OX1gDQJAd7De9mmxdeHRE7RmlzWskNLKvBLEovGYC8qxQ3dQZQ2RlcVVO+aLewXnQQu8D1uY3x68079j5HWaSqP1k0gFJwJBAI+R9IUdxVk6FPWJnnGE0ECo4fxBFVzhd/oYdzhqxBiSwdzc57FdXcR3oskSv8z4BtS6SqJw1A7vS4yq7ntfeJg=";
//    /*============================================================================*/
//    /*============================================================================*/
//    /*============================================================================*/
//    
//    //partner和seller获取失败,提示
//    if ([partner length] == 0 ||
//        [seller length] == 0 ||
//        [privateKey length] == 0)
//    {
////        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
////                                                        message:@"缺少partner或者seller或者私钥。"
////                                                       delegate:self
////                                              cancelButtonTitle:@"确定"
////                                              otherButtonTitles:nil];
////        [alert show];
//        return;
//    }
//    
//    /*
//     *生成订单信息及签名
//     */
//    //将商品信息赋予AlixPayOrder的成员变量
//    AlipayOrder *order = [[AlipayOrder alloc] init];
//    order.partner = partner;
//    order.sellerID = seller;
//    order.outTradeNO = orderId; //订单ID（由商家自行制定）
//    order.subject = title; //商品标题
//    order.body = title; //商品描述
//    order.totalFee = fee; //商品价格
//    order.notifyURL = [@"www.woyaoxiege.com" stringByAppendingString:@"callback"]; //回调URL
//    
//    order.service = @"mobile.securitypay.pay";
//    order.paymentType = @"1";
//    order.inputCharset = @"utf-8";
//    order.itBPay = @"30m";
//    order.showURL = @"m.alipay.com";
//    
//    //应用注册scheme,在Info.plist定义URL types
//    NSString *appScheme = @"alipay.woyaoxiege";
//    
//    //将商品信息拼接成字符串
//    NSString *orderSpec = [order description];
//    
//    //获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
//    id<DataSigner> signer = CreateRSADataSigner(privateKey);
//    NSString *signedString = [signer signString:orderSpec];
//    
//    //将签名成功字符串格式化为订单字符串,请严格按照该格式
//    NSString *orderString = nil;
//    if (signedString != nil) {
//        orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
//                       orderSpec, signedString, @"RSA"];
//        
////        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:callback];
//    }
}
+ (void)payByWechatWithTitle:(NSString *)title orderId:(NSString *)orderId totalFee:(NSString *)fee
{
//    payRequsestHandler* handler = [[payRequsestHandler alloc] init];
//    [handler init:APP_ID mch_id:MCH_ID];
//    [handler setKey:APP_SECRET];
//    NSDictionary* result = [handler sendPayWithOrderId:orderId title:title totalPrice:[fee floatValue]];
//    
//    PayReq *request = [[PayReq alloc] init];
//    request.partnerId = result[@"partnerid"];
//    request.prepayId= result[@"prepayid"];
//    request.package = result[@"package"];
//    request.nonceStr = result[@"noncestr"];
//    request.timeStamp = (UInt32)[result[@"timestamp"] longLongValue];
//    request.sign= result[@"sign"];
//    if (![WXApi sendReq:request]) {
//        NSLog(@"支付失败");
//    }
}

+ (void)payByWEchatWithOrder:(WXOrder *)wxOrder {
    PayReq *request = [[PayReq alloc] init];
    request.partnerId = wxOrder.partnerId;
    request.prepayId = wxOrder.prepayId;
    request.nonceStr = wxOrder.nonceStr;
    request.timeStamp = wxOrder.timeStamp;
    request.package = wxOrder.package;
    request.sign = wxOrder.sign;
    
    if (![WXApi sendReq:request]) {
        NSLog(@"支付失败");
    }
}

@end
