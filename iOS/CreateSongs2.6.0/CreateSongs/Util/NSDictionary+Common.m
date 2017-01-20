//
//  NSDictionary+Common.m
//  CreateSongs
//
//  Created by axg on 16/8/4.
//  Copyright © 2016年 AXG. All rights reserved.
//

#import "NSDictionary+Common.h"

@implementation NSDictionary (Common)

- (BOOL)haveKey:(NSString *)key {
    if ([[self allKeys] containsObject:key]) {
        return YES;
    }
    return NO;
}

@end
