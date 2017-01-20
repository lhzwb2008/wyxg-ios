//
//  XuanQuCell.m
//  CreateSongs
//
//  Created by axg on 16/8/2.
//  Copyright © 2016年 AXG. All rights reserved.
//

#import "XuanQuCell.h"
#import "AXGHeader.h"
#import "MidiParser.h"

static NSString *const xuanquIndentifier = @"xuanquIndentifier";

@interface XuanQuCell ()

@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) UIImageView *leftImageView;
//@property (nonatomic, strong) UILabel *titleLabel;



@end

@implementation XuanQuCell

//+ (instancetype)customXuanQuCellWithTableView:(UITableView *)tableView {
//    XuanQuCell *cell = [tableView dequeueReusableCellWithIdentifier:xuanquIndentifier];
//    if (cell == nil) {
//        cell = [[XuanQuCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:xuanquIndentifier];
//    }
//    return cell;
//}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initSubViews];
    }
    return self;
}

- (void)playBtnClick {
#if XUANQU_FROME_NET
    [XWAFNetworkTool getUrl:self.xuanQuModel.mid body:nil response:XWData requestHeadFile:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask *task, id resposeObjects) {
        if (self.beginPlayDemo) {
            MidiParser *parser1 = [MidiParser new];
            [parser1 configHeadZeroTime:resposeObjects];
            
            NSData *headData = parser1.headData;
            NSData *zeroData = parser1.zeroData;
            NSData *otherData = parser1.otherData;
            
            NSMutableData *finalData = [[NSMutableData alloc] init];
            
            [finalData appendData:headData];
            [finalData appendData:zeroData];
            [finalData appendData:otherData];
            [finalData appendData:zeroData];
            
            self.beginPlayDemo(self.xuanQuModel.mid, self.index);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
#elif !XUANQU_FROME_NET
    NSData *midiData = [[NSData alloc] initWithContentsOfFile:self.xuanQuModel.mid];
    if (self.beginPlayDemo) {
        self.beginPlayDemo(midiData, self.index);
    }
#endif
}

- (void)initSubViews {
    
    self.isPlay = NO;
    
    self.bgView = [UIView new];
    self.leftImageView = [UIImageView new];
    self.titleLabel = [UILabel new];
    self.rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.gifImage = [UIImageView new];
    
    self.bgView.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
    
    self.titleLabel.font = JIACU_FONT(15*WIDTH_NIT);
    self.titleLabel.text = @"怀旧·独特·最民族风";
    self.titleLabel.textColor = [UIColor colorWithHexString:@"#535353"];
    
    [self.rightBtn addTarget:self action:@selector(playBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    [self.rightBtn setImage:[UIImage imageNamed:@"选曲_试听"] forState:UIControlStateNormal];
    
    [self.contentView addSubview:self.bgView];
    [self.bgView addSubview:self.leftImageView];
    [self.bgView addSubview:self.titleLabel];
    [self.bgView addSubview:self.rightBtn];
    [self.bgView addSubview:self.gifImage];
    
    self.gifImage.hidden = YES;
}

// 开始动画
- (void)startAnimation {

    self.gifImage.hidden = NO;
    self.isPlay = YES;
    [self.rightBtn setImage:nil forState:UIControlStateNormal];
    NSArray *array = @[[UIImage imageNamed:@"选曲_试听1"], [UIImage imageNamed:@"选曲_试听2"], [UIImage imageNamed:@"选曲_试听"]];
    self.gifImage.animationImages = array;
    self.gifImage.animationDuration = 1;
    self.gifImage.animationRepeatCount = 100;
    [self.gifImage startAnimating];
}

// 结束动画
- (void)stopAnimation {
    
    self.isPlay = NO;
    [self.rightBtn setImage:[UIImage imageNamed:@"选曲_试听"] forState:UIControlStateNormal];
    [self.gifImage stopAnimating];
    [self.gifImage setAnimationImages:nil];
    self.gifImage.hidden = YES;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.bgView.frame = CGRectMake(5*WIDTH_NIT, 5*WIDTH_NIT, self.contentView.width - 10*WIDTH_NIT, self.contentView.height-5*WIDTH_NIT);
    self.leftImageView.frame = CGRectMake(25*WIDTH_NIT, 0, 31*WIDTH_NIT, 30*WIDTH_NIT);
    self.leftImageView.centerY = self.bgView.centerY;
    
    CGSize titleSize = [self.titleLabel.text getWidth:self.titleLabel.text andFont:self.titleLabel.font];
    self.titleLabel.frame = CGRectMake(self.leftImageView.right + 25*WIDTH_NIT, 0, titleSize.width, titleSize.height);
    self.titleLabel.centerY = self.bgView.centerY;
    
    self.rightBtn.frame = CGRectMake(self.bgView.width - 100*WIDTH_NIT, 0, 50*WIDTH_NIT, 50*WIDTH_NIT);
    self.rightBtn.centerY = self.bgView.centerY;
    
    self.gifImage.frame = self.rightBtn.frame;
    
    if (self.isPlay) {
        [self startAnimation];
    } else {
        [self stopAnimation];
    }
}

- (void)setXuanQuModel:(XuanquItemsModel *)xuanQuModel {
    _xuanQuModel = xuanQuModel;

    self.leftImageView.image = [UIImage imageNamed:@"选曲icon"];

    self.titleLabel.text = _xuanQuModel.name;
}

@end
