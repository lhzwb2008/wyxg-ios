//
//  RecommandCollectionViewCell.m
//  CreateSongs
//
//  Created by 爱写歌 on 16/7/14.
//  Copyright © 2016年 AXG. All rights reserved.
//

#import "RecommandCollectionViewCell.h"
#import "AXGHeader.h"

@implementation RecommandCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self createCell];
    }
    return self;
}

- (void)applyLayoutAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes {
    
    self.maskView.frame = CGRectMake(- 19 * WIDTH_NIT, - 10 * HEIGHT_NIT, self.width + 38 * WIDTH_NIT, self.height - 10 * HEIGHT_NIT);
    
    self.themeImage.frame = CGRectMake(0, 0, self.width, self.width);
    self.themeImage.layer.cornerRadius = 10;
    self.themeImage.layer.masksToBounds = YES;
    
    self.maskImage.frame = self.themeImage.frame;
    self.maskImage.layer.cornerRadius = 5;
    self.maskImage.layer.masksToBounds = YES;
    
    self.titleLabel.frame = CGRectMake(0, self.themeImage.bottom, self.themeImage.width, 32 * WIDTH_NIT);
}

- (void)createCell {
    
    self.clipsToBounds = NO;
    
    self.maskView = [UIView new];
    [self addSubview:self.maskView];
    self.maskView.backgroundColor = [UIColor clearColor];
    self.maskView.layer.cornerRadius = 3;
    self.maskView.layer.masksToBounds = YES;
    
    self.themeImage = [UIImageView new];
    [self addSubview:self.themeImage];
    
    self.maskImage = [UIImageView new];
    [self addSubview:self.maskImage];
    self.maskImage.image = [UIImage imageNamed:@"个性推荐模板"];
    
    self.titleLabel = [UILabel new];
    [self addSubview:self.titleLabel];
    self.titleLabel.font = NORML_FONT(12 * WIDTH_NIT);
    self.titleLabel.textColor = HexStringColor(@"#a0a0a0");
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    
}

- (void)setModel:(SongModel *)model {

    _model = model;

    NSString *picUrl = [NSString stringWithFormat:GET_SONG_IMG, model.code];
    
    [self.themeImage sd_setImageWithURL:[NSURL URLWithString:picUrl] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    
    WEAK_SELF;
    
    self.lyricUrl = [NSString stringWithFormat:HOME_LYRIC, model.code];
    
    if (model.title.length != 0) {
        self.titleLabel.text = model.title;
        NSLog(@"------------%@", model.title);
        
        
        NSString *deCodeOriginalTitle = [model.original_title stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        if (deCodeOriginalTitle.length != 0) {
            self.titleLabel.text = [model.title stringByAppendingString:[NSString stringWithFormat:@"(原曲:%@)", deCodeOriginalTitle]];
        } else {
            self.titleLabel.text = model.title;
        }
        
        
    } else {
        
        [XWAFNetworkTool getUrl:self.lyricUrl body:nil response:XWData requestHeadFile:nil success:^(NSURLSessionDataTask *task, id resposeObject) {
            STRONG_SELF;
            NSString *lyric = [[NSString alloc] initWithData:resposeObject encoding:NSUTF8StringEncoding];
            self.titleLabel.text = [[lyric componentsSeparatedByString:@":"] firstObject];
            NSLog(@"!!!!!!!!!!!!------------%@", self.titleLabel.text);
            
            
            NSString *deCodeOriginalTitle = [model.original_title stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            if (deCodeOriginalTitle.length != 0) {
                self.titleLabel.text = [[[lyric componentsSeparatedByString:@":"] firstObject] stringByAppendingString:[NSString stringWithFormat:@"(原曲:%@)", deCodeOriginalTitle]];
            } else {
                self.titleLabel.text = [[lyric componentsSeparatedByString:@":"] firstObject];
            }
            
            
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            
        }];
    }
    
}


@end
