//
//  GiftInfoModel.m
//  CreateSongs
//
//  Created by 爱写歌 on 16/8/26.
//  Copyright © 2016年 AXG. All rights reserved.
//

#import "GiftInfoModel.h"

@implementation GiftInfoModel

+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    return YES;
}
+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"id":@"dataId"}];
}

@end
