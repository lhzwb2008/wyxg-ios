//
//  ForumCommentTableViewCell.h
//  CreateSongs
//
//  Created by 爱写歌 on 16/7/7.
//  Copyright © 2016年 AXG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ForumCommentFrameModel.h"

@interface ForumCommentTableViewCell : UITableViewCell

@property (nonatomic, strong) UIImageView *headImage;

@property (nonatomic, strong) UILabel *nameLabel;

@property (nonatomic, strong) UILabel *nameLabel2;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, strong) UILabel *content;

@property (nonatomic, strong) UILabel *timeLabel;

@property (nonatomic, strong) UIView *lineView;

@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) UIView *thumbView;

@property (nonatomic, strong) UIImageView *genderImage;

@property (nonatomic, strong) ForumCommentFrameModel *model;

@end
