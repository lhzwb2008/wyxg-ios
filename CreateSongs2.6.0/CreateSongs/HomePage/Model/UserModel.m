//
//  UserModel.m
//  CreateSongs
//
//  Created by axg on 16/4/25.
//  Copyright © 2016年 AXG. All rights reserved.
//

#import "UserModel.h"

@implementation UserModel

+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    return YES;
}
+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"id":@"userModelId"}];
}
@end
