//
//  MsgModel.h
//  CreateSongs
//
//  Created by 爱写歌 on 16/5/30.
//  Copyright © 2016年 AXG. All rights reserved.
//

#import "JSONModel.h"

@interface MsgModel : JSONModel

@property (nonatomic, copy) NSString *nId;

@property (nonatomic, copy) NSString *type;

@property (nonatomic, copy) NSString *receive_id;

@property (nonatomic, copy) NSString *send_id;

@property (nonatomic, copy) NSString *song_id;

@property (nonatomic, copy) NSString *content;

@property (nonatomic, copy) NSString *is_read;

@property (nonatomic, copy) NSString *create_time;

@end
