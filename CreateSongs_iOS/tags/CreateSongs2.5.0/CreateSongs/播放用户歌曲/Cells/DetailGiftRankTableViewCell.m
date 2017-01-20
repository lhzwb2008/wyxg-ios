//
//  DetailGiftRankTableViewCell.m
//  CreateSongs
//
//  Created by 爱写歌 on 16/8/26.
//  Copyright © 2016年 AXG. All rights reserved.
//

#import "DetailGiftRankTableViewCell.h"
#import "AXGHeader.h"
#import "AXGTools.h"
#import "XWAFNetworkTool.h"
#import "GiftUserModel.h"

@implementation DetailGiftRankTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initCell];
    }
    return self;
}

- (void)initCell {
    
    self.rankLabel = [UILabel new];
    self.rankLabel.font = JIACU_FONT(15);
    self.rankLabel.textColor = HexStringColor(@"#441D11");
    [self.contentView addSubview:self.rankLabel];
    
    self.goldImage = [UIImageView new];
    [self.contentView addSubview:self.goldImage];
    
    self.headImage = [UIImageView new];
    [self.contentView addSubview:self.headImage];
    
    self.nameLabel = [UILabel new];
    [self.contentView addSubview:self.nameLabel];
    self.nameLabel.textColor = HexStringColor(@"441D11");
    self.nameLabel.font = JIACU_FONT(15);
    
    self.flowerImage = [UIImageView new];
    self.flowerImage.image = [UIImage imageNamed:@"榜单_鲜花"];
    [self.contentView addSubview:self.flowerImage];
    
    self.numberLabel = [UILabel new];
    [self.contentView addSubview:self.numberLabel];
    self.numberLabel.textColor = HexStringColor(@"#a0a0a0");
    self.numberLabel.font = JIACU_FONT(12);
    
    self.lineView = [UIView new];
    [self.contentView addSubview:self.lineView];
    self.lineView.backgroundColor = HexStringColor(@"#eeeeee");
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.rankLabel.frame = CGRectMake(16 * WIDTH_NIT, 0, 40, self.height);
    
    CGFloat width = [AXGTools getTextWidth:@"1" font:self.rankLabel.font];
    
    self.goldImage.frame = CGRectMake(0, 11 * WIDTH_NIT, 15 * WIDTH_NIT, 14 * WIDTH_NIT);
    self.goldImage.center = CGPointMake(self.rankLabel.left + width / 2, self.goldImage.centerY);
    
    self.headImage.frame = CGRectMake(self.goldImage.centerX + 20 * WIDTH_NIT, 0, 45 * WIDTH_NIT, 45 * WIDTH_NIT);
    self.headImage.center = CGPointMake(self.headImage.centerX, self.height / 2);
    self.headImage.layer.cornerRadius = self.headImage.width / 2;
    self.headImage.layer.masksToBounds = YES;
    
    self.nameLabel.frame = CGRectMake(self.headImage.right + 10 * WIDTH_NIT, 0, 200, self.height);
    
    CGFloat width2 = [AXGTools getTextWidth:self.numberLabel.text font:self.numberLabel.font];
    self.numberLabel.frame = CGRectMake(self.width - width2 - 16 * WIDTH_NIT, 0, width2, self.height);
    
    self.flowerImage.frame = CGRectMake(self.width - 16 * WIDTH_NIT - width2 - 15 * WIDTH_NIT - 22 * WIDTH_NIT, 0, 22 * WIDTH_NIT, 26 * WIDTH_NIT);
    self.flowerImage.center = CGPointMake(self.flowerImage.centerX, self.height / 2);
    
    self.lineView.frame = CGRectMake(0, self.height - 0.5, self.width, 0.5);
}

- (void)setModel:(GiftUserModel *)model {
    _model = model;

    NSString *url = [NSString stringWithFormat:GET_USER_HEAD, [XWAFNetworkTool md5HexDigest:model.phone]];
    [self.headImage sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"头像"]];
    self.nameLabel.text = model.user_name;
    self.numberLabel.text = [NSString stringWithFormat:@"x%@", model.giftNumber];
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
