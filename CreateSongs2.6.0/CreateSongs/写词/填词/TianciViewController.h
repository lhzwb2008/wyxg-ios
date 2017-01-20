//
//  TianciViewController.h
//  CreateSongs
//
//  Created by axg on 16/8/1.
//  Copyright © 2016年 AXG. All rights reserved.
//

#import "XieciViewController.h"
#import "XuanQuModel.h"
#import "XuanquTempModel.h"

@interface TianciViewController : XieciViewController

@property (nonatomic, strong) XuanQuModel *xuanQuModel;
@property (nonatomic, strong) XuanquItemsModel *itemModel;

@property (nonatomic, strong) NSArray *lyricModelArray;
@property (nonatomic, strong) NSArray *lyricFormatArray;

@property (nonatomic, strong) NSArray *characLocationsArray;
/**
 *  key 行数  value 歌词
 */
@property (nonatomic, strong) NSMutableDictionary *lyricDic;

/**
 *  时间轴
 */
@property (nonatomic, copy) NSString *requestHeadName;

/**
 *  歌曲缩写名(读取本地曲目使用)
 */
@property (nonatomic, copy) NSString *requestSongName;

@end
