//
//  AXGMediator+MediatorModuleAActions.h
//  CreateSongs
//
//  Created by axg on 16/9/6.
//  Copyright © 2016年 AXG. All rights reserved.
//

#import "AXGMediator.h"
#import <UIKit/UIKit.h>

@interface AXGMediator (MediatorModuleAActions)


// wyxg://A/webController?controller=XuanQuController
+ (void)AXGLoadPageByUrl_Controller:(NSString *)pageUrl loadResult:(void(^)(id controller))loadResult;

+ (UIViewController *)AXGMediator_Controller:(NSString *)controllerName;


/**
 *  AlertView
 *
 *  @param message  message[@"title"] message[@"leftTitle"] message[@"rightTitle"];
 *  @param cancelAction
 *  @param confirmAction
 */
+ (void)AXGMediator_showAlertWithMessage:(NSDictionary *)message cancelAction:(void(^)(NSDictionary *info))cancelAction confirmAction:(void(^)(NSDictionary *info))confirmAction;

/**
 shareParams[@"title"];
 shareParams[@"mp3Url"];
 shareParams[@"url"];
 shareParams[@"description"];
 [YYImage imageNamed:shareParams[@"img"]];
 */

+ (void)AXGMediator_showViewWithUrl:(NSString *)viewUrl loadResult:(void(^)(id view))loadResult;

/**
 *  远程调用分享界面
 *
 *  @param shareView  远程调用url(wyxg://shareView?title=123&url=123&description=123&img=123)
 *  @param loadResult 分享界面视图对象
 *  @param hideAction 取消那妞方法
 */
+ (void)AXGMeidator_showShareWithUrl:(NSString *)shareView loadResult:(void(^)(id view))loadResult hideAction:(void(^)(NSDictionary *info))hideAction;
/**
 *  本地调用分享界面
 *
 *  @param params     分享参数 title url description img
 *  @param loadResult 分享界面视图对象
 *  @param hideAction 取消按钮方法
 */
+ (void)AXGMeidator_showNativiShareViewWithParams:(NSDictionary *)params loadResult:(void(^)(id view))loadResult hideAction:(void(^)(NSDictionary *info))hideAction;

@end
