//
//  NSObject+ModelToDictionary.h
//  CreateSongs
//
//  Created by axg on 16/8/4.
//  Copyright © 2016年 AXG. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSObject (ModelToDictionary)

/**
 *  模型转字典
 *
 *  @return 字典
 */
- (NSDictionary *)dictionaryFromModel;

/**
 *  带model的数组或字典转字典
 *
 *  @param object 带model的数组或字典转
 *
 *  @return 字典
 */
- (id)idFromObject:(nonnull id)object;

@end
