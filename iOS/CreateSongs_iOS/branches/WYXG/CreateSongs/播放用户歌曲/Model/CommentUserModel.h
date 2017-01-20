//
//  CommentUserModel.h
//  CreateSongs
//
//  Created by axg on 16/5/3.
//  Copyright © 2016年 AXG. All rights reserved.
//

#import "JSONModel.h"

@protocol  UserCommentsModel <NSObject>
@end
@interface UserCommentsModel : JSONModel

@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *user_id;
@property (nonatomic, copy) NSString *song_id;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *create_time;
@property (nonatomic, copy) NSString *parent;
@property (nonatomic, copy) NSString *up_count;
@property (nonatomic, copy) NSString *phone;
@property (nonatomic, copy) NSString *user_name;


@end

@interface CommentUserModel : JSONModel

@property (nonatomic, copy) NSString *status;

@property (nonatomic, strong) NSMutableArray<UserCommentsModel>* comments;

@end
