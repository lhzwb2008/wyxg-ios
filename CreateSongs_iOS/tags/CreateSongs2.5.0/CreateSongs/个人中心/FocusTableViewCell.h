//
//  FocusTableViewCell.h
//  CreateSongs
//
//  Created by 爱写歌 on 16/5/5.
//  Copyright © 2016年 AXG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FocusButton.h"

@interface FocusTableViewCell : UITableViewCell

@property (nonatomic, strong) UIImageView *headImage;

@property (nonatomic, strong) UILabel *name;

@property (nonatomic, strong) UILabel *signature;

@property (nonatomic, strong) FocusButton *focusButton;

@property (nonatomic, copy) NSString *userId;

@property (nonatomic, assign) BOOL isFocus;

@property (nonatomic, strong) UIView *topView;

@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) UIImageView *thumbView;

@property (nonatomic, strong) UILabel *showLyricLabel;


@end
