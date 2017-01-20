//
//  SixinTableViewCell.h
//  CreateSongs
//
//  Created by 爱写歌 on 16/8/31.
//  Copyright © 2016年 AXG. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ConversationModel;

@interface SixinTableViewCell : UITableViewCell

@property (nonatomic, strong) UIImageView *headImage;

@property (nonatomic, strong) UILabel *nameLabel;

@property (nonatomic, strong) UILabel *contentLabel;

@property (nonatomic, strong) UILabel *timeLabel;

@property (nonatomic, strong) UILabel *numberLabel;

@property (nonatomic, strong) ConversationModel *model;

@property (nonatomic, strong) UIView *lineView;

@end
