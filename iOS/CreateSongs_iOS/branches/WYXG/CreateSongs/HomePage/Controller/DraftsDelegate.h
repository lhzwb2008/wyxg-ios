//
//  DraftsDelegate.h
//  CreateSongs
//
//  Created by 爱写歌 on 16/8/3.
//  Copyright © 2016年 AXG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    XianciType,
    XianquType,
    RECODERTYPE,
} DB_FROM_TYPE;

@class DraftsTableViewCell;

typedef void(^DeleteBlock)(NSDictionary *dic);

typedef void(^SelectBlock)(DraftsTableViewCell *cell);

@interface DraftsDelegate : NSObject<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSArray *dataSource;

@property (nonatomic, copy) NSString *identifier;

@property (nonatomic, copy) SelectBlock seletBlock;

@property (nonatomic, copy) DeleteBlock deleteBlock;

@property (nonatomic, assign) DB_FROM_TYPE dbFromType;

@end
