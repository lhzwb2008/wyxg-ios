//
//  LyricTableViewCell.m
//  CreateSongs
//
//  Created by 爱写歌 on 16/3/7.
//  Copyright © 2016年 AXG. All rights reserved.
//

#import "LyricTableViewCell.h"



@implementation LyricTableViewCell

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tyBtnClick) name:@"TYBtnViewTap" object:nil];
        self.backgroundColor = [UIColor clearColor];
        [self createCell];
    }
    return self;
}

- (void)tyBtnClick {
    if (self.showTyViewBlock) {
        self.showTyViewBlock(self.index);
    }
}
// 创建cell
- (void)createCell {
    
    self.lyric = [UILabel new];
    self.lyric.textColor = [UIColor colorWithHexString:@"#535353"];
    self.lyric.textAlignment = NSTextAlignmentCenter;

    [self addSubview:self.lyric];
    self.lyric.backgroundColor = [UIColor clearColor];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGSize lyricSize = [@"歌词" getWidth:@"歌词" andFont:self.lyric.font];
    self.lyric.frame = CGRectMake(0, 0, self.contentView.width, lyricSize.height);
}

- (void)setIndex:(NSInteger)index {
    _index = index;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
