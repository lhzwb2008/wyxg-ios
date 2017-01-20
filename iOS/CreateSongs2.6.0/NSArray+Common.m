//
//  NSArray+Common.m
//  CreateSongs
//
//  Created by axg on 16/7/26.
//  Copyright © 2016年 AXG. All rights reserved.
//

#import "NSArray+Common.h"

@implementation NSArray (Common)

- (NSArray *)removeSameData {
//    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithCapacity:0];
//    for (id object in self) {
//        [dic setObject:object forKey:object];
//    }
//    return [dic allKeys];
    
    NSMutableArray *MArr = [NSMutableArray new];
    
    for (unsigned i = 0; i<[self count]; i++) {
        if ([MArr containsObject:[self objectAtIndex:i]]== NO) {
            [MArr addObject:[self objectAtIndex:i]];
        }
    }
    return MArr;
}

@end
