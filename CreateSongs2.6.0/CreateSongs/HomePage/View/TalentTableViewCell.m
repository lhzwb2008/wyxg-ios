//
//  TalentTableViewCell.m
//  CreateSongs
//
//  Created by 爱写歌 on 16/7/14.
//  Copyright © 2016年 AXG. All rights reserved.
//

#import "TalentTableViewCell.h"
#import "AXGHeader.h"
#import "XWAFNetworkTool.h"
#import "AXGTools.h"
#import "SongModel.h"
#import "AXGCache.h"

@implementation TalentTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createCell];
    }
    return self;
}

- (void)createCell {
    
    self.backgroundColor = HexStringColor(@"#eeeeee");
    
    self.bgView = [UIView new];
    [self.contentView addSubview:self.bgView];
    self.bgView.backgroundColor = [UIColor whiteColor];
    
    self.headImage = [UIImageView new];
    [self.contentView addSubview:self.headImage];
//    self.headImage.backgroundColor = [UIColor redColor];
    
    self.nameLabel = [UILabel new];
    [self.contentView addSubview:self.nameLabel];
    [self.nameLabel setFont:TECU_FONT(12)];
    self.nameLabel.textColor = HexStringColor(@"#535353");
    
    self.genderImage = [UIImageView new];
    [self.contentView addSubview:self.genderImage];
    
    self.signatureLabel = [UILabel new];
    [self.contentView addSubview:self.signatureLabel];
    self.signatureLabel.numberOfLines = 2;
//    self.signatureLabel.lineBreakMode = NSLineBreakByClipping;
    self.signatureLabel.textColor = HexStringColor(@"#a0a0a0");
    self.signatureLabel.font = NORML_FONT(12);
    
//    self.workImage = [UIImageView new];
//    [self.contentView addSubview:self.workImage];
//    self.workImage.image = [UIImage imageNamed:@"作品集"];
//    
//    self.followImage = [UIImageView new];
//    [self.contentView addSubview:self.followImage];
//    self.followImage.image = [UIImage imageNamed:@"粉丝"];
//    
//    self.workLabel = [UILabel new];
//    [self.contentView addSubview:self.workLabel];
//    self.workLabel.textColor = HexStringColor(@"#a0a0a0");
//    self.workLabel.font = NORML_FONT(10);
//    
//    self.followLabel = [UILabel new];
//    [self.contentView addSubview:self.followLabel];
//    self.followLabel.textColor = HexStringColor(@"#a0a0a0");
//    self.followLabel.font = NORML_FONT(10);
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.bgView.frame = CGRectMake(16 * WIDTH_NIT, 22.5 * WIDTH_NIT, self.width - 32 * WIDTH_NIT, 80 * WIDTH_NIT);
    self.bgView.layer.cornerRadius = 5;
    self.bgView.layer.masksToBounds = YES;
    
    self.headImage.frame = CGRectMake(37 * WIDTH_NIT, 0, 45 * WIDTH_NIT, 45 * WIDTH_NIT);
    self.headImage.layer.cornerRadius = self.headImage.width / 2;
    self.headImage.layer.masksToBounds = YES;
    
    self.headImage.layer.borderColor = HexStringColor(@"#ffffff").CGColor;
    self.headImage.layer.borderWidth = 1.5;
    
    self.nameLabel.frame = CGRectMake(self.headImage.right + 16 * WIDTH_NIT, 0, 200, 22.5 * WIDTH_NIT);
    
    self.genderImage.frame = CGRectMake(self.nameLabel.right + 7 * WIDTH_NIT, 0, 12 * WIDTH_NIT, 12 * WIDTH_NIT);
    self.genderImage.center = CGPointMake(self.genderImage.centerX, self.nameLabel.centerY);
    
    self.signatureLabel.frame = CGRectMake(self.nameLabel.left, self.bgView.top + 20 * WIDTH_NIT, self.bgView.right - self.nameLabel.left - 12 * WIDTH_NIT, 40 * WIDTH_NIT);
//    self.signatureLabel.backgroundColor = [UIColor redColor];
    
//    self.workImage.frame = CGRectMake(self.width - 110, 0, 10.5 * WIDTH_NIT, 10.5 * WIDTH_NIT);
//    self.workImage.center = CGPointMake(self.workImage.centerX, self.bgView.bottom - 11.25 * WIDTH_NIT);
//    
//    self.workLabel.frame = CGRectMake(self.workImage.right + 5 * WIDTH_NIT, 0, 30 * WIDTH_NIT, 20 * WIDTH_NIT);
//    self.workLabel.center = CGPointMake(self.workLabel.centerX, self.workImage.centerY);
//    
//    self.followImage.frame = CGRectMake(self.workLabel.right, self.workImage.top, self.workImage.width, self.workImage.height);
//    
//    self.followLabel.frame = CGRectMake(self.followImage.right + 5 * WIDTH_NIT, self.workLabel.top, self.workLabel.width, self.workLabel.height);
    
    CGFloat width = [AXGTools getTextWidth:self.nameLabel.text font:self.nameLabel.font];
    self.genderImage.frame = CGRectMake(self.headImage.right + 16 * WIDTH_NIT + width + 7 * WIDTH_NIT, self.genderImage.top, self.genderImage.width, self.genderImage.height);
    
}

- (void)setModel:(SongModel *)model {
    _model = model;
    
    NSString *headUrl = [NSString stringWithFormat:GET_SONG_IMG, model.code];

    [self.headImage sd_setImageWithURL:[NSURL URLWithString:headUrl] placeholderImage:[UIImage imageNamed:@"头像"]];
    
    self.nameLabel.text = model.title;
    
    NSString *deCodeOriginalTitle = [model.original_title stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    if (deCodeOriginalTitle.length != 0) {
        self.nameLabel.text = [model.title stringByAppendingString:[NSString stringWithFormat:@"(原曲:%@)", deCodeOriginalTitle]];
    } else {
        self.nameLabel.text = model.title;
    }
    
    self.genderImage.image = [UIImage imageNamed:@"金词"];
    
//    NSString *url = [NSString stringWithFormat:HOME_LYRIC, model.code];
//    
//    WEAK_SELF;
    
    NSString *lyric = model.geci;
    
    lyric = [lyric stringByReplacingOccurrencesOfString:@"-" withString:@"～"];
    
    if (!(lyric.length > 0)) {
        return;
    }
    NSArray *array1 = [lyric componentsSeparatedByString:@":"];
    
    NSString *lyric1 = [array1 lastObject];
    
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:lyric1];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:10 * WIDTH_NIT];//调整行间距
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [lyric1 length])];
    self.signatureLabel.attributedText = attributedString;

    
//    if (url != nil && url.length > 0) {
//        
//        if ([AXGCache objectForKey:MD5Hash(url)]) {
//            
//            NSData *cacheData = [AXGCache objectForKey:MD5Hash(url)];
//            NSString *lyric = [[NSString alloc] initWithData:cacheData encoding:NSUTF8StringEncoding];
//            
//            lyric = [lyric stringByReplacingOccurrencesOfString:@"-" withString:@"～"];
//            
//            NSArray *array1 = [lyric componentsSeparatedByString:@":"];
//            
//            NSString *lyric1 = [array1 lastObject];
//            
//            NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:lyric1];
//            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
//            [paragraphStyle setLineSpacing:10 * WIDTH_NIT];//调整行间距
//            [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [lyric1 length])];
//            self.signatureLabel.attributedText = attributedString;
//            //                    [self.signatureLabel sizeToFit];
//            
//        } else {
//            
//            [XWAFNetworkTool getUrl:url body:nil response:XWData requestHeadFile:nil success:^(NSURLSessionDataTask *task, id resposeObject) {
//                STRONG_SELF;
//                
//                NSString *lyric = [[NSString alloc] initWithData:resposeObject encoding:NSUTF8StringEncoding];
//                
//                lyric = [lyric stringByReplacingOccurrencesOfString:@"-" withString:@"～"];
//                
//                NSArray *array1 = [lyric componentsSeparatedByString:@":"];
//                
//                NSString *lyric1 = [array1 lastObject];
//                
//                NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:lyric1];
//                NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
//                [paragraphStyle setLineSpacing:10 * WIDTH_NIT];//调整行间距
//                [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [lyric1 length])];
//                self.signatureLabel.attributedText = attributedString;
//                //                    [self.signatureLabel sizeToFit];
//                
//            } failure:^(NSURLSessionDataTask *task, NSError *error) {
//                NSLog(@"%@", error);
//            }];
//        }
//    }
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
