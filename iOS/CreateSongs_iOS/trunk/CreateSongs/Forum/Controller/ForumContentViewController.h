//
//  ForumContentViewController.h
//  CreateSongs
//
//  Created by 爱写歌 on 16/7/6.
//  Copyright © 2016年 AXG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "ForumTableViewCell.h"

@interface ForumContentViewController : BaseViewController

@property (nonatomic, assign) BOOL hasPic;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *content;

@property (nonatomic, strong) UIImage *headImage;

@property (nonatomic, strong) UIImage *themeImage;

@property (nonatomic, copy) NSString *contentId;

@property (nonatomic, assign) NSInteger replyCount;

@property (nonatomic, copy) NSString *createTime;

@property (nonatomic, copy) NSString *gender;

@property (nonatomic, copy) NSString *userId;

@property (nonatomic, assign) ContentType contentType;

@property (nonatomic, copy) NSString *code;

@property (nonatomic, copy) NSString *songTitle;

@property (nonatomic, copy) NSString *zuoci;

@property (nonatomic, copy) NSString *zuoqu;

@property (nonatomic, copy) NSString *yanchang;

@property (nonatomic, strong) UIImage *songImage;

@end
