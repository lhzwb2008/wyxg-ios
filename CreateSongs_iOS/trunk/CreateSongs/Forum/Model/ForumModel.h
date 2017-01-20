//
//  ForumModel.h
//  CreateSongs
//
//  Created by 爱写歌 on 16/7/6.
//  Copyright © 2016年 AXG. All rights reserved.
//

#import "JSONModel.h"
#import "SongModel.h"

@interface ForumModel : JSONModel

@property (nonatomic, copy) NSString *dataId;

@property (nonatomic, copy) NSString *user_id;

@property (nonatomic, copy) NSString *content;

@property (nonatomic, copy) NSString *is_top;

@property (nonatomic, copy) NSString *img_url;

@property (nonatomic, copy) NSString *user_name;

@property (nonatomic, copy) NSString *gender;

@property (nonatomic, copy) NSString *phone;

@property (nonatomic, copy) NSString *comments_count;

@property (nonatomic, copy) NSString *create_time;

@property (nonatomic, copy) NSString *modify_time;

@property (nonatomic, copy) NSString *song_id;

@property (nonatomic, strong) SongModel *song;

@end
