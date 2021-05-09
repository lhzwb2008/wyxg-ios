//
//  ChooseSingerCell.m
//  CreateSongs
//
//  Created by axg on 16/9/28.
//  Copyright © 2016年 AXG. All rights reserved.
//

#import "ChooseSingerCell.h"
#import "AXGHeader.h"

@implementation ChooseSingerCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.nameLabel];
    }
    return self;
}

- (UILabel *)nameLabel {
    if (_nameLabel == nil) {
        _nameLabel = [UILabel new];
        _nameLabel.textAlignment = NSTextAlignmentLeft;
        _nameLabel.font = [UIFont systemFontOfSize:20];
        _nameLabel.textColor = [UIColor blackColor];
    }
    return _nameLabel;
}

- (void)setSinger_name:(NSString *)singer_name {
    _singer_name = singer_name;
    self.nameLabel.text = _singer_name;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.nameLabel.frame = CGRectMake(20, 0, 100, self.contentView.height);
    self.nameLabel.centerY = self.contentView.height / 2;
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
