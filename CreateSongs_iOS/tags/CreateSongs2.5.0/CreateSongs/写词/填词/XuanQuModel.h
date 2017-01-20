//
//  XuanQuModel.h
//  CreateSongs
//
//  Created by axg on 16/8/2.
//  Copyright © 2016年 AXG. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    HappyType,
    HuaiJiuType,
    MinZuType,
    ZhiYuType,
} XuanQuType;

@interface XuanQuModel : NSObject


@property (nonatomic, copy) NSString *songTypeName;

@property (nonatomic, strong) NSData *midiData;



@end
