//
//  ActivityTableViewCell.m
//  CreateSongs
//
//  Created by 爱写歌 on 16/7/14.
//  Copyright © 2016年 AXG. All rights reserved.
//

#import "ActivityTableViewCell.h"
#import "AXGHeader.h"

@implementation ActivityTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createCell];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.activityImage.frame = CGRectMake(5 * WIDTH_NIT, 5 * WIDTH_NIT, self.width - 10 * WIDTH_NIT, self.height - 5 * WIDTH_NIT);
    self.activityImage.layer.cornerRadius = 5 * WIDTH_NIT;
    self.activityImage.layer.masksToBounds = YES;
    
//    self.lineView.frame = CGRectMake(0, 0, self.width, 1 * WIDTH_NIT);
    
    self.overImage.frame = CGRectMake(self.width - 49 * WIDTH_NIT, 1 * WIDTH_NIT, 49 * WIDTH_NIT, 49 * WIDTH_NIT);
}

- (void)createCell {
    
    self.backgroundColor = [UIColor whiteColor];
    
    self.activityImage = [UIImageView new];
    [self.contentView addSubview:self.activityImage];
    
//    self.lineView = [UIView new];
//    [self.contentView addSubview:self.lineView];
//    self.lineView.backgroundColor = HexStringColor(@"#eeeeee");
    
    self.overImage = [UIImageView new];
    [self.contentView addSubview:self.overImage];
    self.overImage.image = [UIImage imageNamed:@"已结束标签"];
    
}

- (void)setModel:(ActivityModel *)model {
    _model = model;
    
#warning 没有展位图，需要修改
    [self.activityImage sd_setImageWithURL:[NSURL URLWithString:model.img] placeholderImage:[UIImage imageNamed:@"bannerPlaceholder"]];
    
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
