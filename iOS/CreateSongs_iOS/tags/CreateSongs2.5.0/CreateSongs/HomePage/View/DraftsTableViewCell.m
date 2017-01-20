//
//  DraftsTableViewCell.m
//  CreateSongs
//
//  Created by 爱写歌 on 16/7/21.
//  Copyright © 2016年 AXG. All rights reserved.
//

#import "DraftsTableViewCell.h"
#import "AXGHeader.h"
#import "AXGTools.h"
#import "NSDictionary+Common.h"
#import "TianciDBFile.h"
#import "TianciLyricModel.h"

@implementation DraftsTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createCell];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.topLine.frame = CGRectMake(20 * WIDTH_NIT, 0, 0.5, 20 * WIDTH_NIT);
    
    self.diskImage.frame = CGRectMake(0, self.topLine.bottom, 25 * WIDTH_NIT, 25 * WIDTH_NIT);
    self.diskImage.center = CGPointMake(20 * WIDTH_NIT, self.diskImage.centerY);
    
    self.titleLabel.frame = CGRectMake(40 * WIDTH_NIT, self.diskImage.top, 200 * WIDTH_NIT, 25 * WIDTH_NIT);
    
    self.timeLabel.frame = CGRectMake(self.width - 100 * WIDTH_NIT - 16 * WIDTH_NIT, self.titleLabel.top, 100 * WIDTH_NIT, self.titleLabel.height);
    
    self.lineView.frame = CGRectMake(20 * WIDTH_NIT, self.diskImage.bottom, 0.5, self.height - self.diskImage.bottom);
    
    self.myContentView.frame = CGRectMake(self.titleLabel.left, self.lineView.top, 318 * WIDTH_NIT, 60 * WIDTH_NIT);
    
    self.horiLine.frame = CGRectMake(self.myContentView.left, self.height - 0.5, self.width - self.myContentView.left, 0.5);
    
    self.contentLabel.frame = CGRectMake(self.myContentView.left + 10 * WIDTH_NIT, self.myContentView.top, self.myContentView.width - 20 * WIDTH_NIT, self.myContentView.height);
    
}

- (void)createCell {
    
    self.backgroundColor = HexStringColor(@"#eeeeee");
    
    self.topLine = [UIView new];
    [self.contentView addSubview:self.topLine];
    self.topLine.backgroundColor = HexStringColor(@"#ffffff");
    
    self.diskImage = [UIImageView new];
    [self.contentView addSubview:self.diskImage];
    self.diskImage.image = [UIImage imageNamed:@"时间轴icon"];
    
    self.lineView = [UIView new];
    [self.contentView addSubview:self.lineView];
    self.lineView.backgroundColor = HexStringColor(@"#ffffff");
    
    self.titleLabel = [UILabel new];
    [self.contentView addSubview:self.titleLabel];
    self.titleLabel.font = JIACU_FONT(15);
    self.titleLabel.textColor = HexStringColor(@"#535353");
    
    self.timeLabel = [UILabel new];
    [self.contentView addSubview:self.timeLabel];
    self.timeLabel.font = NORML_FONT(12);
    self.timeLabel.textAlignment = NSTextAlignmentRight;
    self.timeLabel.textColor = HexStringColor(@"#535353");
    
    self.myContentView = [UIView new];
    [self.contentView addSubview:self.myContentView];
    self.myContentView.backgroundColor = HexStringColor(@"#ffffff");
    self.myContentView.layer.cornerRadius = 5 * WIDTH_NIT;
    self.myContentView.layer.masksToBounds = YES;
    
    self.contentLabel = [UILabel new];
    [self.contentView addSubview:self.contentLabel];
    self.contentLabel.textColor = HexStringColor(@"#A0A0A0");
    self.contentLabel.font = NORML_FONT(12);
    self.contentLabel.numberOfLines = 2;
    
    self.horiLine = [UIView new];
    [self.contentView addSubview:self.horiLine];
    self.horiLine.backgroundColor = HexStringColor(@"#451D11");
    
    self.xuanquModel = [XuanQuModel new];
    self.itemModel = [XuanquItemsModel new];
}

- (void)setDataSource:(NSDictionary *)dataSource {
//    if (!_dataSource) {
        _dataSource = dataSource;
//    }
    
    NSString *content = dataSource[@"content"];
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:content];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:6 * WIDTH_NIT];//调整行间距
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [content length])];
    self.contentLabel.attributedText = attributedString;
    [self.contentLabel sizeToFit];
    
    self.titleLabel.text = dataSource[@"title"];
//    self.timeLabel.text = [dataSource[@"saveTime"] substringToIndex:11];
    self.timeLabel.text = [AXGTools intervalSinceNow:dataSource[@"saveTime"]];
    self.saveTime = dataSource[@"saveTime"];
    self.lineNumber = [dataSource[@"line"] integerValue];
    
    /**
     @"tianciMidiData": MD5Hash([NSString stringWithFormat:@"%@%@", @"tianciMidiData", saveTime]),
     @"lyricDic":MD5Hash([NSString stringWithFormat:@"%@%@", @"lyricDic", saveTime]),
     @"lyricFormat": MD5Hash([NSString stringWithFormat:@"%@%@", @"lyricFormat", saveTime])

     */
    
    if ([dataSource haveKey:@"lyricDic"]) {
        NSData *lyricModelData = [TianciDBFile objectForKey:MD5Hash([NSString stringWithFormat:@"%@%@", @"lyricDic", self.saveTime])];
        NSDictionary *lyricDic = [NSJSONSerialization JSONObjectWithData:lyricModelData options:0 error:nil];
        NSArray *keys = [lyricDic allKeys];
        for (NSString *key in keys) {
            TianciLyricModel *model = [TianciLyricModel new];
            model.index = [key integerValue];
            model.lyric = [lyricDic objectForKey:key];
            [self.tianciLyricModelArr addObject:model];
        }
    }
    if ([dataSource haveKey:@"tianciMidiData"]) {
        
        NSData *midiData = [TianciDBFile objectForKey:MD5Hash([NSString stringWithFormat:@"%@%@", @"tianciMidiData", self.saveTime])];
        self.xuanquModel.midiData = midiData;
    }
    
    if ([dataSource haveKey:@"lyricFormat"]) {
        NSData *formatData = [TianciDBFile objectForKey:MD5Hash([NSString stringWithFormat:@"%@%@", @"lyricFormat", self.saveTime])];
        self.lyricFormat = [NSKeyedUnarchiver unarchiveObjectWithData:formatData];
    }
  
    if ([dataSource haveKey:@"characLocations"]) {
        NSData *characLocationData = [TianciDBFile objectForKey:MD5Hash([NSString stringWithFormat:@"%@%@", @"characLocations", self.saveTime])];
        self.characLocations = [NSKeyedUnarchiver unarchiveObjectWithData:characLocationData];
    }
    
    if ([dataSource haveKey:@"requestHeadName"]) {
        self.requestHeadName = dataSource[@"requestHeadName"];
    }

    if ([dataSource haveKey:@"acc_mp3"]) {
        self.acc_mp3 = dataSource[@"acc_mp3"];
    }
    if ([dataSource haveKey:@"zouyin_id"]) {
        self.zouyin_id = dataSource[@"zouyin_id"];
    }
    if ([dataSource haveKey:@"zouyin_singer"]) {
        self.zouyin_singer = dataSource[@"zouyin_singer"];
    }
    self.itemModel.acc_mp3 = self.acc_mp3;
    self.itemModel.id = self.zouyin_id;
    self.itemModel.singer = self.zouyin_singer;
    

    self.voice_songName = dataSource[@"title"];
    self.voice_DataSource = [dataSource[@"content"] componentsSeparatedByString:@","];
    self.voice_shareUrl = dataSource[@"shareUrl"];
    self.voice_mp3Url = dataSource[@"mp3Url"];
    self.voice_code = dataSource[@"code"];
    
    self.voice_banzouPath = [[TianciDBFile cacheDirectory] stringByAppendingPathComponent:dataSource[@"banzouPath"]];
    self.voice_recoderPath = [[TianciDBFile cacheDirectory] stringByAppendingPathComponent:dataSource[@"recoderPath"]];
}

- (NSMutableArray *)tianciLyricModelArr {
    if (_tianciLyricModelArr == nil) {
        _tianciLyricModelArr = [NSMutableArray array];
    }
    return _tianciLyricModelArr;
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
