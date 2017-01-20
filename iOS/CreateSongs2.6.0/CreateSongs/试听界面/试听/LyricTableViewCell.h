//
//  LyricTableViewCell.h
//  CreateSongs
//
//  Created by 爱写歌 on 16/3/7.
//  Copyright © 2016年 AXG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AXGHeader.h"

typedef void(^ShowTyViewBlock)(NSInteger index);

@interface LyricTableViewCell : UITableViewCell

@property (nonatomic, assign) NSInteger index;

@property (nonatomic, strong) UILabel *lyric;


@property (nonatomic, copy) ShowTyViewBlock showTyViewBlock;

@end
