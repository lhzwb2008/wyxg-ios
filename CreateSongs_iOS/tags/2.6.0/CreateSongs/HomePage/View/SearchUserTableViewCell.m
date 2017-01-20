//
//  SearchUserTableViewCell.m
//  CreateSongs
//
//  Created by 爱写歌 on 16/8/24.
//  Copyright © 2016年 AXG. All rights reserved.
//

#import "SearchUserTableViewCell.h"
#import "UserModel.h"
#import "AXGHeader.h"
#import "XWAFNetworkTool.h"
#import "AXGTools.h"

@implementation SearchUserTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)initCell {
    [super initCell];
    
    self.genderImage = [UIImageView new];
    [self.contentView addSubview:self.genderImage];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat width = [AXGTools getTextWidth:self.mainTitle.text font:self.mainTitle.font];
    self.genderImage.frame = CGRectMake(self.mainTitle.left + width + 7 * WIDTH_NIT, 0, 12 * WIDTH_NIT, 12 * WIDTH_NIT);
    self.genderImage.center = CGPointMake(self.genderImage.centerX, self.mainTitle.centerY);
    
}

- (void)setUserModel:(UserModel *)userModel {
    _userModel = userModel;
    
    NSString *url = [NSString stringWithFormat:GET_USER_HEAD, [XWAFNetworkTool md5HexDigest:userModel.phone]];
    [self.themeImage sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"头像"]];
    self.mainTitle.text = userModel.name;
    if (userModel.signature.length != 0) {
        self.subTitle.text = userModel.signature;
    } else {
        self.subTitle.text = EMPTY_SIGNATRUE;
    }
    if ([userModel.gender isEqualToString:@"1"]) {
        self.genderImage.image = [UIImage imageNamed:@"男icon"];
    } else {
        self.genderImage.image = [UIImage imageNamed:@"女icon"];
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
