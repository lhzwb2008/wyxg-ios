//
//  SixinTableViewCell.m
//  CreateSongs
//
//  Created by 爱写歌 on 16/8/31.
//  Copyright © 2016年 AXG. All rights reserved.
//

#import "SixinTableViewCell.h"
#import "ConversationModel.h"
#import "AXGHeader.h"
#import "AXGTools.h"

@implementation SixinTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initCell];
    }
    return self;
}

- (void)setModel:(ConversationModel *)model {
    _model = model;
    
    [self.headImage sd_setImageWithURL:[NSURL URLWithString:model.imgUrl] placeholderImage:[UIImage imageNamed:@"头像"]];
    self.nameLabel.text = model.nickName;
    self.contentLabel.text = model.content;
    self.timeLabel.text = [AXGTools intervalSinceNow:model.timetamp];
    self.numberLabel.text = model.unreadCount;
    
}

- (void)initCell {
    self.headImage = [UIImageView new];
    [self addSubview:self.headImage];
    
    self.nameLabel = [UILabel new];
    self.nameLabel.textColor = HexStringColor(@"#441D11");
    self.nameLabel.font = JIACU_FONT(15);
    [self addSubview:self.nameLabel];
    
    self.contentLabel = [UILabel new];
    self.contentLabel.textColor = HexStringColor(@"#a0a0a0");
    self.contentLabel.font = JIACU_FONT(12);
    [self addSubview:self.contentLabel];
    
    self.timeLabel = [UILabel new];
    self.timeLabel.font = JIACU_FONT(12);
    self.timeLabel.textColor = HexStringColor(@"#a0a0a0");
    self.timeLabel.textAlignment = NSTextAlignmentRight;
    [self addSubview:self.timeLabel];
    
    self.numberLabel = [UILabel new];
    [self addSubview:self.numberLabel];
    self.numberLabel.textAlignment = NSTextAlignmentCenter;
    self.numberLabel.backgroundColor = HexStringColor(@"#cc2424");
    self.numberLabel.textColor = HexStringColor(@"#ffffff");
    self.numberLabel.font = ZHONGDENG_FONT(12);
    self.numberLabel.text = @"0";
    
    self.lineView = [UIView new];
    [self addSubview:self.lineView];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.headImage.frame = CGRectMake(16 * WIDTH_NIT, 10 * WIDTH_NIT, 45 * WIDTH_NIT, 45 * WIDTH_NIT);
    self.headImage.layer.cornerRadius = self.headImage.height / 2;
    self.headImage.layer.masksToBounds = YES;
    
    self.nameLabel.frame = CGRectMake(self.headImage.right + 15 * WIDTH_NIT, self.headImage.top, 200, 25 * WIDTH_NIT);
    
    self.contentLabel.frame = CGRectMake(self.headImage.right + 15 * WIDTH_NIT, self.nameLabel.bottom, self.nameLabel.width, 28 * WIDTH_NIT);
    
    self.timeLabel.frame = CGRectMake(self.width - 16 * WIDTH_NIT - 200, 0, 200, 42 * WIDTH_NIT);
    
    
    
    self.numberLabel.frame = CGRectMake(self.width - 16 * WIDTH_NIT - 20 * WIDTH_NIT, 0, 20 * WIDTH_NIT, 20 * WIDTH_NIT);
    self.numberLabel.layer.cornerRadius = self.numberLabel.height / 2;
    self.numberLabel.layer.masksToBounds = YES;
    self.numberLabel.center = CGPointMake(self.numberLabel.centerX, self.contentLabel.centerY);
    
    CGFloat width1 = [AXGTools getTextWidth:@"6" font:ZHONGDENG_FONT(12)];
    CGFloat width2 = [AXGTools getTextWidth:@"66" font:ZHONGDENG_FONT(12)];
    CGFloat width3 = [AXGTools getTextWidth:@"99+" font:ZHONGDENG_FONT(12)];
    
    if (_model.unreadCount.integerValue <= 0) {
        self.numberLabel.text = @"0";
        self.numberLabel.frame = CGRectMake(self.numberLabel.left, self.numberLabel.top, 0, self.numberLabel.height);
    } else if (_model.unreadCount.integerValue < 10) {
        self.numberLabel.text = _model.unreadCount;
        self.numberLabel.frame = CGRectMake(self.numberLabel.left, self.numberLabel.top, 20 * WIDTH_NIT, self.numberLabel.height);
    } else if (_model.unreadCount.integerValue <= 99) {
        self.numberLabel.text = _model.unreadCount;
        self.numberLabel.frame = CGRectMake(self.numberLabel.left - (width2 - width1), self.numberLabel.top, 20 * WIDTH_NIT + (width2 - width1), self.numberLabel.height);
    } else {
        self.numberLabel.text = @"99+";
        self.numberLabel.frame = CGRectMake(self.numberLabel.left - (width3 - width1), self.numberLabel.top, 20 * WIDTH_NIT + (width3 - width1), self.numberLabel.height);
    }
    
    self.lineView.frame = CGRectMake(0, self.height - 0.5, self.width, 0.5);
    
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
