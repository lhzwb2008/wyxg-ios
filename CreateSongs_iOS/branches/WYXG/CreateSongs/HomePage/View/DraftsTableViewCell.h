//
//  DraftsTableViewCell.h
//  CreateSongs
//
//  Created by 爱写歌 on 16/7/21.
//  Copyright © 2016年 AXG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XuanQuModel.h"
#import "XuanquTempModel.h"


@interface DraftsTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UILabel *contentLabel;

@property (nonatomic, strong) UILabel *timeLabel;

@property (nonatomic, assign) NSInteger lineNumber;

@property (nonatomic, copy) NSString *saveTime;

@property (nonatomic, strong) UIView *lineView;

@property (nonatomic, strong) UIView *topLine;

@property (nonatomic, strong) UIImageView *diskImage;

@property (nonatomic, strong) NSDictionary *dataSource;

@property (nonatomic, strong) UIView *myContentView;

@property (nonatomic, strong) UIView *horiLine;

#pragma mark - 进入填词页面需要数据
@property (nonatomic, strong) NSMutableArray *tianciLyricModelArr;
@property (nonatomic, strong) XuanQuModel *xuanquModel;
@property (nonatomic, strong) NSArray *lyricFormat;
/**
 @"characLocations":
 @"requestHeadName":
 */
/**
 @"requestHeadName":self.requestHeadName,
 @"acc_mp3":self.itemModel.acc_mp3,
 @"zouyin_id":self.itemModel.id,
 @"zouyin_singer":self.itemModel.singer,
 */

@property (nonatomic, strong) NSArray *characLocations;
@property (nonatomic, copy) NSString *requestHeadName;
@property (nonatomic, copy) NSString *acc_mp3;
@property (nonatomic, copy) NSString *zouyin_id;
@property (nonatomic, copy) NSString *zouyin_singer;
@property (nonatomic, strong) XuanquItemsModel *itemModel;

/*
 vsc.lrcDataSource = self.lyricDataSource;
 vsc.shareUrl = self.shareWebUrl;
 vsc.mp3Url = self.shareMp3Url;
 vsc.songName =self.songName;
 
 vsc.code = self.changeSingerAPIName;
 vsc.banzouPath = self.finalBanzouPath;
 vsc.recoderPath = self.finalPath;
 
 */
@property (nonatomic, strong) NSArray *voice_DataSource;
@property (nonatomic, copy) NSString *voice_shareUrl;
@property (nonatomic, copy) NSString *voice_mp3Url;
@property (nonatomic, copy) NSString *voice_songName;
@property (nonatomic, copy) NSString *voice_code;
@property (nonatomic, copy) NSString *voice_banzouPath;
@property (nonatomic, copy) NSString *voice_recoderPath;

@end
