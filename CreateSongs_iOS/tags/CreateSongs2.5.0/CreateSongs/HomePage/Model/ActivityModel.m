//
//  ActivityModel.m
//  CreateSongs
//
//  Created by 爱写歌 on 16/7/5.
//  Copyright © 2016年 AXG. All rights reserved.
//

#import "ActivityModel.h"

@implementation ActivityModel

+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    return YES;
}
+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"id":@"dataId"}];
}

@end
