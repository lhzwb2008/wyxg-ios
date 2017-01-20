//
//  GiftInfoModel.h
//  CreateSongs
//
//  Created by 爱写歌 on 16/8/26.
//  Copyright © 2016年 AXG. All rights reserved.
//

#import "JSONModel.h"

@interface GiftInfoModel : JSONModel

@property (nonatomic, copy) NSString *dataId;

@property (nonatomic, copy) NSString *gift_type;

@property (nonatomic, copy) NSString *user_id;

@property (nonatomic, copy) NSString *song_id;

@property (nonatomic, copy) NSString *money;

@property (nonatomic, copy) NSString *create_time;

@property (nonatomic, copy) NSString *user_name;

@property (nonatomic, copy) NSString *phone;

@end
