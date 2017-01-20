//
//  BannerModel.m
//  CreateSongs
//
//  Created by 爱写歌 on 16/7/18.
//  Copyright © 2016年 AXG. All rights reserved.
//

#import "BannerModel.h"

@implementation BannerModel

+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    return YES;
}
+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"id":@"dataId"}];
}

@end
