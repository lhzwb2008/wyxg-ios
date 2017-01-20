//
//  ShareManager.m
//  CreateSongs
//
//  Created by axg on 16/9/7.
//  Copyright © 2016年 AXG. All rights reserved.
//

#import "ShareManager.h"
#import "KVNProgress.h"
#import "XWAFNetworkTool.h"
#import "WXApi.h"
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterfaceObject.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import "WeiboSDK.h"
#import "AppDelegate.h"
#import "UMSocial.h"
#import "YYImage.h"
#import "MBProgressHUD.h"
#import "MBProgressHUD+MJ.h"

@implementation ShareManager

+ (void)AXGShare:(AXGShrareType)shareType params:(NSDictionary *)shareParams{
    /*
     NSString *title = @"我正在玩#我要写歌#，最火写歌app！快来一起写歌吧";
     title = @"";
     NSString *mp3Url = @"";
     NSString *webUrl = @"http://a.app.qq.com/o/simple.jsp?pkgname=com.woyaoxiege.wyxg";
     UIImage *image = [UIImage imageNamed:@"LOGO"];
     NSString *songWriter = @"";
     songWriter = @"我正在玩#我要写歌#，最火写歌app！快来一起写歌吧"
     */
    NSString *title         =  [shareParams[@"title"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *mp3Url        =  shareParams[@"mp3Url"];
    NSString *webUrl        =  shareParams[@"url"];
    NSString *songWriter    =  [shareParams[@"description"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:shareParams[@"img"]]];
    UIImage *image          =  [UIImage imageWithData:data];
    
    
    NSLog(@"title=%@, webUrl=%@, songWriter=%@, img=%@", title, webUrl, songWriter, shareParams[@"img"]);
    
    switch (shareType) {
        case WECHAT_SHARE: {
            [ShareManager weChatShareAction:title mp3Url:mp3Url webUrl:webUrl image:image songWriter:songWriter];
        }
            break;
        case FREND_SHARE: {
            [ShareManager friendShareAction:title mp3Url:mp3Url webUrl:webUrl image:image songWriter:songWriter];
        }
            break;
        case WEIBO_SHARE: {
            [ShareManager WeiboShareAction:title mp3Url:mp3Url webUrl:webUrl image:image songWriter:songWriter];
        }
            break;
        case QQ_SHARE: {
            [ShareManager QQShareAction:title mp3Url:mp3Url webUrl:webUrl image:image songWriter:songWriter];
        }
            break;
        case QQZONE_SHARE: {
            [ShareManager QZoneShareAction:title mp3Url:mp3Url webUrl:webUrl image:image songWriter:songWriter];
        }
            break;
        case COPY_SHARE: {
            UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
            pasteboard.string = webUrl;
            [MBProgressHUD showSuccess:@"已复制的剪贴板"];
        }
            break;
        default:
            break;
    }
}

// 微信分享按钮
+ (void)weChatShareAction:(NSString *)title mp3Url:(NSString *)mp3 webUrl:(NSString *)web image:(UIImage *)image songWriter:(NSString *)writer {
    
    // 点击分享微信的按钮统计
    //    [MobClick event:@"play_shareWechat"];
    
    if (![XWAFNetworkTool checkNetwork]) {
        //        [MBProgressHUD showError:@"网络不给力"];
        [KVNProgress showErrorWithStatus:@"网络不给力"];
        return;
    }
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = title;
    message.description = writer;
    [message setThumbImage:image];
    
    WXWebpageObject *ext = [WXWebpageObject object];
    ext.webpageUrl = web;
    message.mediaObject = ext;
    
    SendMessageToWXReq  *req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = WXSceneSession;
    
    [WXApi sendReq:req];
}

// 朋友圈分享按钮
+ (void)friendShareAction:(NSString *)title mp3Url:(NSString *)mp3 webUrl:(NSString *)web image:(UIImage *)image songWriter:(NSString *)writer {
    
    // 点击分享朋友圈按钮统计
    //    [MobClick event:@"play_shareFriend"];
    
    if (![XWAFNetworkTool checkNetwork]) {
        //        [MBProgressHUD showError:@"网络不给力"];
        [KVNProgress showErrorWithStatus:@"网络不给力"];
        return;
    }
    
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = title;
    message.description = writer;
    
    [message setThumbImage:image];
    
    WXWebpageObject *ext = [WXWebpageObject object];
    ext.webpageUrl = web;
    message.mediaObject = ext;
    
    SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = WXSceneTimeline;
    
    [WXApi sendReq:req];
}

// QQ分享按钮
+ (void)QQShareAction:(NSString *)title mp3Url:(NSString *)mp3 webUrl:(NSString *)web image:(UIImage *)image songWriter:(NSString *)writer {
    
//    web = @"http://www.woyaoxiege.com/home/index/spqResult.html?pa=%25E5%25AE%258B%25E6%2585%25A7%25E4%25B9%2594&sha=%25E5%2588%2598%25E8%25AF%2597%25E8%25AF%2597&qu=%25E5%2585%25B3%25E6%2599%2593%25E5%25BD%25A4&fenxiang=%E5%85%B3%E6%99%93%E5%BD%A4";
    
    // 点击分享QQ按钮统计
    //    [MobClick event:@"play_shareQQ"];
    
    if (![XWAFNetworkTool checkNetwork]) {
        //        [MBProgressHUD showError:@"网络不给力"];
        [KVNProgress showErrorWithStatus:@"网络不给力"];
        return;
    }
    
    NSData *data = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"shareIcon" ofType:@"png"]];
    
    if (image != nil) {
        if (UIImagePNGRepresentation(image) == nil) {
            data = UIImageJPEGRepresentation(image, 1);
        } else {
            data = UIImagePNGRepresentation(image);
        }
    }
    
    QQApiNewsObject *newsObj = [QQApiNewsObject objectWithURL:[NSURL URLWithString:web] title:title description:writer previewImageData:data];
    
    SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:newsObj];
    QQApiSendResultCode sent = [QQApiInterface sendReq:req];
    
    AppDelegate *myAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    myAppDelegate.ShareType = QQShare;
    
    NSLog(@"%d", sent);
    if (sent == 0) {
        myAppDelegate.willShowShareToast = YES;
    }
}

// QZone分享按钮
+ (void)QZoneShareAction:(NSString *)title mp3Url:(NSString *)mp3 webUrl:(NSString *)web image:(UIImage *)image songWriter:(NSString *)writer {
    // 点击分享到QQ空间按钮
    
    if (![XWAFNetworkTool checkNetwork]) {
        [KVNProgress showErrorWithStatus:@"网络不给力"];
        return;
    }
    
    NSData *data = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"shareIcon" ofType:@"png"]];
    
    if (image != nil) {
        if (UIImagePNGRepresentation(image) == nil) {
            data = UIImageJPEGRepresentation(image, 1);
        } else {
            data = UIImagePNGRepresentation(image);
        }
    }
    QQApiNewsObject *newsObj = [QQApiNewsObject objectWithURL:[NSURL URLWithString:web] title:title description:writer previewImageData:data];
    SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:newsObj];
    QQApiSendResultCode sent = [QQApiInterface SendReqToQZone:req];
    
    NSLog(@"%d", sent);
    
    AppDelegate *myAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    myAppDelegate.ShareType = QZoneShare;
    
    if (sent == 0) {
        myAppDelegate.willShowShareToast = YES;
    }
    
}

+ (void)WeiboShareAction:(NSString *)title mp3Url:(NSString *)mp3 webUrl:(NSString *)web image:(UIImage *)image songWriter:(NSString *)writer {
    
    //    [MobClick event:@"play_weiboShare"];
    
    if (![XWAFNetworkTool checkNetwork]) {
        //        [MBProgressHUD showError:@"网络不给力"];
        [KVNProgress showErrorWithStatus:@"网络不给力"];
        return;
    }
    [[UMSocialDataService defaultDataService] postSNSWithTypes:@[UMShareToSina] content:web image:image location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response) {
        if (response.responseCode == UMSResponseCodeSuccess) {
            NSLog(@"分享成功");
            AppDelegate *myAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            myAppDelegate.willShowShareToast = YES;
            //            [MobClick event:@"play_weiboShareSuccess"];
        }
    }];
    
}

@end
