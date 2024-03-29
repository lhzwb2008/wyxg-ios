//
//  XWBaseMethod.m
//  新闻
//
//  Created by user on 15/10/2.
//  Copyright (c) 2015年 user. All rights reserved.
//

#import "XWBaseMethod.h"
#import "MBProgressHUD+MJ.h"
#import "Reachability.h"
#import "KVNProgress.h"

@implementation XWBaseMethod


//+(void)loadImageWithImg:(UIImageView *)imageView url:(NSString *)urlStr
//{
//    
//    [imageView sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:[UIImage imageNamed:@"302"]];
//}
//
//+(void)loadImageWithImg:(UIImageView *)imageView url:(NSString *)urlStr placeImg:(NSString *)placeImg
//{
//    [imageView sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:[UIImage imageNamed:placeImg]];
//}
//显示圈圈
+(void)showHUDAddedTo:(UIView *)view animated:(BOOL)animated
{
//    [MBProgressHUD showHUDAddedTo:view animated:animated];
    [KVNProgress showWithStatus:@"正在发送"];
}
//隐藏圈圈
+(void)hideHUDAddedTo:(UIView *)view animated:(BOOL)animated
{
//    [MBProgressHUD hideAllHUDsForView:view animated:animated];
    [KVNProgress dismiss];
}

//  错误的提示
+(void)showErrorWithStr:(NSString *)error toView:(UIView *)view
{
//    [MBProgressHUD showError:error toView:view];
    [KVNProgress showErrorWithStatus:error onView:view];
}

//错误的提示
+(void)showSuccessWithStr:(NSString *)success toView:(UIView *)view
{
//    [MBProgressHUD showSuccess:success toView:view];
    [KVNProgress showSuccessWithStatus:success onView:view];
}

//判断有没有网络
+(BOOL)connectionInternet
{
    //1.发送网络请求
    Reachability *reach=[Reachability reachabilityWithHostName:@"www.baidu.com"];
    NetworkStatus status=[reach currentReachabilityStatus];
    if(status==NotReachable){
        return NO; //没有网络
    }
    return YES;
}

@end
