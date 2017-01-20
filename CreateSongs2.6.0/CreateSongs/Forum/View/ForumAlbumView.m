//
//  ForumAlbumView.m
//  CreateSongs
//
//  Created by 爱写歌 on 16/9/8.
//  Copyright © 2016年 AXG. All rights reserved.
//

#import "ForumAlbumView.h"
#import "AXGHeader.h"

// 额定高度   75 * width_nit

@implementation ForumAlbumView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self createView];
    }
    return self;
}

- (void)createView {
    
    self.themeImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 75 * WIDTH_NIT, 75 * WIDTH_NIT)];
    [self addSubview:self.themeImage];
    self.themeImage.layer.cornerRadius = 7;
    self.themeImage.layer.masksToBounds = YES;
    
    self.maskImage = [[UIImageView alloc] initWithFrame:self.themeImage.frame];
    [self addSubview:self.maskImage];
    self.maskImage.layer.cornerRadius = 5;
    self.maskImage.layer.masksToBounds = YES;
    self.maskImage.image = [UIImage imageNamed:@"个性推荐模板"];
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.themeImage.right + 10 * WIDTH_NIT, 0, 200 * WIDTH_NIT, 30)];
    [self addSubview:self.titleLabel];
    self.titleLabel.textColor = HexStringColor(@"#535353");
    self.titleLabel.font = JIACU_FONT(12);
    self.titleLabel.center = CGPointMake(self.titleLabel.centerX, 11 * WIDTH_NIT);
    
    self.lyricLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.titleLabel.left, 0, self.titleLabel.width, self.titleLabel.height)];
    [self addSubview:self.lyricLabel];
    self.lyricLabel.textColor = HexStringColor(@"#535353");
    self.lyricLabel.font = NORML_FONT(12);
    self.lyricLabel.center = CGPointMake(self.lyricLabel.centerX, self.titleLabel.centerY + 18 * WIDTH_NIT);
    
    self.songLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.lyricLabel.left, 0, self.lyricLabel.width, self.lyricLabel.height)];
    [self addSubview:self.songLabel];
    self.songLabel.textColor = HexStringColor(@"#535353");
    self.songLabel.font = self.lyricLabel.font;
    self.songLabel.center = CGPointMake(self.songLabel.centerX, self.lyricLabel.centerY + 18 * WIDTH_NIT);
    
    self.singerLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.songLabel.left, 0, self.songLabel.width, self.songLabel.height)];
    [self addSubview:self.singerLabel];
    self.singerLabel.textColor = HexStringColor(@"#535353");
    self.singerLabel.font = self.songLabel.font;
    self.singerLabel.center = CGPointMake(self.singerLabel.centerX, self.songLabel.centerY + 18 * WIDTH_NIT);
    
    self.button = [UIButton new];
    self.button.frame = self.bounds;
    [self addSubview:self.button];
    [self.button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    
}

// 重新设置frame
- (void)resetFrame {
    self.themeImage.frame = CGRectMake(0, 0, 75 * WIDTH_NIT, 75 * WIDTH_NIT);
    self.maskImage.frame = self.themeImage.frame;
    self.titleLabel.frame = CGRectMake(self.themeImage.right + 10 * WIDTH_NIT, 0, 200 * WIDTH_NIT, 30);
    self.titleLabel.center = CGPointMake(self.titleLabel.centerX, 11 * WIDTH_NIT);
    self.lyricLabel.frame = CGRectMake(self.titleLabel.left, 0, self.titleLabel.width, self.titleLabel.height);
    self.lyricLabel.center = CGPointMake(self.lyricLabel.centerX, self.titleLabel.centerY + 18 * WIDTH_NIT);
    self.songLabel.frame = CGRectMake(self.lyricLabel.left, 0, self.lyricLabel.width, self.lyricLabel.height);
    self.songLabel.center = CGPointMake(self.songLabel.centerX, self.lyricLabel.centerY + 18 * WIDTH_NIT);
    self.singerLabel.frame = CGRectMake(self.songLabel.left, 0, self.songLabel.width, self.songLabel.height);
    self.singerLabel.center = CGPointMake(self.singerLabel.centerX, self.songLabel.centerY + 18 * WIDTH_NIT);
}

- (void)buttonAction:(UIButton *)sender {
    if (self.touchAlbumBlock) {
        self.touchAlbumBlock();
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
