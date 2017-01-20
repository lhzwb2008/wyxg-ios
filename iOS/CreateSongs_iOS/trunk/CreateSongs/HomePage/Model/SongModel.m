//
//  SongModel.m
//  CreateSongs
//
//  Created by 爱写歌 on 16/7/14.
//  Copyright © 2016年 AXG. All rights reserved.
//

#import "SongModel.h"

@implementation SongModel

+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"id":@"dataId", @"public":@"isPublic"}];
}

+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    return YES;
}

@end
