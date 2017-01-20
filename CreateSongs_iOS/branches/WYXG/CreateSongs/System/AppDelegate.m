//
//  AppDelegate.m
//  CreateSongs
//
//  Created by 爱写歌 on 16/7/13.
//  Copyright © 2016年 AXG. All rights reserved.
//

#import "AppDelegate.h"
#import "HomeViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "AEAudioController.h"
#import "RecoderClass.h"
#import "IntroduceViewController.h"
#import "PersonCenterController.h"
#import "CustomNaviController.h"
#import "DrawerViewController.h"
#import "MMDrawerController.h"
#import "ReleaseViewController.h"
#import "StyleViewController.h"
#import "XieciViewController.h"
#import "KVNProgress.h"
#import "SuggestViewController.h"
#import "DraftsViewController.h"
#import "ForumViewController.h"
#import "UMSocial.h"
#import "UMSocialWechatHandler.h"
#import "UMSocialQQHandler.h"
#import "MobClick.h"
#import "WXApi.h"
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/TencentOAuthObject.h>
#import <TencentOpenAPI/TencentApiInterface.h>
#import "WeiboSDK.h"
#import "UMSocialSinaSSOHandler.h"
#import "UMSocialSinaHandler.h"
#import <SMS_SDK/SMSSDK.h>
#import "LoginViewController.h"
#import "ModifyViewController.h"
#import "UMessage.h"
#import "AXGCache.h"
#import "TYCache.h"
#import "CreateSongs-Swift.h"
//#import "KYDrawerController.h"
#import "XMidiPlayer.h"
#import "VoiceSettingController.h"
#import "MBProgressHUD.h"
#import "EMSDK.h"
#import "EaseUI.h"
//#import "AppDelegate+EaseMob.h"
#import "AXGStartView.h"
#import "LOGIN.h"
//#import "Growing.h"
//#import <JSPatch/JSPatch.h>

#define app_key @"114044c49bfa0"
#define app_secrect @"e7e4c85c029be4a44944a9415c03ad06"

@interface AppDelegate ()<WXApiDelegate, TencentSessionDelegate, QQApiInterfaceDelegate, WeiboSDKDelegate, EMChatManagerDelegate>

@end

@implementation AppDelegate

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (BOOL)introduceShowed {
    BOOL isShowed = [[NSUserDefaults standardUserDefaults] boolForKey:@"introduceShowed"];
    if (!isShowed) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"introduceShowed"];
    }
    return isShowed;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [[NSUserDefaults standardUserDefaults] setObject:IS_TEST_NO forKey:IS_TEST];
    
//    [self configJSPath];
    
    [self configAudioSettingWithOptions:launchOptions];
    
    [self configHXWithApplication:application Options:launchOptions];
    
    [self configWindowRootViewsWithOptions:launchOptions];
    
    if (![self introduceShowed] || ![LOGIN isLogin]) {
        [self configIntroduceController];
    }
    AXGStartView *startView = [AXGStartView startView];
    WEAK_SELF;
    [startView startAnimationWithCompletionBlock:^(AXGStartView *easeStartView) {
        STRONG_SELF;
        [self completionStartAnimationWithApplication:application Options:launchOptions];
    }];
    return YES;
}

//- (void)configJSPath {
//    [JSPatch startWithAppKey:@"658b0a5c17202c8e"];
//    
//    //用来检测回调的状态，是更新或者是执行脚本之类的，相关信息，会打印在你的控制台
//    [JSPatch setupCallback:^(JPCallbackType type, NSDictionary *data, NSError *error) {
//        
//        NSLog(@"error-->%@",error);
//        switch (type) {
//            case JPCallbackTypeUpdate: {
//                NSLog(@"更新脚本 %@ %@", data, error);
//                break;
//            }
//            case JPCallbackTypeRunScript: {
//                NSLog(@"执行脚本 %@ %@", data, error);
//                break;
//            }
//            case JPCallbackTypeCondition: {
//                NSLog(@"条件下发 %@ %@", data, error);
//                break;
//            }
//            case JPCallbackTypeGray: {
//                NSLog(@"灰度下发 %@ %@", data, error);
//                break;
//            }
//            default:
//                break;
//        }
//    }];
//#ifdef DEBUG
//    [JSPatch setupDevelopment];
//#endif
//    [JSPatch sync];
//}

- (void)configHXWithApplication:(UIApplication *)application Options:(NSDictionary *)launchOptions {
    /****************************环信注册*****************************/
    //AppKey:注册的AppKey，详细见下面注释。
    //apnsCertName:推送证书名（不需要加后缀），详细见下面注释。
    EMOptions *options = [EMOptions optionsWithAppkey:@"20160830#woyaoxiege"];
    options.apnsCertName = @"";
    [[EMClient sharedClient] initializeSDKWithOptions:options];
    
    //    [self easemobApplication:application didFinishLaunchingWithOptions:launchOptions appkey:@"20160830#woyaoxiege" apnsCertName:@"" otherConfig:@{kSDKConfigEnableConsoleLogger:[NSNumber numberWithBool:YES]}];
    
    [[EaseSDKHelper shareHelper] hyphenateApplication:application
                        didFinishLaunchingWithOptions:launchOptions
                                               appkey:@"20160830#woyaoxiege"
                                         apnsCertName:@""
                                          otherConfig:@{kSDKConfigEnableConsoleLogger:[NSNumber numberWithBool:YES]}];
    
    [self loginIM];

}

- (void)configAudioSettingWithOptions:(NSDictionary *)launchOptions {
    if (!self.deviceIsReady) {
        [XMidiPlayer xInit];
        self.deviceIsReady = YES;
    }
    /***************************耳机监控****************************/
    [[AVAudioSession sharedInstance] setDelegate:self];
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    AudioSessionAddPropertyListener(kAudioSessionProperty_AudioRouteChange, audioRouteChangeListenerCallback, (__bridge void *)(self));
    
    /***************************初始化录音控制器****************************/
    self.audioController = [[AEAudioController alloc] initWithAudioDescription:[AEAudioController nonInterleaved16BitStereoAudioDescription] inputEnabled:YES];
    self.audioController.preferredBufferDuration = 0.005;
    [self.audioController start:NULL];
    [RecoderClass sharedRecoderClass].shouldChangeEar = NO;
}

- (void)configWindowRootViewsWithOptions:(NSDictionary *)launchOptions {
    
    // 更改UA
    //get the original user-agent of webview
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectZero];
    NSString *oldAgent = [webView stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"];
    NSLog(@"old agent :%@", oldAgent);
    
    //add my info to the new agent
    NSString *newAgent = [NSString stringWithFormat:@"app=wyxg%@", oldAgent];
    NSLog(@"new agent :%@", newAgent);
    
    //regist the new agent
    NSDictionary *dictionnary = [[NSDictionary alloc] initWithObjectsAndKeys:newAgent, @"UserAgent", nil];
    [[NSUserDefaults standardUserDefaults] registerDefaults:dictionnary];
    
    /***************************初始化界面****************************/
    HomeViewController *mainHomeVC = [[HomeViewController alloc] init];
    CustomNaviController *nav = [[CustomNaviController alloc] initWithRootViewController:mainHomeVC];
    
    [nav setNavigationBarHidden:YES];
    DrawerViewController *mvc = [[DrawerViewController alloc] init];
    
    
    self.kyDrawer = [[KYDrawerController alloc] initWithDrawerDirection:DrawerDirectionLeft drawerWidth:250 * WIDTH_NIT];
    self.kyDrawer.mainViewController = nav;
    self.kyDrawer.drawerViewController = mvc;
    self.kyDrawer.containerViewMaxAlpha = 0.7;
    mvc.kyDrawer = self.kyDrawer;

    self.window.rootViewController = self.kyDrawer;
    [self.window makeKeyAndVisible];
}

- (void)configIntroduceController {
    IntroduceViewController *ivc = [[IntroduceViewController alloc] init];
    ivc.drawerController = self.drawController;
    [self.window.rootViewController addChildViewController:ivc];
    [self.window.rootViewController.view addSubview:ivc.view];
}

- (void)completionStartAnimationWithApplication:(UIApplication *)application Options:(NSDictionary *)launchOptions {
    // pushnotification信息
    NSDictionary *remoteNotification = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if (remoteNotification.count != 0) {
        self.isLaunchedByNotification = YES;
    } else {
        self.isLaunchedByNotification = NO;
    }
    self.remoteNotification = [[NSDictionary alloc] initWithDictionary:remoteNotification];
    NSLog(@"%@", remoteNotification);
    
    self.isLaunchedBySafari = NO;
    self.safariString = @"";
    
   
    [UMSocialData setAppKey:@"56d565cae0f55a7eb6000776"];
    
    self.rankDataShouldRefresh = YES;
    self.song_tag = @"";
    self.activityId = @"0";
    self.songId = @"";
    self.songCode = @"";
    self.originSongName = @"";
    self.lyricWriter = @"";
    self.songWriter = @"";
    self.songSinger = @"";
    self.isFanChang = NO;
    
    /******************************推送*******************************/
    // 友盟推送
    [UMessage startWithAppkey:@"56d565cae0f55a7eb6000776" launchOptions:launchOptions];
    [UMessage setLogEnabled:YES];
    
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 80000
    //iOS8以上的推送
    //options用NSNumericSearch逐个取出数字进行比较。先比较第一个数字，相等的话继续比第二个，以此类推
    //compare比较后的结果，分别是 = <>：NSOrderedSame = 0  NSOrderedAscending = -1  NSOrderedDescending = +1
    if ([[[UIDevice currentDevice] systemVersion] compare:@"8.0"options:NSNumericSearch] != NSOrderedAscending)
    {
        UIMutableUserNotificationAction *action1 = [[UIMutableUserNotificationAction alloc]init];
        action1.identifier = @"action1_identifier";
        action1.title = @"Accept";
        //当点击的时候启动程序
        action1.activationMode = UIUserNotificationActivationModeForeground;
        
        UIMutableUserNotificationAction *action2 = [[UIMutableUserNotificationAction alloc] init];
        action2.identifier = @"action2_identifier";
        action2.title = @"Reject";
        //当点击的时候不启动程序，在后台处理
        action2.activationMode = UIUserNotificationActivationModeBackground;
        //需要解锁才能处理
        action2.authenticationRequired = YES;
        action2.destructive = YES;
        
        UIMutableUserNotificationCategory *categorys = [[UIMutableUserNotificationCategory alloc] init];
        //这组动作的唯一标示
        categorys.identifier = @"category1";
        [categorys setActions:@[action1,action2]forContext:(UIUserNotificationActionContextDefault)];
        
        UIUserNotificationSettings *userSettings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge|UIUserNotificationTypeSound|UIUserNotificationTypeAlert categories:[NSSet setWithObject:categorys]];
        [UMessage registerRemoteNotificationAndUserNotificationSettings:userSettings];
    }else{
        //注册消息推送类型
        [UMessage registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge|UIRemoteNotificationTypeSound|UIRemoteNotificationTypeAlert];
    }
#else
    [UMessage registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge|UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeSound];
#endif
    
    
    /***************************各渠道分享注册****************************/
    
    [WXApi registerApp:@"wxab1c2b71c7ff40c6"];
    [UMSocialSinaSSOHandler openNewSinaSSOWithAppKey:@"3428038518"
                                              secret:@"a7c9598725dc82e3d53334185a5adb20"
                                         RedirectURL:@"https://api.weibo.com/oauth2/default.html"];
    TencentOAuth *tencent = [[TencentOAuth alloc] initWithAppId:@"1104985545" andDelegate:self];
    [WeiboSDK registerApp:@"3428038518"];
    
    if ([WeiboSDK isWeiboAppInstalled]) {
        self.weiboInstall = YES;
    } else {
        self.weiboInstall = NO;
    }
    
    NSString *str = [UIDevice currentDevice].model;
    
    NSLog(@"%@", str);
    
    if ([WXApi isWXAppInstalled]) {
        self.wxIsInstall = YES;
    }
    self.wxIsInstall = [WXApi isWXAppInstalled] && [WXApi isWXAppSupportApi];
    
    if ([TencentOAuth iphoneQQInstalled]) {
        self.QQIsInstall = YES;
    }
    self.QQIsInstall = [TencentOAuth iphoneQQInstalled] && [TencentOAuth iphoneQQSupportSSOLogin];
    
    /***************************短信验证码****************************/
    [SMSSDK registerApp:app_key withSecret:app_secrect];
    
    /***************************友盟设置版本号/GrowingIO注册****************************/
    
    unsigned int methCount = 0;
    Method *meths = class_copyMethodList([MobClick class], &methCount);
    for (int i = 0; i < methCount; i++) {
        Method meth = meths[i];
        
        SEL sel = method_getName(meth);
        
        const char *name = sel_getName(sel);
        
        NSLog(@"%s", name);
    }
    
    [MobClick startWithAppkey:@"56d565cae0f55a7eb6000776" reportPolicy:BATCH   channelId:@""];
    
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [MobClick setAppVersion:version];
    
    // 新版本清理缓存
    if (![[[NSUserDefaults standardUserDefaults] objectForKey:@"appCacheVersion"] isEqualToString:version]) {
        [AXGCache resetCache];
        [TYCache resetCache];
        [[NSURLCache sharedURLCache] removeAllCachedResponses];
    }
    [[NSUserDefaults standardUserDefaults] setObject:version forKey:@"appCacheVersion"];
}

#pragma mark - 登录环信
// 登录环信
- (void)loginIM {
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:IS_LOGIN] isEqualToString:IS_LOGIN_YES]) {
        
        KeychainItemWrapper *wrapper = [[KeychainItemWrapper alloc] initWithIdentifier:USER_ACCOUNT accessGroup:nil];
        NSString *userId = [wrapper objectForKey:(id)kSecValueData];
        
        [[EMClient sharedClient].chatManager addDelegate:self delegateQueue:nil];
        
        // 登录
        BOOL isAutoLogin = [EMClient sharedClient].options.isAutoLogin;
        if (!isAutoLogin) {
            EMError *error = [[EMClient sharedClient] loginWithUsername:userId password:@"000"];
            if (!error) {
                NSLog(@"登录成功");
                [[EMClient sharedClient].options setIsAutoLogin:YES];
            } else {
                NSLog(@"登录失败 %@", error.description);
            }
        }
        
    }
    
}

#pragma mark - notification

//// 改变根视图的通知方法
//- (void)changeDrawerRoot:(NSNotification *)message {
//
//    if ([message.object isEqualToString:@"首页"]) {
//        // 我要写歌
//        
//        [[NSUserDefaults standardUserDefaults] setObject:DRAWER_LOCATION_HOME forKey:DRAWER_LOCATION];
//        
//        if ([self.drawController.centerViewController isKindOfClass:[HomeViewController class]]) {
//            // 收回抽屉
//        } else {
//            HomeViewController *mainHomeVC = [[HomeViewController alloc] init];
//            CustomNaviController *nav = [[CustomNaviController alloc] initWithRootViewController:mainHomeVC];
//            [nav setNavigationBarHidden:YES];
//            //            AXGMyViewController *mvc = [[AXGMyViewController alloc] init];
////            mainHomeVC.drawerVC = mvc;
//            
//            [self.drawController setCenterViewController:nav withCloseAnimation:YES completion:^(BOOL finished) {
//                
//            }];
//            [self.drawController setLeftDrawerViewController:self.drawController.leftDrawerViewController];
//
//            self.drawController.openDrawerGestureModeMask = MMOpenDrawerGestureModeNone;
//            self.drawController.closeDrawerGestureModeMask = MMCloseDrawerGestureModeAll;
//            
//        }
//        
//    } else if ([message.object isEqualToString:@"建议"]) {
//        // 意见反馈
//        
//        [[NSUserDefaults standardUserDefaults] setObject:DRAWER_LOCATION_SUGGEST forKey:DRAWER_LOCATION];
//        
//        if ([self.drawController.centerViewController isKindOfClass:[SuggestViewController class]]) {
//            // 收回抽屉
//        } else {
//            SuggestViewController *mainHomeVC = [[SuggestViewController alloc] init];
//            CustomNaviController *nav = [[CustomNaviController alloc] initWithRootViewController:mainHomeVC];
//            [nav setNavigationBarHidden:YES];
//            //            AXGMyViewController *mvc = [[AXGMyViewController alloc] init];
////            mainHomeVC.drawerVC = mvc;
//            
//            [self.drawController setCenterViewController:nav withCloseAnimation:YES completion:^(BOOL finished) {
//                
//            }];
//            [self.drawController setLeftDrawerViewController:self.drawController.leftDrawerViewController];
//            
//            self.drawController.openDrawerGestureModeMask = MMOpenDrawerGestureModeNone;
//            self.drawController.closeDrawerGestureModeMask = MMCloseDrawerGestureModeAll;
//            
//        }
//        
//    } else if ([message.object isEqualToString:@"草稿"]) {
//        
//        // 草稿箱
//        
//        [[NSUserDefaults standardUserDefaults] setObject:DRAWER_LOCATION_DRAFTS forKey:DRAWER_LOCATION];
//        
//        if ([self.drawController.centerViewController isKindOfClass:[DraftsViewController class]]) {
//            // 收回抽屉
//        } else {
//            DraftsViewController *mainHomeVC = [[DraftsViewController alloc] init];
//            CustomNaviController *nav = [[CustomNaviController alloc] initWithRootViewController:mainHomeVC];
//            [nav setNavigationBarHidden:YES];
//            //            AXGMyViewController *mvc = [[AXGMyViewController alloc] init];
////            mainHomeVC.drawerVC = mvc;
//            
//            [self.drawController setCenterViewController:nav withCloseAnimation:YES completion:^(BOOL finished) {
//                
//            }];
//            [self.drawController setLeftDrawerViewController:self.drawController.leftDrawerViewController];
//            
//            self.drawController.openDrawerGestureModeMask = MMOpenDrawerGestureModeNone;
//            self.drawController.closeDrawerGestureModeMask = MMCloseDrawerGestureModeAll;
//        }
//        
//    } else if ([message.object isEqualToString:@"个人"]) {
//        
//        // 个人中心
//        [[NSUserDefaults standardUserDefaults] setObject:DRAWER_LOCATION_PERSON forKey:DRAWER_LOCATION];
//        
//        if (![XWAFNetworkTool checkNetwork]) {
//            //            [MBProgressHUD showError:@"网络不给力"];
//            [KVNProgress showErrorWithStatus:@"网络不给力"];
//            
//            return;
//        }
//        
//        if ([self.drawController.centerViewController isKindOfClass:[PersonCenterController class]]) {
//            // 收回抽屉
//        } else {
//            
//            if ([[[NSUserDefaults standardUserDefaults] objectForKey:IS_LOGIN] isEqualToString:IS_LOGIN_YES]) {
//                
//                PersonCenterController *mainHomeVC = [[PersonCenterController alloc] init];
//                CustomNaviController *nav = [[CustomNaviController alloc] initWithRootViewController:mainHomeVC];
//                [nav setNavigationBarHidden:YES];
//                //            AXGMyViewController *mvc = [[AXGMyViewController alloc] init];
//                //                mainHomeVC.drawerVC = mvc;
//                
//                [self.drawController setCenterViewController:nav withCloseAnimation:YES completion:^(BOOL finished) {
//                    
//                }];
//                [self.drawController setLeftDrawerViewController:self.drawController.leftDrawerViewController];
//                
//                self.drawController.openDrawerGestureModeMask = MMOpenDrawerGestureModeNone;
//                self.drawController.closeDrawerGestureModeMask = MMCloseDrawerGestureModeAll;
//                
//            } else {
//                AXG_LOGIN(LOGIN_LOCATION_PERSON);
//            }
//            
//        }
//        
//    } else if ([message.object isEqualToString:@"乐谈"]) {
//        
//        // 草稿箱
//        
//        [[NSUserDefaults standardUserDefaults] setObject:DRAWER_LOCATION_DRAFTS forKey:DRAWER_LOCATION];
//        
//        if ([self.drawController.centerViewController isKindOfClass:[ForumViewController class]]) {
//            // 收回抽屉
//        } else {
//            ForumViewController *mainHomeVC = [[ForumViewController alloc] init];
//            CustomNaviController *nav = [[CustomNaviController alloc] initWithRootViewController:mainHomeVC];
//            [nav setNavigationBarHidden:YES];
//            //            AXGMyViewController *mvc = [[AXGMyViewController alloc] init];
////            mainHomeVC.drawerVC = mvc;
//            
//            [self.drawController setCenterViewController:nav withCloseAnimation:YES completion:^(BOOL finished) {
//                
//            }];
//            [self.drawController setLeftDrawerViewController:self.drawController.leftDrawerViewController];
//            
//            self.drawController.openDrawerGestureModeMask = MMOpenDrawerGestureModeNone;
//            self.drawController.closeDrawerGestureModeMask = MMCloseDrawerGestureModeAll;
//        }
//        
//    } else if ([message.object isEqualToString:@"头像"]) {
//        
//        // 头像
//        [[NSUserDefaults standardUserDefaults] setObject:DRAWER_LOCATION_HEAD forKey:DRAWER_LOCATION];
//    
//        if ([[[NSUserDefaults standardUserDefaults] objectForKey:IS_LOGIN] isEqualToString:IS_LOGIN_YES]) {
//            
//            ModifyViewController *mainHomeVC = [[ModifyViewController alloc] init];
//            mainHomeVC.fromDrawer = YES;
//            CustomNaviController *nav = [[CustomNaviController alloc] initWithRootViewController:mainHomeVC];
//            [nav setNavigationBarHidden:YES];
//            //            AXGMyViewController *mvc = [[AXGMyViewController alloc] init];
//            //            mainHomeVC.drawerVC = mvc;
//            
//            [self.drawController setCenterViewController:nav withCloseAnimation:YES completion:^(BOOL finished) {
//                
//            }];
//            [self.drawController setLeftDrawerViewController:self.drawController.leftDrawerViewController];
//            
//            self.drawController.openDrawerGestureModeMask = MMOpenDrawerGestureModeNone;
//            self.drawController.closeDrawerGestureModeMask = MMCloseDrawerGestureModeAll;
//            
//        } else {
//
//            AXG_LOGIN(LOGIN_LOCATION_DRAWER);
//        }
//        
//        
////        if ([[[NSUserDefaults standardUserDefaults] objectForKey:IS_LOGIN] isEqualToString:IS_LOGIN_YES]) {
////            
////            if (![XWAFNetworkTool checkNetwork]) {
////                //            [MBProgressHUD showError:@"网络不给力"];
////                [KVNProgress showErrorWithStatus:@"网络不给力"];
////                
////                return;
////            }
////            
////            if ([self.drawController.centerViewController isKindOfClass:[RegisterViewController class]]) {
////                // 收回抽屉
////            } else {
////                RegisterViewController *mainHomeVC = [[RegisterViewController alloc] init];
////                mainHomeVC.fromType = fromHome;
////                CustomNaviController *nav = [[CustomNaviController alloc] initWithRootViewController:mainHomeVC];
////                [nav setNavigationBarHidden:YES];
////                //            AXGMyViewController *mvc = [[AXGMyViewController alloc] init];
////                mainHomeVC.myViewController = mvc;
////                
////                [self.drawController setCenterViewController:nav withCloseAnimation:YES completion:^(BOOL finished) {
////                    
////                }];
////                [self.drawController setLeftDrawerViewController:self.drawController.leftDrawerViewController];
////                
////                self.drawController.openDrawerGestureModeMask = MMOpenDrawerGestureModeNone;
////                self.drawController.closeDrawerGestureModeMask = MMCloseDrawerGestureModeAll;
////            }
////            
////        } else {
////            
////            UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
////            
////            MessageIdentifyViewController *messageVC = [[MessageIdentifyViewController alloc] init];
////            
////            if (message.userInfo[COMMENT_NOTI_INFO]) {
////                messageVC.isFromComment = YES;
////            } else {
////                messageVC.isFromComment = NO;
////            }
////            [window.rootViewController presentViewController:messageVC animated:YES completion:^{
////                
////            }];
////        }
//        
//    }
//    
//}

#pragma mark - 分享回调
- (void)tencentDidLogin {
    
}

- (void)tencentDidNotLogin:(BOOL)cancelled {
    
}

- (void)tencentDidNotNetWork {
    
}

- (void)didReceiveWeiboRequest:(WBBaseRequest *)request {
    
}

- (void)didReceiveWeiboResponse:(WBBaseResponse *)response {
    
    //    if (response.statusCode == WeiboSDKResponseStatusCodeSuccess) {
    //        NSLog(@"微博分享成功");
    //        self.willShowShareToast = YES;
    ////        [KVNProgress showSuccessWithStatus:@"已分享"];
    //        [MobClick event:@"play_weiboShareSuccess"];
    //    }
    
    if ([response isKindOfClass:WBSendMessageToWeiboResponse.class]) {
        WBSendMessageToWeiboResponse* sendMessageToWeiboResponse = (WBSendMessageToWeiboResponse*)response;
        NSString* accessToken = [sendMessageToWeiboResponse.authResponse accessToken];
        if (accessToken)
        {
            self.wbtoken = accessToken;
        }
    } else if ([response isKindOfClass:WBAuthorizeResponse.class]) {
        
        //        WBAuthorizeResponse *wbResponse = (WBAuthorizeResponse *)response;
        
        if (response.statusCode == WeiboSDKResponseStatusCodeSuccess) {
            NSLog(@"授权成功");
        } else if (response.statusCode == WeiboSDKResponseStatusCodeAuthDeny) {
            NSLog(@"授权失败");
        }
        
        self.wbtoken = [(WBAuthorizeResponse *)response accessToken];
        
        self.weiboUid = response.userInfo[@"uid"];
        self.weiboToken = response.userInfo[@"access_token"];
        
#if FAST_LOGIN
        
        if ([response.userInfo[@"user_cancelled"] length] != 0 && [response.userInfo[@"user_cancelled"] isEqualToString:@"t"]) {
            NSLog(@"用户手动取消授权");
        } else {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"getWeiboInfo" object:@{@"uid":self.weiboUid, @"token":self.weiboToken}];
        }
        
#endif
        
    }
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    
    if ([url.scheme isEqualToString:@"wyxg"]) {
        return YES;
    }
    
    return [WeiboSDK handleOpenURL:url delegate:self] || [TencentOAuth HandleOpenURL:url] || [WXApi handleOpenURL:url delegate:self];
    
//    return [TencentOAuth HandleOpenURL:url] || [WXApi handleOpenURL:url delegate:self];

}

// 分享系统回调
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    
    if ([url.scheme isEqualToString:@"wyxg"]) {
        NSString *urlString = url.absoluteString;
        
        // 这里处理从浏览器打开APP后的参数
        self.isLaunchedBySafari = YES;
        self.safariString = urlString;
        
        return YES;
    }
    
    self.isLaunchedBySafari = NO;
    self.safariString = @"";

    return [WeiboSDK handleOpenURL:url delegate:self] || [TencentOAuth HandleOpenURL:url] || [WXApi handleOpenURL:url delegate:self] || [UMSocialSnsService handleOpenURL:url];
    
//    return [TencentOAuth HandleOpenURL:url] || [WXApi handleOpenURL:url delegate:self] || [UMSocialSnsService handleOpenURL:url];
    
}

- (void)onReq:(BaseReq *)req {
    NSLog(@"back");
}

- (void)onResp:(BaseResp *)resp {
    NSLog(@"back1") ;
    if([resp isKindOfClass:[SendMessageToWXResp class]])
    {
        
        if (resp.errCode == 0) {
            
            self.willShowShareToast = YES;
            
//                        [KVNProgress showSuccessWithStatus:@"已分享"];
            
            if (self.ShareType == wxShare) {
                NSLog(@"好友");
                [MobClick event:@"play_shareWechatSuccess"];
            } else {
                NSLog(@"朋友圈");
                [MobClick event:@"play_shareFriendSuccess"];
            }
        }
    } else if ([resp isKindOfClass:[SendAuthResp class]]) {
        if (resp.errCode == 0) {
            NSLog(@"授权成功");
            
            SendAuthResp *sendResp = (SendAuthResp *)resp;
            NSLog(@"resp code = %@", sendResp.code);
            
            self.weChatCode = sendResp.code;
            
            NSString *code = sendResp.code;
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"getWeChatInfo" object:@{@"code":code}];
            //            [[NSNotificationCenter defaultCenter] postNotificationName:@"getWeChatInfo" object:nil userInfo:@{@"code":code}];
            
        } else if (resp.errCode == -2) {
            NSLog(@"用户取消授权");
        } else if (resp.errCode == -4) {
            NSLog(@"授权失败");
        }
    } else if([resp isKindOfClass:[PayResp class]]) {
        
        NSString *strMsg,*strTitle = [NSString stringWithFormat:@"支付结果"];
        
        switch (resp.errCode) {
            case WXSuccess:
                strMsg = @"支付结果：成功！";
                NSLog(@"支付成功－PaySuccess，retcode = %d", resp.errCode);
                
                break;
            default:
                strMsg = [NSString stringWithFormat:@"支付结果：失败！retcode = %d, retstr = %@", resp.errCode,resp.errStr];
                NSLog(@"错误，retcode = %d, retstr = %@", resp.errCode,resp.errStr);
                break;
        }
    }
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSLog(@"%@",[[[[deviceToken description] stringByReplacingOccurrencesOfString: @"<" withString: @""]                  stringByReplacingOccurrencesOfString: @">" withString: @""]                 stringByReplacingOccurrencesOfString: @" " withString: @""]);
    
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [UMessage didReceiveRemoteNotification:userInfo];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"enterAppFromPushNotification" object:userInfo];
    
    NSLog(@"%@", userInfo);
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"applicationBackGround" object:nil];
    
    // 环信
    [[EMClient sharedClient] applicationDidEnterBackground:application];
    
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    
    // 环信
    [[EMClient sharedClient] applicationWillEnterForeground:application];
    
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    
    [UMSocialSnsService  applicationDidBecomeActive];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"applicationActive" object:nil];
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
//触发的监听事件
void audioRouteChangeListenerCallback (void *inUserData, AudioSessionPropertyID inPropertyID, UInt32 inPropertyValueSize,const void *inPropertyValue ) {

    if (inPropertyID != kAudioSessionProperty_AudioRouteChange) return;
    
    
    {
        CFDictionaryRef routeChangeDictionary = (CFDictionaryRef)inPropertyValue;

        CFNumberRef routeChangeReasonRef = (CFNumberRef)CFDictionaryGetValue (routeChangeDictionary, CFSTR (kAudioSession_AudioRouteChangeKey_Reason) );
        
        SInt32 routeChangeReason;
        
        CFNumberGetValue (routeChangeReasonRef, kCFNumberSInt32Type, &routeChangeReason);
        
        if (routeChangeReason == kAudioSessionRouteChangeReason_OldDeviceUnavailable) {

            [[NSNotificationCenter defaultCenter] postNotificationName:@"noneEarPod" object:nil];
            
        } else if (routeChangeReason == kAudioSessionRouteChangeReason_NewDeviceAvailable) {

            [[NSNotificationCenter defaultCenter] postNotificationName:@"earPod" object:nil];
            
            NSLog(@"有耳机！");
        }
    }
}

#pragma mark - EMDelegate
- (void)messagesDidReceive:(NSArray *)aMessages {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"didReceiveMessage" object:nil];
}

@end
