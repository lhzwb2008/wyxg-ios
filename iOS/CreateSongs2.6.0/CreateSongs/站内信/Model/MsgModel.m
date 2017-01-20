//
//  MsgModel.m
//  CreateSongs
//
//  Created by 爱写歌 on 16/5/30.
//  Copyright © 2016年 AXG. All rights reserved.
//

#import "MsgModel.h"

@implementation MsgModel

+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    return YES;
}
+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"id":@"nId"}];
}

@end
