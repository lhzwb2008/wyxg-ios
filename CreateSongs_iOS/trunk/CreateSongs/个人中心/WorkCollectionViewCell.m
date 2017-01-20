//
//  WorkCollectionViewCell.m
//  CreateSongs
//
//  Created by 爱写歌 on 16/6/30.
//  Copyright © 2016年 AXG. All rights reserved.
//

#import "WorkCollectionViewCell.h"
#import "AXGHeader.h"
#import "Masonry.h"
#import "UIImageView+WebCache.h"
#import "UserModel.h"
#import "NSString+Common.h"
#import "NSString+Emojize.h"

@implementation WorkCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        self.isMyPersonCenter = NO;
        
        self.maskView = [UIView new];
        [self.contentView addSubview:self.maskView];
        self.maskView.backgroundColor = [UIColor clearColor];
        self.maskView.layer.cornerRadius = 5;
        self.maskView.layer.masksToBounds = YES;
        
        self.seperateLabel = [UILabel new];
        self.seperateLabel.backgroundColor = [UIColor colorWithHexString:@"#576d6d"];
        
        self.timeLineLabel1 = [UILabel new];
        self.timeLineLabel1.backgroundColor = [UIColor colorWithHexString:@"#576d6d"];
        self.lineImage = [UIImageView new];
        self.lineImage.image = [UIImage imageNamed:@"时间轴icon"];
        self.timeLineLabel2 = [UILabel new];
        self.timeLineLabel2.backgroundColor = [UIColor colorWithHexString:@"#576d6d"];
        self.createTimeLabel = [UILabel new];
        self.createTimeLabel.textColor = [UIColor colorWithHexString:@"#525252"];
        self.createTimeLabel.font = [UIFont boldSystemFontOfSize:12 * WIDTH_NIT];
        self.createTimeLabel.text = @"2015.12.12";
        
        self.createSecondLabel = [UILabel new];
        self.createSecondLabel.textColor = [UIColor colorWithHexString:@"#ffffff"];
        self.createSecondLabel.font = [UIFont systemFontOfSize:12*WIDTH_NIT];
        self.createSecondLabel.textAlignment = NSTextAlignmentRight;
        
        self.themeImage = [UIImageView new];
        self.themeImage.contentMode = UIViewContentModeScaleAspectFill;
        self.themeImage.clipsToBounds = YES;
        self.themeImage.layer.cornerRadius = 10;
        

        self.title = [UILabel new];
        self.title.font = JIACU_FONT(12);
        self.title.textColor = [UIColor colorWithHexString:@"#535353"];
        self.title.textAlignment = NSTextAlignmentCenter;
        self.title.numberOfLines = 1;
        
        self.lyricLable = [UILabel new];
        self.lyricLable.textColor = [UIColor colorWithHexString:@"#535353"];
        self.lyricLable.font = [UIFont systemFontOfSize:12*WIDTH_NIT];
        self.lyricLable.backgroundColor = [UIColor clearColor];
        self.lyricLable.numberOfLines = 1;
        
        
        self.playCountsImage = [UIImageView new];
        self.playCounts = [UILabel new];
        self.playCounts.font = [UIFont systemFontOfSize:10 * WIDTH_NIT];
        self.playCounts.textColor = [UIColor colorWithHexString:@"535353"];
        self.playCounts.textAlignment = NSTextAlignmentRight;
        
        
        self.headImage = [UIImageView new];
        self.headImage.image = [UIImage imageNamed:@"head"];
        self.userName = [UILabel new];
        
        self.userName.font = [UIFont systemFontOfSize:10 * WIDTH_NIT];
        self.userName.textColor = [UIColor whiteColor];
        
        self.upCountLabel = [UILabel new];
        self.upCountLabel.textColor = [UIColor colorWithHexString:@"535353"];
        self.upCountLabel.font = [UIFont systemFontOfSize:10*WIDTH_NIT];
        self.upCountLabel.textAlignment = NSTextAlignmentRight;
        self.upImageView = [UIImageView new];
        self.upImageView.backgroundColor = [UIColor clearColor];
        
        self.moreButton = [UIButton new];
        
        [self.moreButton addTarget:self action:@selector(moreButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        self.moreImage.hidden = YES;
        self.moreButton.hidden = YES;
        
        
        self.maskImageView = [UIImageView new];
        self.maskImageView.image = [UIImage imageNamed:@"个人唱片模板"];
        self.maskImageView.backgroundColor = [UIColor clearColor];
//        [self.contentView addSubview:self.seperateLabel];
//        [self.contentView addSubview:self.timeLineLabel1];
//        [self.contentView addSubview:self.timeLineLabel2];
//        [self.contentView addSubview:self.lineImage];
//        [self.contentView addSubview:self.createTimeLabel];
//        [self.contentView addSubview:self.lyricLable];
        [self.contentView addSubview:self.themeImage];
        [self.contentView addSubview:self.maskImageView];
        [self.contentView addSubview:self.title];
//        [self.contentView addSubview:self.lyricLable];
//        [self.contentView addSubview:self.createSecondLabel];
//        [self.contentView addSubview:self.upCountLabel];
//        [self.contentView addSubview:self.upImageView];
//        [self.contentView addSubview:self.playCountsImage];
//        [self.contentView addSubview:self.playCounts];
//        [self.contentView addSubview:self.moreButton];
       
    }
    return self;
}

- (void)applyLayoutAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes {
    [super applyLayoutAttributes:layoutAttributes];
    
    
//    self.timeLineLabel1.frame = CGRectMake(20 * WIDTH_NIT, 0, 0.5, 20*HEIGHT_NIT);
//    self.lineImage.frame = CGRectMake(0, self.timeLineLabel1.bottom, 25*HEIGHT_NIT, 25*HEIGHT_NIT);
//    self.lineImage.center = CGPointMake(self.timeLineLabel1.centerX, self.lineImage.centerY);
//    self.timeLineLabel2.frame = CGRectMake(self.timeLineLabel1.left, self.lineImage.bottom, self.timeLineLabel1.width, self.contentView.height-self.lineImage.bottom);
//    self.createTimeLabel.frame = CGRectMake(40*WIDTH_NIT, 0, self.contentView.width, 12);
//    self.createTimeLabel.center = CGPointMake(self.createTimeLabel.centerX, self.lineImage.centerY);
//    
//    CGFloat themWidth = self.contentView.height - (28+12+25+25)*HEIGHT_NIT;
//    self.themeImage.frame = CGRectMake(self.timeLineLabel2.right + 20*WIDTH_NIT, self.createTimeLabel.bottom+25*HEIGHT_NIT, themWidth, themWidth);
//    self.title.frame = CGRectMake(self.themeImage.right + 10*WIDTH_NIT, self.themeImage.top+3*HEIGHT_NIT, self.contentView.width-self.themeImage.right + 20 - 16*WIDTH_NIT, 12);
//    self.lyricLable.frame = CGRectMake(self.title.left, self.title.bottom + 15*HEIGHT_NIT, self.contentView.width-self.title.left-16*WIDTH_NIT, 12);
//   
//    self.seperateLabel.frame = CGRectMake(self.themeImage.left, self.contentView.height-0.5, self.contentView.width-self.themeImage.left, 0.5*HEIGHT_NIT);
//    
//    self.createSecondLabel.frame = CGRectMake(self.contentView.width - 100 - 16*WIDTH_NIT, self.title.top, 100, 12);
//
//    
//    CGSize sz = [@"1234" sizeWithFont:self.upCountLabel.font constrainedToSize:CGSizeMake(MAXFLOAT, 40)];
//
//    self.upImageView.frame = CGRectMake(self.contentView.width-(16+5+15)*WIDTH_NIT-sz.width, self.contentView.height-25*HEIGHT_NIT-13*WIDTH_NIT, 15*WIDTH_NIT, 13*WIDTH_NIT);
//    self.upCountLabel.frame = CGRectMake(self.contentView.width - 16*WIDTH_NIT - 10*WIDTH_NIT*4, 0, 10*WIDTH_NIT*4, 10);
//    self.upCountLabel.center = CGPointMake(self.upCountLabel.centerX, self.upImageView.centerY);
//    
//    
//    self.playCounts.frame = CGRectMake(self.upImageView.left-25*WIDTH_NIT-self.upCountLabel.width, 0, self.upCountLabel.width, self.upCountLabel.height);
//    self.playCounts.center = CGPointMake(self.playCounts.centerX, self.upImageView.centerY);
//    
//    self.playCountsImage.frame = CGRectMake(self.upImageView.left-25*WIDTH_NIT-5*WIDTH_NIT-sz.width-15*WIDTH_NIT, 0, 15*WIDTH_NIT, 14.5*WIDTH_NIT);
//    self.playCountsImage.center = CGPointMake(self.playCountsImage.centerX, self.upImageView.centerY);
    
    self.maskView.frame = CGRectMake(-19 * WIDTH_NIT, -10 * HEIGHT_NIT, self.width + 38 * WIDTH_NIT, self.height + 20 * HEIGHT_NIT);
    
    CGSize titleSize = [@"作品" getWidth:@"作品" andFont:[UIFont boldSystemFontOfSize:12]];
    
    self.themeImage.frame = CGRectMake(0, 0, self.contentView.width, self.contentView.width);
    self.maskImageView.frame = self.themeImage.frame;
    self.title.frame = CGRectMake(0, self.themeImage.bottom + 12*HEIGHT_NIT, self.contentView.width, titleSize.height);
}

- (void)layoutSubviews {
    [super layoutSubviews];
}

- (void)setDataModel:(HomePageUserMess *)dataModel {
    _dataModel = dataModel;
    /**
     *  设置图片文字以及其占位内容
     */
    NSString *picUrl = [NSString stringWithFormat:GET_SONG_IMG, _dataModel.code];
    
    [self.themeImage sd_setImageWithURL:[NSURL URLWithString:picUrl] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    WEAK_SELF;
    
    if (dataModel.user_name.length != 0) {
        self.userName.text = dataModel.user_name;
    } else {
        [XWAFNetworkTool getUrl:[NSString stringWithFormat:GET_USER_ID_URL, dataModel.user_id] body:nil response:XWJSON requestHeadFile:nil success:^(NSURLSessionDataTask *task, id resposeObject) {
            STRONG_SELF;
            if ([resposeObject[@"status"] isEqualToNumber:@0]) {
                self.userName.text = [resposeObject[@"name"] emojizedString];
            }
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            
        }];
    }
    
    
    self.lyricUrl = [NSString stringWithFormat:HOME_LYRIC, _dataModel.code];
//    NSLog(@"_________________%@", self.lyricUrl);
    
    if (dataModel.title.length != 0) {
        self.title.text = dataModel.title;
        [XWAFNetworkTool getUrl:self.lyricUrl body:nil response:XWData requestHeadFile:nil success:^(NSURLSessionDataTask *task, id resposeObject) {
            STRONG_SELF;
            //        self.title.hidden = NO;
            NSString *lyric = [[NSString alloc] initWithData:resposeObject encoding:NSUTF8StringEncoding];
            NSArray *array = [lyric componentsSeparatedByString:@":"];
            self.lyricLable.text = [array lastObject];
//            NSLog(@"+%@", self.lyricLable.text);
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            
        }];

    } else {
        
        [XWAFNetworkTool getUrl:self.lyricUrl body:nil response:XWData requestHeadFile:nil success:^(NSURLSessionDataTask *task, id resposeObject) {
            STRONG_SELF;
            //        self.title.hidden = NO;
            NSString *lyric = [[NSString alloc] initWithData:resposeObject encoding:NSUTF8StringEncoding];
            NSArray *array = [lyric componentsSeparatedByString:@":"];
            self.title.text = [array firstObject];
            self.lyricLable.text = [array lastObject];
//            NSLog(@"-%@", self.lyricLable.text);
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            
        }];
    }
    
    self.playCountsImage.image = [UIImage imageNamed:@"个人中心页_试听量"];
    
    if (self.dataModel.play_count.integerValue >= 10000) {
        float playCount = self.dataModel.play_count.integerValue / 10000.0;
        self.playCounts.text = [NSString stringWithFormat:@"%.1f万", playCount];
    } else {
        self.playCounts.text = self.dataModel.play_count;
    }
    
    
    // 判断播放数
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:11 * WIDTH_NIT],};
    CGSize textSize = [self.playCounts.text boundingRectWithSize:CGSizeMake(100, 100) options:NSStringDrawingTruncatesLastVisibleLine attributes:attributes context:nil].size;


    NSArray *timeArray = [_dataModel.create_time componentsSeparatedByString:@" "];
    if (timeArray.count > 1) {
        self.createTimeLabel.text = [timeArray firstObject];
        
        NSString *secondStr = [timeArray lastObject];
        self.createSecondLabel.text = [secondStr substringToIndex:5];
    }
    self.upImageView.image = [UIImage imageNamed:@"个人中心页_赞"];
    if (self.dataModel.up_count.integerValue >= 10000) {
        float playCount = self.dataModel.up_count.integerValue / 10000.0;
        self.upCountLabel.text = [NSString stringWithFormat:@"%.1f万", playCount];
    } else {
//        self.upCountLabel.text = self.dataModel.up_count;
        self.upCountLabel.text = @"1234";
    }}

// 更多按钮方法
- (void)moreButtonAction:(UIButton *)sender {
    if (self.moreActionBlock) {
        self.moreActionBlock(self.dataModel.code, self.title.text);
    }
}

//将图片缩放到指定尺寸
- (UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize {
    UIGraphicsBeginImageContext(newSize);
    
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return newImage;
}

@end
