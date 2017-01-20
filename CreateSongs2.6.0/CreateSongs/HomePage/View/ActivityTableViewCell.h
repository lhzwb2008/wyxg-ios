//
//  ActivityTableViewCell.h
//  CreateSongs
//
//  Created by 爱写歌 on 16/7/14.
//  Copyright © 2016年 AXG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ActivityModel.h"

@interface ActivityTableViewCell : UITableViewCell

@property (nonatomic, strong) UIView *lineView;

@property (nonatomic, strong) UIImageView *overImage;

@property (nonatomic, strong) UIImageView *activityImage;

@property (nonatomic, strong) ActivityModel *model;

@end
