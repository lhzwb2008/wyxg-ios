//
//  ConversationModel.h
//  CreateSongs
//
//  Created by 爱写歌 on 16/8/31.
//  Copyright © 2016年 AXG. All rights reserved.
//

#import "JSONModel.h"

@interface ConversationModel : JSONModel

@property (nonatomic, copy) NSString *unreadCount;

@property (nonatomic, copy) NSString *imgUrl;

@property (nonatomic, copy) NSString *nickName;

@property (nonatomic, copy) NSString *content;

@property (nonatomic, copy) NSString *timetamp;

@property (nonatomic, copy) NSString *conversationID;

@end
