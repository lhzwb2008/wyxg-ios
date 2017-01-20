//
//  ForumCommentTableViewCell.m
//  CreateSongs
//
//  Created by 爱写歌 on 16/7/7.
//  Copyright © 2016年 AXG. All rights reserved.
//

#import "ForumCommentTableViewCell.h"
#import "AXGHeader.h"
#import "XWAFNetworkTool.h"
#import "UIImageView+WebCache.h"
#import "NSString+Emojize.h"
#import "NSString+Common.h"

@implementation ForumCommentTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createCell];
    }
    return self;
}

- (void)createCell {
    self.bgView = [UIView new];
    self.bgView.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
    [self.contentView addSubview:self.bgView];
    
    
    self.thumbView = [UIView new];
    self.thumbView.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
    [self.contentView addSubview:self.thumbView];
    
    self.genderImage = [UIImageView new];
    [self.contentView addSubview:self.genderImage];
    
    self.headImage = [UIImageView new];
    [self.contentView addSubview:self.headImage];
    
    self.nameLabel = [UILabel new];
    [self.contentView addSubview:self.nameLabel];
    self.nameLabel.textColor = THEME_COLOR;
    self.nameLabel.font = [UIFont systemFontOfSize:12];
    
    self.nameLabel2 = [UILabel new];
    [self.contentView addSubview:self.nameLabel2];
    self.nameLabel2.textColor = THEME_COLOR;
    self.nameLabel2.font = [UIFont systemFontOfSize:12];
    
    self.content = [UILabel new];
    [self.contentView addSubview:self.content];
    self.content.textColor = [UIColor colorWithHexString:@"#666666"];
    self.content.font = [UIFont systemFontOfSize:12];
    
    self.timeLabel = [UILabel new];
    [self.contentView addSubview:self.timeLabel];
    self.timeLabel.textColor = [UIColor colorWithHexString:@"#a3a3a3"];
    self.timeLabel.font = [UIFont systemFontOfSize:10];
    
    self.lineView = [UIView new];
    [self.contentView addSubview:self.lineView];

    self.nameLabel.font = NORML_FONT(12*WIDTH_NIT);
    self.content.font = JIACU_FONT(12*WIDTH_NIT);
    self.content.numberOfLines = 0;
    self.timeLabel.font = NORML_FONT(10*WIDTH_NIT);
    self.timeLabel.textAlignment = NSTextAlignmentRight;
}


- (void)setModel:(ForumCommentFrameModel *)model {
    _model = model;
    
    self.bgView.frame = _model.bgFrame;
    self.headImage.frame = _model.userHeadFrame;
    
    self.content.frame = _model.userContentFrame;
    self.timeLabel.frame = _model.timeLabelFrame;

    
    self.headImage.clipsToBounds = YES;
    self.headImage.layer.cornerRadius = self.headImage.height / 2;

    self.thumbView.clipsToBounds = YES;
    self.thumbView.layer.cornerRadius = self.thumbView.height / 2;
    
    ForumCommentsModel *commentsModel = _model.commentsModel;
    
    self.content.text = [commentsModel.content emojizedString];
    self.timeLabel.text = [commentsModel.create_time intervalSinceNow:commentsModel.create_time];

    if (commentsModel.phone.length != 0) {
        [self.headImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:GET_USER_HEAD, [NSString stringWithFormat:@"%@", [XWAFNetworkTool md5HexDigest:commentsModel.phone]]]] placeholderImage:[UIImage imageNamed:@"头像"]];
    } else {
        self.headImage.image = [UIImage imageNamed:@"头像"];
    }

    self.name = [commentsModel.user_name emojizedString];
    if (commentsModel.parent.length != 0) {
        self.nameLabel2.text = [[NSString stringWithFormat:@"回复:%@", commentsModel.parent] emojizedString];
        self.nameLabel.text = [[NSString stringWithFormat:@"%@", self.name] emojizedString];
        CGSize nameSize = [self.nameLabel.text getWidth:self.nameLabel.text andFont:self.nameLabel.font];
        CGRect nameFrame = _model.userNameFrame;
        nameFrame.size.width = nameSize.width;
        self.nameLabel.frame = nameFrame;
        self.thumbView.frame = CGRectMake(self.nameLabel.left + nameSize.width + 7*WIDTH_NIT, 0, 12*WIDTH_NIT, 12*WIDTH_NIT);
        self.thumbView.clipsToBounds = YES;
        self.thumbView.layer.cornerRadius = self.thumbView.height / 2;
        self.thumbView.centerY = self.nameLabel.centerY;
        
        CGFloat nameLabelW = self.timeLabel.left - self.thumbView.right - 10*WIDTH_NIT;
        self.nameLabel2.frame = CGRectMake(self.thumbView.right + 10*WIDTH_NIT, 0, nameLabelW, self.nameLabel.height);
        self.nameLabel2.centerY = self.nameLabel.centerY;
    } else {
        self.nameLabel.text = self.name;
        CGSize nameSize = [self.nameLabel.text getWidth:self.nameLabel.text andFont:self.nameLabel.font];
        CGRect nameFrame = _model.userNameFrame;
        nameFrame.size.width = nameSize.width;
        self.nameLabel.frame = nameFrame;
        
        self.thumbView.frame = CGRectMake(self.nameLabel.left + nameSize.width + 7*WIDTH_NIT, 0, 12*WIDTH_NIT, 12*WIDTH_NIT);
        self.thumbView.clipsToBounds = YES;
        self.thumbView.layer.cornerRadius = self.thumbView.height / 2;
        self.thumbView.centerY = self.nameLabel.centerY;
        self.nameLabel2.frame = CGRectZero;
    }
    
    self.genderImage.frame = self.thumbView.frame;
    
    if ([model.commentsModel.gender isEqualToString:@"1"]) {
        self.genderImage.image = [UIImage imageNamed:@"男icon"];
    } else {
        self.genderImage.image = [UIImage imageNamed:@"女icon"];
    }
   
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
