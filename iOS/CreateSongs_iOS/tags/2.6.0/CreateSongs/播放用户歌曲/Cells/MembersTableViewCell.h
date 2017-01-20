//
//  MembersTableViewCell.h
//  CreateSongs
//
//  Created by 爱写歌 on 16/9/6.
//  Copyright © 2016年 AXG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserModel.h"

typedef void(^RefreshFocusBlock)();

typedef void(^MemberToUserCenterBlock)(NSString *userId);

@interface MembersTableViewCell : UITableViewCell

@property (nonatomic, strong) UIImageView *firstImage;

@property (nonatomic, strong) UIImageView *secondImage;

@property (nonatomic, strong) UIImageView *thirdImage;

@property (nonatomic, strong) UILabel *firstLabel;

@property (nonatomic, strong) UILabel *secondLabel;

@property (nonatomic, strong) UILabel *thirdLabel;

@property (nonatomic, strong) UILabel *firstNameLabel;

@property (nonatomic, strong) UILabel *secondNameLabel;

@property (nonatomic, strong) UILabel *thirdNameLabel;

@property (nonatomic, strong) UIButton *firstButton;

@property (nonatomic, strong) UIButton *secondButton;

@property (nonatomic, strong) UIButton *thirdButton;

//@property (nonatomic, strong) UIImageView *firstPlus;
//
//@property (nonatomic, strong) UIImageView *secondPlus;

@property (nonatomic, copy) NSString *firstId;

@property (nonatomic, copy) NSString *secondId;

@property (nonatomic, copy) NSString *thirdId;

@property (nonatomic, strong) UserModel *model1;

@property (nonatomic, strong) UserModel *model2;

@property (nonatomic, strong) UserModel *model3;

@property (nonatomic, strong) UIButton *headButton1;

@property (nonatomic, strong) UIButton *headButton2;

@property (nonatomic, strong) UIButton *headButton3;

@property (nonatomic, strong) NSArray *memberArray;

@property (nonatomic, copy) RefreshFocusBlock refreshFocusBlock;

@property (nonatomic, copy) MemberToUserCenterBlock memberToUserCenterBlock;

@property (nonatomic, assign) BOOL isFocus1;

@property (nonatomic, assign) BOOL isFocus2;

@property (nonatomic, assign) BOOL isFocus3;

@property (nonatomic, strong) UIView *vertiLine1;

@property (nonatomic, strong) UIView *vertiLine2;

@property (nonatomic, strong) UIView *horLine1;

@property (nonatomic, strong) UIView *horLine2;

@end
