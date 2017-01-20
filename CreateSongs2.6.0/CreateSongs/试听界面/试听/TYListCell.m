//
//  TYListCell.m
//  CreateSongs
//
//  Created by axg on 16/6/7.
//  Copyright © 2016年 AXG. All rights reserved.
//

#import "TYListCell.h"
#import "UIView+Common.h"
#import "UIColor+expanded.h"
#import "AXGHeader.h"
#import "TYCommonClass.h"

@interface TYListCell ()



@end

@implementation TYListCell


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initSubViews];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.listLabel.frame = CGRectMake([TYCommonClass sharedTYCommonClass].listCellLeftGap, 0, self.contentView.width, self.contentView.height);
    
//    self.listLabel.center = CGPointMake(self.listLabel.centerX, self.contentView.centerY);
}

- (void)initSubViews {
    self.listLabel = [UILabel new];
    self.listLabel.backgroundColor = [UIColor clearColor];
    if (kDevice_Is_iPhone4 || kDevice_Is_iPad || kDevice_Is_iPad) {
        self.listLabel.font = [UIFont systemFontOfSize:15];
    } else {
        self.listLabel.font = [UIFont systemFontOfSize:18];
    }
    self.listLabel.textAlignment = NSTextAlignmentLeft;
    self.listLabel.textColor = [UIColor colorWithHexString:@"#4c4c4c"];
    [self.contentView addSubview:self.listLabel];
}


@end
