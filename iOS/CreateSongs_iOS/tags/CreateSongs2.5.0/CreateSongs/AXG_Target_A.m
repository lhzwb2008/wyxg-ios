//
//  AXG_Target_A.m
//  CreateSongs
//
//  Created by axg on 16/9/6.
//  Copyright © 2016年 AXG. All rights reserved.
//

#import "AXG_Target_A.h"
#import "AXGMessage.h"
#import "AXGHeader.h"
#import "UserSongShareView.h"

typedef void (^AXGUrlRouterCallbackBlock)(NSDictionary *info);

@implementation AXG_Target_A

- (id)Action_showAlert:(NSDictionary *)params {
    /*
     paramsToSend[@"title"] = message[@"title"];
     paramsToSend[@"leftTitle"] = message[@"leftTitle"];
     paramsToSend[@"rightTitle"] = message[@"rightTitle"];
     */
    [AXGMessage showTextSelectMessageOnView:kKeyWindow title:params[@"title"] leftButton:params[@"leftTitle"] rightButton:params[@"rightTitle"]];

    [AXGMessage shareMessageView].leftButtonBlock = ^ () {
        AXGUrlRouterCallbackBlock callback = params[@"cancelAction"];
        if (callback) {
            callback(@{@"alertAction":@""});
        }
    };
    [AXGMessage shareMessageView].rightButtonBlock = ^ () {
        AXGUrlRouterCallbackBlock callback = params[@"confirmAction"];
        if (callback) {
            callback(@{@"alertAction":@""});
        }
    };
    return nil;
}

- (UIViewController *)Action_nativeController:(NSDictionary *)params {
    NSString *controllerName = params[@"controller"];
    Class controllerClass = NSClassFromString(controllerName);
    id myController =  [[controllerClass alloc] init];
    return (UIViewController *)myController;
}

- (UIViewController *)Action_webController:(NSDictionary *)params {
    NSString *controllerName = params[@"controller"];
    Class controllerClass = NSClassFromString(controllerName);
    id myController =  [[controllerClass alloc] init];
    return (UIViewController *)myController;
}

- (UIView *)Action_webView:(NSDictionary *)params {
    NSString *controllerName = params[@"controller"];
    Class controllerClass = NSClassFromString(controllerName);
    id myController =  [[controllerClass alloc] init];
    return (UIView *)myController;
}
/**
 shareParams[@"shareTitle"];
 shareParams[@"shareMp3Url"];
 shareParams[@"shareWebUrl"];
 shareParams[@"shareSongWriter"];
 shareParams[@"shareImage"];
 */
#define SHAREVIEW_HEIGHT ((50 * WIDTH_NIT + 6 * HEIGHT_NIT + 12 * HEIGHT_NIT + 30 * HEIGHT_NIT) * 2 + 10 * HEIGHT_NIT + 33.5 * HEIGHT_NIT)
- (UIView *)Action_share:(NSDictionary *)params {
    
    
    UIView *maskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth(), screehHeight())];
    maskView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.9];
    maskView.hidden = YES;
    [kKeyWindow addSubview:maskView];
    
    
    UserSongShareView *shareView = [[UserSongShareView alloc] initWithFrame:CGRectMake(0, screehHeight(), screenWidth(), SHAREVIEW_HEIGHT) ShareParams:params];
    [kKeyWindow addSubview:shareView];
    
    
    
    __weak typeof(maskView) weakMask = maskView;
    __weak typeof(shareView) weakShare = shareView;
    
    
    
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        __strong typeof(weakMask) maskView = weakMask;
        __strong typeof(weakShare) shareView = weakShare;
        maskView.hidden = NO;
        shareView.transform = CGAffineTransformMakeTranslation(0, -SHAREVIEW_HEIGHT);
    } completion:^(BOOL finished) {
        
    }];

    shareView.cancelBlock = ^{
        
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            __strong typeof(weakMask) maskView = weakMask;
            __strong typeof(weakShare) shareView = weakShare;
            maskView.hidden = YES;
            shareView.transform = CGAffineTransformMakeTranslation(0, SHAREVIEW_HEIGHT);
        } completion:^(BOOL finished) {
            
        }];
        AXGUrlRouterCallbackBlock callback = params[@"completionAction"];
        if (callback) {
            callback(@{@"completionAction":@""});
        }
    };
    return shareView;
}


@end
