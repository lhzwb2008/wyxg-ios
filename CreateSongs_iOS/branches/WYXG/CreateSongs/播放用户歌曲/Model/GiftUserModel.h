//
//  GiftUserModel.h
//  CreateSongs
//
//  Created by 爱写歌 on 16/8/26.
//  Copyright © 2016年 AXG. All rights reserved.
//

#import "JSONModel.h"

@interface GiftUserModel : JSONModel

@property (nonatomic, copy) NSString *user_id;

@property (nonatomic, copy) NSString *phone;

@property (nonatomic, copy) NSString *user_name;

@property (nonatomic, copy) NSString *giftNumber;

@property (nonatomic, copy) NSString *gift_type;

@end
