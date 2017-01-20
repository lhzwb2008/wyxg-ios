//
//  SelectSongViewController.h
//  CreateSongs
//
//  Created by 爱写歌 on 16/9/7.
//  Copyright © 2016年 AXG. All rights reserved.
//

#import "BaseViewController.h"
#import "SongModel.h"

typedef void(^SongSelectBlock)(SongModel *model);

@interface SelectSongViewController : BaseViewController

@property (nonatomic, copy) SongSelectBlock songSelectBlock;

@end
