//
//  HomePageModel.m
//  CreateSongs
//
//  Created by axg on 16/4/25.
//  Copyright © 2016年 AXG. All rights reserved.
//

#import "HomePageModel.h"

@implementation HomePageUserMess

+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"id":@"dataId", @"public":@"isPublic"}];
}

+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    return YES;
}

@end

@implementation HomePageModel

+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    return YES;
}

@end
