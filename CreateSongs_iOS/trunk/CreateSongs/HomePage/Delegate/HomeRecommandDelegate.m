//
//  HomeRecommandDelegate.m
//  CreateSongs
//
//  Created by 爱写歌 on 16/7/13.
//  Copyright © 2016年 AXG. All rights reserved.
//

#import "HomeRecommandDelegate.h"
#import "AXGHeader.h"
#import "HotTableViewCell.h"
#import "RecommandTableViewCell.h"
#import "ActivityTableViewCell.h"
#import "TalentTableViewCell.h"
#import "PersonSoundTableViewCell.h"
#import "PlayUserSongViewController.h"
#import "PersonSoundCollectionViewCell.h"
#import "HomeButton.h"
#import "SongListTableViewCell.h"

@implementation HomeRecommandDelegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        HotTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:_hotIdentifier];
        if (self.hotDataSource.count > indexPath.row) {
            cell.songModel = self.hotDataSource[indexPath.row];
        }
        return cell;
    } else if (indexPath.section == 1) {
        RecommandTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:_recommandIdentifier];
        if (self.recommandDataSource.count > indexPath.row) {
            cell.dataSource = self.recommandDataSource;
        }
        
        WEAK_SELF;
        cell.selectItemBlock = ^ (NSInteger index, RecommandCollectionViewCell *cell) {
            STRONG_SELF;
            if (self.recommandSelectBlock) {
                self.recommandSelectBlock(cell);
            }
        };
        
        return cell;
    } else if (indexPath.section == 2) {
        
        PersonSoundTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:_personSoundIdentifier];
        
        if (_personSoundDataSource) {
            cell.dataSource = _personSoundDataSource;
        }
        
        WEAK_SELF;
        cell.personSoundSelectBlock = ^ (PersonSoundCollectionViewCell *cell) {
            STRONG_SELF;
            if (self.personSoundBlock) {
                self.personSoundBlock(cell);
            }
        };
        
        return cell;
        
    } else if (indexPath.section == 3) {
        
        SongListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:_activityIdentifier];
        
        cell.dataSource = self.songListDataSource;
        
        WEAK_SELF;
        cell.songlistBlock = ^ (NSInteger index) {
            STRONG_SELF;
            if (self.songListDelegateBlock) {
                self.songListDelegateBlock(index);
            }
        };
        
//        [cell.firstButton setBackgroundImage:[UIImage imageNamed:@"另类吐槽"] forState:UIControlStateNormal];
//        [cell.secondButton setBackgroundImage:[UIImage imageNamed:@"另类吐槽"] forState:UIControlStateNormal];
//        [cell.thirdButton setBackgroundImage:[UIImage imageNamed:@"另类吐槽"] forState:UIControlStateNormal];
        
//        cell.firstImage.backgroundColor = [UIColor redColor];
//        cell.secondImage.backgroundColor = [UIColor redColor];
//        cell.thirdImage.backgroundColor = [UIColor redColor];
        
        return cell;
        
    } else if (indexPath.section == 4) {
        TalentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:_talentIdentifier];
        
        if (self.talentDataSource.count > indexPath.row) {
            cell.model = self.talentDataSource[indexPath.row];
        }
        return cell;
    }
    
    return nil;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if (section == 0) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 130 * WIDTH_NIT)];
        view.backgroundColor = HexStringColor(@"#eeeeee");
        
        UIView *blockView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 85 * WIDTH_NIT)];
        [view addSubview:blockView1];
        blockView1.backgroundColor = [UIColor whiteColor];
        
        UIImageView *classicImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 15 * WIDTH_NIT, 40 * WIDTH_NIT, 40 * WIDTH_NIT)];
        classicImage.center = CGPointMake(blockView1.width / 2, classicImage.centerY);
        [blockView1 addSubview:classicImage];
        classicImage.layer.cornerRadius = classicImage.width / 2;
        classicImage.layer.masksToBounds = YES;
//        classicImage.image = [UIImage imageNamed:@"经典"];
        
        UILabel *classicLabel = [[UILabel alloc] initWithFrame:CGRectMake(classicImage.left, classicImage.bottom, classicImage.width, 30 * WIDTH_NIT)];
        [blockView1 addSubview:classicLabel];
//        classicLabel.text = @"经典";
        classicLabel.textColor = HexStringColor(@"#535353");
        classicLabel.font = ZHONGDENG_FONT(12);
        classicLabel.textAlignment = NSTextAlignmentCenter;
        
        HomeButton *classicButton = [HomeButton buttonWithType:UIButtonTypeCustom];
        [blockView1 addSubview:classicButton];
        classicButton.backgroundColor = [UIColor clearColor];
        classicButton.frame = CGRectMake(classicImage.left, 0, classicImage.width, blockView1.height);
        classicButton.tag = 105;
        [classicButton setImage:[UIImage imageNamed:@"活动"] forState:UIControlStateNormal];
        [classicButton setTitle:@"活动" forState:UIControlStateNormal];
        [classicButton setTitleColor:HexStringColor(@"#535353") forState:UIControlStateNormal];
        [classicButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        
        UIImageView *rankImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, classicImage.width, classicImage.height)];
        rankImage.center = CGPointMake(classicImage.centerX - 120.5 * WIDTH_NIT, classicImage.centerY);
        [blockView1 addSubview:rankImage];
//        rankImage.image = [UIImage imageNamed:@"榜单"];
        
        UILabel *rankLabel = [[UILabel alloc] initWithFrame:CGRectMake(rankImage.left, rankImage.bottom, rankImage.width, 30 * WIDTH_NIT)];
        [blockView1 addSubview:rankLabel];
//        rankLabel.text = @"榜单";
        rankLabel.textColor = HexStringColor(@"#535353");
        rankLabel.font = classicLabel.font;
        rankLabel.textAlignment = NSTextAlignmentCenter;
        
        HomeButton *rankButton = [HomeButton buttonWithType:UIButtonTypeCustom];
        [blockView1 addSubview:rankButton];
        rankButton.backgroundColor = [UIColor clearColor];
        [rankButton setTitle:@"榜单" forState:UIControlStateNormal];
        [rankButton setTitleColor:HexStringColor(@"#535353") forState:UIControlStateNormal];
        [rankButton setImage:[UIImage imageNamed:@"榜单"] forState:UIControlStateNormal];
        rankButton.frame = CGRectMake(rankImage.left, 0, rankImage.width, blockView1.height);
        [rankButton addTarget: self action:@selector(rankBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        UIImageView *activityImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, classicImage.width, classicImage.height)];
        activityImage.center = CGPointMake(classicImage.centerX + 120.5 * WIDTH_NIT, classicImage.centerY);
        [blockView1 addSubview:activityImage];
//        activityImage.image = [UIImage imageNamed:@"活动"];
        
        UILabel *activityLabel = [[UILabel alloc] initWithFrame:CGRectMake(activityImage.left, activityImage.bottom, activityImage.width, 30 * WIDTH_NIT)];
        [blockView1 addSubview:activityLabel];
//        activityLabel.text = @"活动";
        activityLabel.textColor = HexStringColor(@"#535353");
        activityLabel.font = classicLabel.font;
        activityLabel.textAlignment = NSTextAlignmentCenter;
        
        HomeButton *activityButton = [HomeButton buttonWithType:UIButtonTypeCustom];
        [blockView1 addSubview:activityButton];
        [activityButton setImage:[UIImage imageNamed:@"乐谈"] forState:UIControlStateNormal];
        [activityButton setTitle:@"乐谈" forState:UIControlStateNormal];
        [activityButton setTitleColor:HexStringColor(@"#535353") forState:UIControlStateNormal];
        activityButton.backgroundColor = [UIColor clearColor];
        activityButton.frame = CGRectMake(activityImage.left, 0, activityImage.width, blockView1.height);
        
        activityButton.tag = 100;
        [activityButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        
        UILabel *hotLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, blockView1.bottom + 20 * WIDTH_NIT, SCREEN_W, 25 * WIDTH_NIT)];
        [view addSubview:hotLabel];
        hotLabel.textAlignment = NSTextAlignmentCenter;
        hotLabel.textColor = HexStringColor(@"#535353");
        //        hotLabel.font = [UIFont systemFontOfSize:15];
        hotLabel.text = @"热门歌曲";
        [hotLabel setFont:TECU_FONT(15)];
        
        UIImageView *moreImage = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_W / 2 + 46 * WIDTH_NIT, 0, 15 * WIDTH_NIT, 15 * WIDTH_NIT)];
        moreImage.center = CGPointMake(moreImage.centerX, hotLabel.centerY);
        [view addSubview:moreImage];
        moreImage.image = [UIImage imageNamed:@"标题更多"];
        
        UIButton *hotButton = [UIButton new];
        [view addSubview:hotButton];
        hotButton.backgroundColor = [UIColor clearColor];
        hotButton.frame = CGRectMake(hotLabel.left - 5 * WIDTH_NIT, hotLabel.top, moreImage.right - hotLabel.left + 10 * WIDTH_NIT, hotLabel.height);
        
        hotButton.tag = 101;
        [hotButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        
        return view;
        
    } else if (section == 1) {
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 70 * WIDTH_NIT)];
        
        UILabel *recommandLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 5 * WIDTH_NIT, SCREEN_W, 65 * WIDTH_NIT)];
        [view addSubview:recommandLabel];
        recommandLabel.textColor = HexStringColor(@"#535353");
        recommandLabel.text = @"最美人声";
        recommandLabel.textAlignment = NSTextAlignmentCenter;
        [recommandLabel setFont:TECU_FONT(15)];
        
        UIImageView *moreImage = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_W / 2 + 46 * WIDTH_NIT, 0, 15 * WIDTH_NIT, 15 * WIDTH_NIT)];
        moreImage.center = CGPointMake(moreImage.centerX, recommandLabel.centerY);
        [view addSubview:moreImage];
        moreImage.image = [UIImage imageNamed:@"标题更多"];
        
        UIButton *hotButton = [UIButton new];
        [view addSubview:hotButton];
        hotButton.backgroundColor = [UIColor clearColor];
        hotButton.frame = CGRectMake(recommandLabel.left - 5 * WIDTH_NIT, recommandLabel.top, moreImage.right - recommandLabel.left + 10 * WIDTH_NIT, recommandLabel.height);
        hotButton.tag = 103;
        [hotButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        
        view.backgroundColor = [UIColor whiteColor];
        
        return view;
        
    } else if (section == 2) {
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 60 * WIDTH_NIT)];
        
        UILabel *talentLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 15 * WIDTH_NIT, SCREEN_W, 45 * WIDTH_NIT)];
        [view addSubview:talentLabel];
        talentLabel.textColor = HexStringColor(@"#535353");
        talentLabel.text = @"创作达人";
        talentLabel.textAlignment = NSTextAlignmentCenter;
        [talentLabel setFont:TECU_FONT(15)];
        
        UIImageView *moreImage = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_W / 2 + 46 * WIDTH_NIT, 0, 15 * WIDTH_NIT, 15 * WIDTH_NIT)];
        moreImage.center = CGPointMake(moreImage.centerX, talentLabel.centerY);
        [view addSubview:moreImage];
        moreImage.image = [UIImage imageNamed:@"标题更多"];
        
        UIButton *talentButton = [UIButton new];
        [view addSubview:talentButton];
        talentButton.backgroundColor = [UIColor clearColor];
        talentButton.frame = CGRectMake(talentLabel.left - 5 * WIDTH_NIT, talentLabel.top, moreImage.right - talentLabel.left + 10 * WIDTH_NIT, talentLabel.height);
        
        talentButton.tag = 102;
        [talentButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        
        return view;
        
    } else if (section == 3) {
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 70 * WIDTH_NIT)];
        
        UILabel *recommandLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 5 * WIDTH_NIT, SCREEN_W, 65 * WIDTH_NIT)];
        [view addSubview:recommandLabel];
        recommandLabel.textColor = HexStringColor(@"#535353");
        recommandLabel.text = @"推荐歌单";
        recommandLabel.textAlignment = NSTextAlignmentCenter;
        [recommandLabel setFont:TECU_FONT(15)];
        
        UIImageView *moreImage = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_W / 2 + 46 * WIDTH_NIT, 0, 15 * WIDTH_NIT, 15 * WIDTH_NIT)];
        moreImage.center = CGPointMake(moreImage.centerX, recommandLabel.centerY);
        [view addSubview:moreImage];
        moreImage.image = [UIImage imageNamed:@"标题更多"];
        
        UIButton *hotButton = [UIButton new];
        [view addSubview:hotButton];
        hotButton.backgroundColor = [UIColor clearColor];
        hotButton.frame = CGRectMake(recommandLabel.left - 5 * WIDTH_NIT, recommandLabel.top, moreImage.right - recommandLabel.left + 10 * WIDTH_NIT, recommandLabel.height);
//        hotButton.tag = 103;
//        [hotButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        
        view.backgroundColor = [UIColor whiteColor];
        
        return view;
        
    } else if (section == 4) {
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 65 * WIDTH_NIT)];
        
        UILabel *talentLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 65 * WIDTH_NIT)];
        [view addSubview:talentLabel];
        talentLabel.textColor = HexStringColor(@"#535353");
        talentLabel.text = @"优质歌词";
        talentLabel.textAlignment = NSTextAlignmentCenter;
        [talentLabel setFont:TECU_FONT(15)];
        
        UIImageView *moreImage = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_W / 2 + 46 * WIDTH_NIT, 0, 15 * WIDTH_NIT, 15 * WIDTH_NIT)];
        moreImage.center = CGPointMake(moreImage.centerX, talentLabel.centerY);
        [view addSubview:moreImage];
        moreImage.image = [UIImage imageNamed:@"标题更多"];
        
        UIButton *talentButton = [UIButton new];
        [view addSubview:talentButton];
        talentButton.backgroundColor = [UIColor clearColor];
        talentButton.frame = CGRectMake(talentLabel.left - 5 * WIDTH_NIT, talentLabel.top, moreImage.right - talentLabel.left + 10 * WIDTH_NIT, talentLabel.height);
        
        talentButton.tag = 104;
        [talentButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        
        return view;
    }
    
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    if (section == 0) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, 12.5 * WIDTH_NIT)];
        view.backgroundColor = HexStringColor(@"#eeeeee");
        return view;
    }
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 3;
    } else if (section == 1) {
        return 1;
    } else if (section == 2) {
        return 1;
    } else if (section == 3) {
        return 1;
    }else if (section == 4) {
        return 3;
    }
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 65 * WIDTH_NIT;
    } else if (indexPath.section == 1) {
        return 250.5 * WIDTH_NIT;
    } else if (indexPath.section == 2) {
        return 182.5 * WIDTH_NIT;
    }else if (indexPath.section == 3) {
        return 252 * WIDTH_NIT;
    } else if (indexPath.section == 4) {
        return 127.5 * WIDTH_NIT;
    }
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 130 * WIDTH_NIT;
    } else if (section == 1) {
        return 70 * WIDTH_NIT;
    } else if (section == 2) {
        return 60 * WIDTH_NIT;
    } else if (section == 3) {
        return 70 * WIDTH_NIT;
    }else if (section == 4) {
        return 65 * WIDTH_NIT;
    }
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 0) {
        return 12.5 * WIDTH_NIT;
    }
    return CGFLOAT_MIN;
}

- (void)rankBtnClick:(UIButton *)btn {
    if (self.rankBtnBlock) {
        self.rankBtnBlock();
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    tableView.allowsSelection = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        tableView.allowsSelection = YES;
    });
    
    if (indexPath.section == 0) {
        
        HotTableViewCell *cell = (HotTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
        
        if (self.hotSongSelectBlock) {
            self.hotSongSelectBlock(cell);
        }
    } else if (indexPath.section == 3) {
//        if (self.activityBlock) {
//            self.activityBlock(self.model);
//        }
    } else if (indexPath.section == 4) {
        
        TalentTableViewCell *cell = (TalentTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
        
        if (self.talentBlock) {
            self.talentBlock(cell);
        }
    }
    
}

// 按钮方法
- (void)buttonAction:(UIButton *)sender {
    
    if (sender.tag != 102) {
        if (self.detailBlock) {
            self.detailBlock(sender.tag - 100);
        }
    }
    
}

@end
