//
//  OtherPersonCenterController.h
//  CreateSongs
//
//  Created by axg on 16/7/18.
//  Copyright © 2016年 AXG. All rights reserved.
//

#import "PersonCenterController.h"

@interface OtherPersonCenterController : PersonCenterController



- (instancetype)initWIthUserId:(NSString *)userId;

- (void)changeUserId:(NSString *)userId;

@end
