//
//  MsgTableViewCell.h
//  CreateSongs
//
//  Created by 爱写歌 on 16/5/24.
//  Copyright © 2016年 AXG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MsgModel.h"

@interface MsgTableViewCell : UITableViewCell

@property (nonatomic, strong) UIImageView *headImage;

@property (nonatomic, strong) UILabel *nameLabel;

@property (nonatomic, strong) UILabel *contentNameLabel;

@property (nonatomic, strong) UILabel *contentLabel;

@property (nonatomic, strong) UILabel *timeLabel;

@property (nonatomic, strong) MsgModel *msgModel;

@property (nonatomic, strong) UIView *lineView;

@property (nonatomic, strong) NSAttributedString *attributedContent;

@end
