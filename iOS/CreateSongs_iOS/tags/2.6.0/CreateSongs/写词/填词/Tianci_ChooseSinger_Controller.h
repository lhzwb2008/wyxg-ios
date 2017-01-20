//
//  Tianci_ChooseSinger_Controller.h
//  CreateSongs
//
//  Created by axg on 16/9/28.
//  Copyright © 2016年 AXG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface Tianci_ChooseSinger_Controller : BaseViewController

/*
 #if XUANQU_FROME_NET
 xqc.zouyinUrl = @{@"title":self.tianciName,
 @"content":content,
 @"id":self.itemModel.id,
 @"singer":self.itemModel.singer,
 };

 xqc.lyricDataSource = self.finalLyricArray;
 xqc.isFirstPlay = YES;
 xqc.isFromPlayView = NO;
 xqc.isFromTianciPage = YES;
 xqc.isFirstGetZouyinMp3 = YES;
 xqc.titleStr = self.tianciName;
 xqc.songName = xqc.titleStr;
 xqc.requestHeadName = self.requestHeadName;
 xqc.zouyin_banzouUrl = self.itemModel.acc_mp3;
 xqc.requestSongName = self.requestSongName;
 
 */

@property (nonatomic, strong) NSDictionary *zouyinUrl;
@property (nonatomic, strong) NSArray *lyricDataSource;
@property (nonatomic, assign) BOOL isFirstPlay;
@property (nonatomic, assign) BOOL isFromPlayView;
@property (nonatomic, assign) BOOL isFromTianciPage;
@property (nonatomic, assign) BOOL isFirstGetZouyinMp3;
@property (nonatomic, copy) NSString *titleStr;
@property (nonatomic, copy) NSString *songName;
@property (nonatomic, copy) NSString *requestHeadName;
@property (nonatomic, copy) NSString *zouyin_banzouUrl;
@property (nonatomic, copy) NSString *requestSongName;
@end
