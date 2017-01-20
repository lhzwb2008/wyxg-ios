//
//  AXGMediator+MediatorModuleAActions.m
//  CreateSongs
//
//  Created by axg on 16/9/6.
//  Copyright © 2016年 AXG. All rights reserved.
//

#import "AXGMediator+MediatorModuleAActions.h"

// 动作执行者
NSString * const kMediatorTargetA = @"A";
// action名
NSString * const kMediatorActionShowAlert =     @"showAlert";
NSString * const kMediatorActionController =    @"nativeController";

@implementation AXGMediator (MediatorModuleAActions)

+ (UIViewController *)AXGMediator_Controller:(NSString *)controllerName {
    UIViewController *viewController = [[AXGMediator sharedInstance] performTarget:kMediatorTargetA
                                                    action:kMediatorActionController
                                                    params:@{@"key":@"value",
                                                             @"controller":controllerName}];
    if ([viewController isKindOfClass:[UIViewController class]]) {
        return viewController;
    } else {
        return [[UIViewController alloc] init];
    }
}
/*
 @{ @"title":@"",
    @"leftTitle":@"",
    @"rightTitle":@""
 }
 */
+ (void)AXGMediator_showAlertWithMessage:(NSDictionary *)message cancelAction:(void (^)(NSDictionary *))cancelAction confirmAction:(void (^)(NSDictionary *))confirmAction {
    NSMutableDictionary *paramsToSend = [[NSMutableDictionary alloc] init];
    if (message) {
        paramsToSend[@"title"] = message[@"title"];
        paramsToSend[@"leftTitle"] = message[@"leftTitle"];
        paramsToSend[@"rightTitle"] = message[@"rightTitle"];
    }
    if (cancelAction) {
        paramsToSend[@"cancelAction"] = cancelAction;
    }
    if (confirmAction) {
        paramsToSend[@"confirmAction"] = confirmAction;
    }
    [[AXGMediator sharedInstance] performTarget:kMediatorTargetA
                 action:kMediatorActionShowAlert
                 params:paramsToSend];
}

+ (void)AXGLoadPageByUrl_Controller:(NSString *)pageUrl loadResult:(void (^)(id))loadResult{
    id result = [[AXGMediator sharedInstance] performActionWithUrl:[NSURL URLWithString:pageUrl] completion:NULL];
    if (loadResult) {
        loadResult(result);
    }
}

+ (void)AXGMediator_showViewWithUrl:(NSString *)viewUrl loadResult:(void (^)(id))loadResult {
    id result = [[AXGMediator sharedInstance] performActionWithUrl:[NSURL URLWithString:viewUrl] completion:NULL];
    if (loadResult) {
        loadResult(result);
    }
}

+ (void)AXGMeidator_showShareWithUrl:(NSString *)shareView loadResult:(void (^)(id))loadResult hideAction:(void (^)(NSDictionary *))hideAction {
    id result = [[AXGMediator sharedInstance] performActionWithUrl:[NSURL URLWithString:shareView] completion:hideAction];
    if (loadResult) {
        loadResult(result);
    }
}

+ (void)AXGMeidator_showNativiShareViewWithParams:(NSDictionary *)params loadResult:(void (^)(id))loadResult hideAction:(void (^)(NSDictionary *))hideAction {
    NSMutableDictionary *muDic = [[NSMutableDictionary alloc] initWithDictionary:params];
    [muDic setObject:hideAction forKey:@"completionAction"];
    [[AXGMediator sharedInstance] performTarget:kMediatorTargetA action:@"share" params:muDic];
}

@end
