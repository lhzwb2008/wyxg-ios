//
//  PlayShareObjects.h
//  CreateSongs
//
//  Created by axg on 16/9/2.
//  Copyright © 2016年 AXG. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PlayShareObjects : NSObject

@property (nonatomic, copy) NSDictionary *zouyinUrl;
@property (nonatomic, assign) BOOL isFirstPlay;
@property (nonatomic, assign) BOOL isFromPlayView;
@property (nonatomic, assign) BOOL isFromTianciPage;
@property (nonatomic, assign) BOOL isFirstGetZouyinMp3;
@property (nonatomic, copy) NSString *songName;
@property (nonatomic, copy) NSString *requestHeadName;
@property (nonatomic, copy) NSString *zouyin_banzouUrl;

@property (nonatomic, copy) NSString *titleStr;
@property (nonatomic, strong) NSArray *lyricDataSource;

+ (instancetype)sharedPlayShareObjects;

@end
