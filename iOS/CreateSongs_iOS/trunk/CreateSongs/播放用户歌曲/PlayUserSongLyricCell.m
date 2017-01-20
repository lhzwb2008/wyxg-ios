//
//  PlayUserSongLyricCell.m
//  CreateSongs
//
//  Created by axg on 16/5/3.
//  Copyright © 2016年 AXG. All rights reserved.
//

#import "PlayUserSongLyricCell.h"
#import "UIColor+expanded.h"
#import "AXGHeader.h"

static NSString *const indentifier = @"PlayUserSongLyricCellIndentifier";

@implementation PlayUserSongLyricCell

+ (instancetype)customCommentCell:(UITableView *)tableView {
    PlayUserSongLyricCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    if (cell == nil) {
        cell = [[PlayUserSongLyricCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifier];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initSubViews];
    }
    return self;
}

- (void)initSubViews {
    self.songNameLabel = [UILabel new];
    self.lyricTitleLabel = [UILabel new];
    self.lineLabel = [UILabel new];
    
    
    self.songNameLabel.textAlignment = NSTextAlignmentCenter;
    
    self.lineLabel.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
    // 初始化16个label来存歌词
    for (int i = 0; i < 40; i++) {
        UILabel *label = [UILabel new];
        [self.lyricLabelArray addObject:label];
    }
    
    [self.contentView addSubview:self.songNameLabel];
    [self.contentView addSubview:self.lyricTitleLabel];
    [self.contentView addSubview:self.lineLabel];
}

- (void)setLyricFrameModel:(LyricCellFrameModel *)lyricFrameModel {
    
    _lyricFrameModel = lyricFrameModel;
    
//    [self removeOldLyricLabel];
    
    self.songNameLabel.frame = _lyricFrameModel.songNameLabelFrame;
    self.lyricTitleLabel.frame = _lyricFrameModel.lyricTitleFrame;
    
    self.songNameLabel.text = _lyricFrameModel.songNameStr;
    self.songNameLabel.font = JIACU_FONT(15*WIDTH_NIT);
    
    
//    self.lyricTitleLabel.font = [UIFont systemFontOfSize:15];
//    self.lyricTitleLabel.textColor = THEME_COLOR;
//    self.lyricTitleLabel.text = @"歌词:";
    
//    NSString *nameText = self.songNameLabel.text;
    //把歌名两个字变色，用正则表达式
//    NSRange range = [nameText rangeOfString:@"([\u4e00-\u9fa5]|[a-zA-Z0-9])+:" options:NSRegularExpressionSearch];
//    if (range.location != NSNotFound) {
//        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:nameText];
//        [str addAttribute:NSForegroundColorAttributeName value:THEME_COLOR range:NSMakeRange(0, range.length)];
//        [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#666666"] range:NSMakeRange(range.length, str.length - range.length)];
//        self.songNameLabel.attributedText = str;
//    } else {
//        self.songNameLabel.text = [NSString stringWithFormat:@"歌名: %@", _lyricFrameModel.songNameStr];
//    }
    
    for (NSInteger i = 0; i < _lyricFrameModel.lyricFrameArray.count; i++) {
        if (i < self.lyricLabelArray.count) {
            
            UILabel *lyricLabel = self.lyricLabelArray[i];
            lyricLabel.textAlignment = NSTextAlignmentCenter;
    //        UILabel *lyricLabel = [UILabel new];
            lyricLabel.frame = CGRectFromString(_lyricFrameModel.lyricFrameArray[i]);
            lyricLabel.text = _lyricFrameModel.lyricStrArray[i];
            
            // 将歌词中的-换成~
            lyricLabel.text = [lyricLabel.text stringByReplacingOccurrencesOfString:@"-" withString:@"～"];
            
            lyricLabel.font = NORML_FONT(15*WIDTH_NIT);
            lyricLabel.textColor = [UIColor colorWithHexString:@"#666666"];
            
    //        [self.lyricLabelArray addObject:lyricLabel];
        
            [self.contentView addSubview:lyricLabel];
        }
    }
    self.lineLabel.frame = _lyricFrameModel.lineFrame;
}

- (void)removeOldLyricLabel {
    for (NSInteger i = 0; i < self.lyricLabelArray.count; i++) {
        UILabel *label = self.lyricLabelArray[i];
        if (label.superview) {
            [label removeFromSuperview];
        }
    }
    [self.lyricLabelArray removeAllObjects];
}

- (NSMutableArray *)lyricLabelArray {
    if (_lyricLabelArray == nil) {
        _lyricLabelArray = [NSMutableArray array];
    }
    return _lyricLabelArray;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
