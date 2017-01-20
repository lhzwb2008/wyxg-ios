//
//  LOGIN.m
//  CreateSongs
//
//  Created by axg on 16/9/1.
//  Copyright © 2016年 AXG. All rights reserved.
//

#import "LOGIN.h"
#import "AXGHeader.h"

@implementation LOGIN

+ (BOOL)isLogin {
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:IS_LOGIN] isEqualToString:IS_LOGIN_YES]) {
        return YES;
    }
    return NO;
}

@end
