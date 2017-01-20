//
//  PlayUserSongNoneDataCell.m
//  CreateSongs
//
//  Created by axg on 16/5/12.
//  Copyright © 2016年 AXG. All rights reserved.
//

#import "PlayUserSongNoneDataCell.h"
#import "AXGHeader.h"

static NSString *const indentifier = @"customNoteDataCell";

@interface PlayUserSongNoneDataCell ()

@property (nonatomic, strong) UIImageView *noteDataImageView;

@property (nonatomic, strong) UILabel *noneTitle;

@end

@implementation PlayUserSongNoneDataCell


+ (instancetype)customNoneDataCellWithTableView:(UITableView *)tableView {
    PlayUserSongNoneDataCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    if (cell == nil) {
        cell = [[PlayUserSongNoneDataCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifier];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.noteDataImageView = [UIImageView new];
        
        self.noneTitle = [UILabel new];
        self.noneTitle.text = @"沙发空荡荡";
        self.noneTitle.textAlignment = NSTextAlignmentCenter;
        self.noneTitle.textColor  =[UIColor colorWithHexString:@"a0a0a0"];
        self.noneTitle.font = NORML_FONT(15);
//        self.noteDataImageView.frame = CGRectMake((self.contentView.bounds.size.width) / 2, 18, 92, 94);
        self.noteDataImageView.image = [UIImage imageNamed:@"草稿空状态"];
        
        [self.contentView addSubview:self.noteDataImageView];
        [self.contentView addSubview:self.noneTitle];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];//337 432
    self.noteDataImageView.frame = CGRectMake(0, 18, 168, 216);
    self.noteDataImageView.centerX = self.contentView.width / 2;
    self.noneTitle.frame = CGRectMake(0, self.noteDataImageView.bottom + 20, self.contentView.width, 15);
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
