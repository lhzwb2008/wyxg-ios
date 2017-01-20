//
//  HomeRecommandDelegate.h
//  CreateSongs
//
//  Created by 爱写歌 on 16/7/13.
//  Copyright © 2016年 AXG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ActivityModel.h"
@class HotTableViewCell;
@class RecommandCollectionViewCell;
@class PersonSoundCollectionViewCell;
@class TalentTableViewCell;

typedef void(^RankBtnBlock)();

typedef void(^HotSongSelectBlock)(HotTableViewCell *cell);

typedef void(^RecommandSelectBlock)(RecommandCollectionViewCell *cell);

typedef void(^PersonSoundBlock)(PersonSoundCollectionViewCell *cell);

//typedef void(^ActivityBlock)(ActivityModel *model);

typedef void(^TalentBlock)(TalentTableViewCell *cell);

typedef void(^DetailBlock)(NSInteger index);

typedef void(^SongListDelegateBlock)(NSInteger index);

@interface HomeRecommandDelegate : NSObject<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSArray *hotDataSource;

@property (nonatomic, strong) NSArray *recommandDataSource;

@property (nonatomic, strong) NSArray *talentDataSource;

@property (nonatomic, strong) NSArray *personSoundDataSource;

@property (nonatomic, strong) NSArray *songListDataSource;

@property (nonatomic, copy) NSString *hotIdentifier;

@property (nonatomic, copy) NSString *recommandIdentifier;

@property (nonatomic, copy) NSString *talentIdentifier;

@property (nonatomic, copy) NSString *personSoundIdentifier;

@property (nonatomic, copy) NSString *activityIdentifier;

@property (nonatomic, strong) UIImage *activityImage;

@property (nonatomic, strong) ActivityModel *model;

@property (nonatomic, copy) RankBtnBlock rankBtnBlock;

@property (nonatomic, copy) HotSongSelectBlock hotSongSelectBlock;

@property (nonatomic, copy) RecommandSelectBlock recommandSelectBlock;

@property (nonatomic, copy) PersonSoundBlock personSoundBlock;

//@property (nonatomic, copy) ActivityBlock activityBlock;

@property (nonatomic, copy) TalentBlock talentBlock;

@property (nonatomic, copy) DetailBlock detailBlock;

@property (nonatomic, copy) SongListDelegateBlock songListDelegateBlock;

@end
