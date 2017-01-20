//
//  HomeLatestDelegate.h
//  CreateSongs
//
//  Created by 爱写歌 on 16/7/15.
//  Copyright © 2016年 AXG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class LatestTableViewCell;

typedef enum : NSUInteger {
    allType,
    changType,
    gaiType,
} LatestType;

typedef void(^LatestSelectBlock)(LatestTableViewCell *cell);

@interface HomeLatestDelegate : NSObject<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, copy) NSString *identifier;

@property (nonatomic, strong) NSArray *dataSource;

@property (nonatomic, assign) LatestType latestType;

@property (nonatomic, copy) LatestSelectBlock latestSelectBlock;

@end
