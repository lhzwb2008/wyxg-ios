//
//  AXGMediator.m
//  CreateSongs
//
//  Created by axg on 16/9/6.
//  Copyright © 2016年 AXG. All rights reserved.
//

#import "AXGMediator.h"

@implementation AXGMediator

+ (instancetype)sharedInstance {
    static AXGMediator *mediator;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mediator = [[AXGMediator alloc] init];
    });
    return mediator;
}
/*
 scheme://[target]/[action]?[params]
 wyxg://targetA/actionB?id=1234
 */
- (id)performActionWithUrl:(NSURL *)url completion:(void (^)(NSDictionary *))completion {
    if (![url.scheme isEqualToString:@"wyxg"]) {
        return @(NO);
    }
    
    NSMutableDictionary *params1 = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *params2 = [[NSMutableDictionary alloc] init];
    NSString *urlString = [url query];
    
    for (NSString *param in [urlString componentsSeparatedByString:@"&"]) {
        NSArray *elts = [param componentsSeparatedByString:@"="];
        
        if([elts count] < 2) continue;
        
        NSString *lastString = [elts lastObject];
        NSString *firtString = [elts firstObject];
        
        if ([firtString isEqualToString:@"img"] || [firtString isEqualToString:@"url"]) {
            
            lastString = [lastString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            
            lastString = [lastString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            
            [params1 setObject:lastString forKey:firtString];
            [params2 setObject:lastString forKey:firtString];
        } else {
            [params2 setObject:[elts lastObject] forKey:[elts firstObject]];
            
            if ([[elts firstObject] isEqualToString:@"action"]) {
                continue;
            }
            [params1 setObject:[elts lastObject] forKey:[elts firstObject]];
        }
    }
    if (completion) {
        [params1 setObject:completion forKey:@"completionAction"];
    }
    
    //  防止通过远程方式调用本地模块->本地模块只能用下边的方法调用(写死的本地跳转)
//    NSString *actionName = [url.path stringByReplacingOccurrencesOfString:@"/" withString:@""];
    NSString *actionName = params2[@"action"];
    if ([actionName hasPrefix:@"native"]) {
        return @(NO);
    }
    id result = [self performTarget:url.host action:actionName params:params1];
    if (completion) {
        if (result) {
            completion(@{@"result":result});
        } else {
            completion(nil);
        }
    }
    return result;
}

- (id)performTarget:(NSString *)targetName action:(NSString *)actionName params:(NSDictionary *)params {
    
    if ([targetName isEqualToString:@"www.woyaoxiege.com"]) {
        targetName = @"A";
    }
    NSString *targetClassString = [NSString stringWithFormat:@"AXG_Target_%@", targetName];
    NSString *actionString = [NSString stringWithFormat:@"Action_%@:", actionName];
    
    Class targetClass = NSClassFromString(targetClassString);
    id target = [[targetClass alloc] init];
    SEL action = NSSelectorFromString(actionString);
    
    if (target == nil) {
        return nil;
    }
    if ([target respondsToSelector:action]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        return [target performSelector:action withObject:params];
#pragma clang diagnostic pop
    } else {
        SEL action = NSSelectorFromString(@"notFound:");
        if ([target respondsToSelector:action]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            return [target performSelector:action withObject:params];
#pragma clang diagnostic pop
        } else {
            return nil;
        }
    }
}

@end
