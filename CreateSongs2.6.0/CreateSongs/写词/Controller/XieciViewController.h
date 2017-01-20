//
//  XieciViewController.h
//  CreateSongs
//
//  Created by 爱写歌 on 16/7/20.
//  Copyright © 2016年 AXG. All rights reserved.
//

#import "BaseViewController.h"
#import "CreateSongs.h"
#import "KVNProgress.h"
#import "AXGMessage.h"
#import "MobClick.h"


@interface XieciViewController : BaseViewController

@property (nonatomic, strong) CreateSongs *songs;

@property (nonatomic, assign) NSInteger lineFromDrafts;

@property (nonatomic, copy) NSString *contentFromDrafts;

@property (nonatomic, copy) NSString *titleFromDrafts;

@property (nonatomic, copy) NSString *songContent;
@property (nonatomic, copy) NSString *songName;

// 获取当前时间
- (NSString *)getCurrentTime;

- (void)changeSongToEmpty;

@end
