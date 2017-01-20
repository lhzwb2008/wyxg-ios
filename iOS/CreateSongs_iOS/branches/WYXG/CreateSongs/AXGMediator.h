//
//  AXGMediator.h
//  CreateSongs
//
//  Created by axg on 16/9/6.
//  Copyright © 2016年 AXG. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AXGMediator : NSObject

+ (instancetype)sharedInstance;

//- (id)performActionWithUrl:(NSURL *)url hideAction:(void(^)(NSDictionary *info))hideAction;
// 远程App调用入口
- (id)performActionWithUrl:(NSURL *)url completion:(void(^)(NSDictionary *info))completion;
// 本地组件调用入口
- (id)performTarget:(NSString *)targetName action:(NSString *)actionName params:(NSDictionary *)params;

@end
