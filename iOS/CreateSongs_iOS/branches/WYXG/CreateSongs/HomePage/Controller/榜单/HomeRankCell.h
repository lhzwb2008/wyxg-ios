//
//  HomeRankCell.h
//  CreateSongs
//
//  Created by axg on 16/7/25.
//  Copyright © 2016年 AXG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomePageModel.h"


@interface HomeRankCell : UITableViewCell

@property (nonatomic, strong) HomePageUserMess *dataModel;

@property (nonatomic, assign) NSInteger index;

@property (nonatomic, strong) UIImageView *songPic;
@property (nonatomic, strong) UIImageView *sanjiaoPic;
@property (nonatomic, strong) UILabel *leftNumberLabel;
@property (nonatomic, strong) UILabel *songName;
@property (nonatomic, strong) UILabel *songCreater;
@property (nonatomic, strong) UILabel *playCount;
@property (nonatomic, strong) UIImageView *playCountRight;
@property (nonatomic, strong) UILabel *seperateLine;

@property (nonatomic, strong) UIImageView *numberTopImg;

+ (instancetype)customRankCellWithTableView:(UITableView *)tableView;

@end
