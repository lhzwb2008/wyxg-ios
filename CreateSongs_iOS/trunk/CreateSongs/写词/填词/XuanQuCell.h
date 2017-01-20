//
//  XuanQuCell.h
//  CreateSongs
//
//  Created by axg on 16/8/2.
//  Copyright © 2016年 AXG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XuanquTempModel.h"

typedef void(^BeginPlayDemo)(NSString *midiUrl, NSInteger index);

@interface XuanQuCell : UITableViewCell

@property (nonatomic, assign) NSInteger index;

@property (nonatomic, strong) XuanquItemsModel *xuanQuModel;

@property (nonatomic, copy) BeginPlayDemo beginPlayDemo;

@property (nonatomic, strong) UIButton *rightBtn;

@property (nonatomic, strong) UIImageView *gifImage;

@property (nonatomic, assign) BOOL isPlay;

@property (nonatomic, strong) UILabel *titleLabel;

//+ (instancetype)customXuanQuCellWithTableView:(UITableView *)tableView;

- (void)startAnimation;

- (void)stopAnimation;

@end
