//
//  HomePageCollectionViewCell.m
//  CreateSongs
//
//  Created by axg on 16/3/19.
//  Copyright © 2016年 AXG. All rights reserved.
//

#import "HomePageCollectionViewCell.h"
#import "AXGHeader.h"
#import "Masonry.h"
#import "UIImageView+WebCache.h"
#import "UserModel.h"
#import "NSString+Common.h"
#import "NSString+Emojize.h"

@implementation HomePageCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        self.isMyPersonCenter = NO;
        
        self.bgView = [UIView new];
        self.bgView.backgroundColor = [UIColor whiteColor];
        
        self.themeImage = [UIImageView new];
        //    self.themeImage.userInteractionEnabled = YES;
//        self.themeImage.backgroundColor = [UIColor redColor];
        self.title = [UILabel new];
        self.title.font = [UIFont systemFontOfSize:16 * WIDTH_NIT];
        self.title.textColor = [UIColor whiteColor];
        
        self.playCountsImage = [UIImageView new];

        self.playCounts = [UILabel new];
        self.playCounts.font = [UIFont systemFontOfSize:12 * WIDTH_NIT];
        
        
        self.playCountMask = [UIView new];
        self.playCountMask.backgroundColor = [UIColor colorWithWhite:0.000 alpha:0.30];
        
        self.playCountView = [UIView new];
        self.playCountView.backgroundColor = [UIColor clearColor];
        
        self.headImage = [UIImageView new];
        self.headImage.image = [UIImage imageNamed:@"head"];
        self.userName = [UILabel new];
        self.userNameMaskView = [UIImageView new];
        self.userNameMaskView.image = [UIImage imageNamed:@"jb"];
        
        self.userName.font = [UIFont systemFontOfSize:14 * WIDTH_NIT];
        self.userName.textColor = [UIColor whiteColor];
        
//        self.userNameMaskView.backgroundColor = [UIColor colorWithWhite:0.000 alpha:0.30];
        
        [self.contentView addSubview:self.bgView];
        [self.contentView addSubview:self.themeImage];
        [self.contentView addSubview:self.title];
        
        [self.contentView addSubview:self.playCountMask];
 
        [self.contentView addSubview:self.userNameMaskView];
        [self.userNameMaskView addSubview:self.userName];
        [self.userNameMaskView addSubview:self.headImage];
        
        [self.playCountMask addSubview:self.playCountsImage];
        [self.playCountMask addSubview:self.playCounts];
        
        self.bgMaskView = [UIView new];
        [self.themeImage addSubview:self.bgMaskView];
//        [self.themeImage addSubview:self.maskView];
        
        self.moreImage = [UIImageView new];
        self.moreImage.image = [UIImage imageNamed:@"moreButton"];
        
        [self.contentView addSubview:self.moreImage];
        
        self.moreButton = [UIButton new];
        [self.contentView addSubview:self.moreButton];
        [self.moreButton addTarget:self action:@selector(moreButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        
        self.moreImage.hidden = YES;
        self.moreButton.hidden = YES;
    }
    return self;
}

- (void)applyLayoutAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes {
    [super applyLayoutAttributes:layoutAttributes];

//    self.playCounts.textColor = PLACEHOLDER_COLOR;
    self.playCounts.textColor = [UIColor whiteColor];
    self.playCounts.textAlignment = NSTextAlignmentLeft;
    
//    self.playCounts.textAlignment = NSTextAlignmentCenter;
    self.title.textColor = [UIColor colorWithRed:51 / 255.0 green:51 / 255.0 blue:51 / 255.0 alpha:1];
    self.title.textAlignment = NSTextAlignmentLeft;

    self.themeImage.frame = CGRectMake(0, 0, self.contentView.width, self.contentView.width / 340 * 272);
    self.bgMaskView.backgroundColor = THEME_COLOR;
//    self.bgMaskView.alpha = 0.065327;
    self.bgMaskView.alpha = 0.1;
    self.bgMaskView.frame = self.themeImage.bounds;
    
    
    
    self.bgView.frame = CGRectMake(self.themeImage.left, self.themeImage.top, self.themeImage.width, self.height - 15);
    
//    self.title.frame = CGRectMake(self.themeImage.left + 10 * WIDTH_NIT, self.themeImage.bottom + 17 * WIDTH_NIT, self.width, 16 * WIDTH_NIT);

    self.title.frame = CGRectMake(self.themeImage.left + 10 * WIDTH_NIT, self.themeImage.bottom + 17 * WIDTH_NIT, self.width - 18 * WIDTH_NIT - 13 * WIDTH_NIT - 5 * WIDTH_NIT, 16 * WIDTH_NIT);
    
//    self.playCountMask.frame = CGRectMake(self.themeImage.left + 8*WIDTH_NIT, self.themeImage.bottom - (9 + 21)*WIDTH_NIT, 45 * WIDTH_NIT, 21 * WIDTH_NIT);
    self.playCountMask.frame = CGRectMake(self.themeImage.right - 56 * WIDTH_NIT, self.themeImage.top + 11 * WIDTH_NIT, 45 * WIDTH_NIT, 21 * WIDTH_NIT);
    self.playCountMask.clipsToBounds = YES;
    self.playCountMask.layer.cornerRadius = self.playCountMask.height / 2;
    
    self.playCountsImage.frame = CGRectMake(3*WIDTH_NIT, 4*WIDTH_NIT, 12 * WIDTH_NIT, 12 * WIDTH_NIT);
    
    self.playCounts.frame = CGRectMake(self.playCountsImage.right + 4*WIDTH_NIT, self.playCountsImage.top, 50, self.playCountsImage.height);
    self.playCounts.center = CGPointMake(self.playCounts.center.x, self.playCountsImage.center.y);
    
    self.userNameMaskView.frame = CGRectMake(0, self.themeImage.bottom - 29 * WIDTH_NIT, self.themeImage.width, 29 * WIDTH_NIT);
    self.headImage.frame = CGRectMake(10 * WIDTH_NIT, 0, 16 * WIDTH_NIT, 16 * WIDTH_NIT);
    self.headImage.center = CGPointMake(self.headImage.centerX, self.userNameMaskView.height / 2);
    self.userName.frame = CGRectMake(self.headImage.right + 7 * WIDTH_NIT, 0, self.width - self.headImage.width - 7 * WIDTH_NIT - 7 * WIDTH_NIT, self.userNameMaskView.height);
    
    self.moreImage.frame = CGRectMake(self.width - 13 * WIDTH_NIT - 18 * WIDTH_NIT, self.title.top, 18 * WIDTH_NIT, 3 * WIDTH_NIT);
    self.moreImage.center = CGPointMake(self.moreImage.centerX, self.title.centerY);
    
    self.moreButton.frame = CGRectMake(0, 0, 50 * WIDTH_NIT, 50 * HEIGHT_NIT);
    self.moreButton.center = self.moreImage.center;
//    self.moreButton.backgroundColor = [UIColor redColor];

    
    [self bringSubviewToFront:self.playCountsImage];
    [self bringSubviewToFront:self.playCounts];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
}

- (void)setDataModel:(HomePageUserMess *)dataModel {
    _dataModel = dataModel;
    /**
     *  设置图片文字以及其占位内容
     */
//    NSArray *array1 = [_dataModel.code componentsSeparatedByString:@"/"];
//    NSArray *array2 = [[array1 lastObject] componentsSeparatedByString:@"."];
//    NSString *picName = [array2 firstObject];
    
    NSString *picUrl = [NSString stringWithFormat:GET_SONG_IMG, _dataModel.code];
    
    [self.themeImage sd_setImageWithURL:[NSURL URLWithString:picUrl] placeholderImage:[UIImage imageNamed:@"homePlaceHolderImg"]];
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
    NSLog(@"_________________%@", self.lyricUrl);
    
    if (dataModel.title.length != 0) {
        self.title.text = dataModel.title;
    } else {
        
        [XWAFNetworkTool getUrl:self.lyricUrl body:nil response:XWData requestHeadFile:nil success:^(NSURLSessionDataTask *task, id resposeObject) {
            STRONG_SELF;
            //        self.title.hidden = NO;
            NSString *lyric = [[NSString alloc] initWithData:resposeObject encoding:NSUTF8StringEncoding];
            self.title.text = [[lyric componentsSeparatedByString:@":"] firstObject];
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            
        }];
    }

    self.playCountsImage.image = [UIImage imageNamed:@"shouyeErji@2x"];
    
    if (self.dataModel.play_count.integerValue >= 10000) {
        float playCount = self.dataModel.play_count.integerValue / 10000.0;
        self.playCounts.text = [NSString stringWithFormat:@"%.1f万", playCount];
    } else {
        self.playCounts.text = self.dataModel.play_count;
    }
    
    
    
    // 判断是否是个人中心
//    if (self.isMyPersonCenter) {
//        self.title.frame = CGRectMake(self.themeImage.left + 10 * WIDTH_NIT, self.themeImage.bottom + 17 * WIDTH_NIT, self.width - 18 * WIDTH_NIT - 13 * WIDTH_NIT - 5 * WIDTH_NIT, 16 * WIDTH_NIT);
//    } else {
//        self.title.frame = CGRectMake(self.themeImage.left + 10 * WIDTH_NIT, self.themeImage.bottom + 17 * WIDTH_NIT, self.width, 16 * WIDTH_NIT);
//    }
    
    // 判断播放数
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:12 * WIDTH_NIT],};
    CGSize textSize = [self.playCounts.text boundingRectWithSize:CGSizeMake(100, 100) options:NSStringDrawingTruncatesLastVisibleLine attributes:attributes context:nil].size;
//    self.playCounts.frame = CGRectMake(self.themeImage.right - textSize.width - 17 * WIDTH_NIT, self.playCounts.top, textSize.width, self.playCounts.height);
//    self.playCountsImage.frame = CGRectMake(self.playCounts.left - self.playCountsImage.width, self.playCountsImage.top, self.playCountsImage.width, self.playCountsImage.height);
    self.playCountMask.frame = CGRectMake(self.playCountMask.left, self.playCountMask.top, 6 * WIDTH_NIT + self.playCountsImage.width + textSize.width + 6 * WIDTH_NIT, self.playCountMask.height);
    
}

// 更多按钮方法
- (void)moreButtonAction:(UIButton *)sender {
    if (self.moreActionBlock) {
        self.moreActionBlock(self.dataModel.code, self.title.text);
    }
}

//将图片缩放到指定尺寸
-(UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize {
    UIGraphicsBeginImageContext(newSize);

    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];

    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();

    return newImage;
}



@end
