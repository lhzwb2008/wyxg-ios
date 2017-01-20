//
//  ForumCommentsModel.h
//  CreateSongs
//
//  Created by 爱写歌 on 16/7/12.
//  Copyright © 2016年 AXG. All rights reserved.
//

#import "JSONModel.h"

@interface ForumCommentsModel : JSONModel

@property (nonatomic, copy) NSString *dataId;

@property (nonatomic, copy) NSString *user_id;

@property (nonatomic, copy) NSString *post_id;

@property (nonatomic, copy) NSString *content;

@property (nonatomic, copy) NSString *create_time;

@property (nonatomic, copy) NSString *modify_time;

@property (nonatomic, copy) NSString *parent;

@property (nonatomic, copy) NSString *user_name;

@property (nonatomic, copy) NSString *phone;

@property (nonatomic, copy) NSString *gender;

@end
