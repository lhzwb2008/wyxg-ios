//
//  HomeActivityDelegate.h
//  CreateSongs
//
//  Created by 爱写歌 on 16/8/18.
//  Copyright © 2016年 AXG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class ActivityTableViewCell;

typedef void(^ActivitySelectBlock)(ActivityTableViewCell *cell);

@interface HomeActivityDelegate : NSObject<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, copy) NSString *identifier;

@property (nonatomic, strong) NSArray *dataSource;

@property (nonatomic, copy) ActivitySelectBlock activitySelectBlock;

@end
