//
//  GiftRankTableViewCell.m
//  CreateSongs
//
//  Created by 爱写歌 on 16/8/26.
//  Copyright © 2016年 AXG. All rights reserved.
//

#import "GiftRankTableViewCell.h"
#import "AXGHeader.h"
#import "XWAFNetworkTool.h"
#import "GiftUserModel.h"

@implementation GiftRankTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initCell];
    }
    return self;
}

- (void)initCell {
    
    self.contentView.backgroundColor = HexStringColor(@"#ffffff");
    
    self.emptyImage = [UIImageView new];
    [self.contentView addSubview:self.emptyImage];
    self.emptyImage.image = [UIImage imageNamed:@"礼物榜单占位符"];
    
    self.giftView = [UIImageView new];
    [self.contentView addSubview:self.giftView];
    self.giftView.backgroundColor = HexStringColor(@"#ffffff");
    
    self.giftHeadImage = [UIImageView new];
    self.giftHeadImage.image = [UIImage imageNamed:@"礼物榜0"];
    [self.giftView addSubview:self.giftHeadImage];
    
    self.totalGiftLabel = [UILabel new];
    [self.giftView addSubview:self.totalGiftLabel];
    self.totalGiftLabel.font = JIACU_FONT(10);
    self.totalGiftLabel.textColor = HexStringColor(@"#a0a0a0");
    self.totalGiftLabel.textAlignment = NSTextAlignmentCenter;
    
    self.giftRankArray = [[NSMutableArray alloc] initWithCapacity:0];
    self.buttonArray = [[NSMutableArray alloc] initWithCapacity:0];
    self.lableArray = [[NSMutableArray alloc] initWithCapacity:0];
    
    for (int i = 0; i < 4; i++) {
        UIImageView *headImage = [UIImageView new];
        [self.giftView addSubview:headImage];
        [self.giftRankArray addObject:headImage];
        
        UILabel *label = [UILabel new];
        label.font = JIACU_FONT(10);
        label.textColor = HexStringColor(@"#a0a0a0");
        label.textAlignment = NSTextAlignmentCenter;
        [self.giftView addSubview:label];
        [self.lableArray addObject:label];
        
    }
    
    for (int i = 0; i < 5; i++) {
        UIButton *button = [UIButton new];
        [self addSubview:button];
        [self.buttonArray addObject:button];
        button.tag = 100 + i;
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        button.backgroundColor = [UIColor clearColor];
    }
    
    self.goldImage = [UIImageView new];
    self.goldImage.image = [UIImage imageNamed:@"冠军icon"];
    self.silverImage = [UIImageView new];
    self.silverImage.image = [UIImage imageNamed:@"亚军icon"];
    self.tongImage = [UIImageView new];
    self.tongImage.image = [UIImage imageNamed:@"季军icon"];
    [self.giftView addSubview:self.goldImage];
    [self.giftView addSubview:self.silverImage];
    [self.giftView addSubview:self.tongImage];
    
    self.moreImage = [UIImageView new];
    [self.giftView addSubview:self.moreImage];
    self.moreImage.image = [UIImage imageNamed:@"礼物_更多"];
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.emptyImage.frame = CGRectMake(0, 0, 157 * WIDTH_NIT, 67.5 * WIDTH_NIT);
    self.emptyImage.center = CGPointMake(self.width / 2, self.height / 2);
    
    self.giftView.frame = self.bounds;
    
    self.giftHeadImage.frame = CGRectMake(16 * WIDTH_NIT, 25 * WIDTH_NIT, 45 * WIDTH_NIT, 45 * WIDTH_NIT);
    
    self.totalGiftLabel.frame = CGRectMake(self.giftHeadImage.left, self.giftHeadImage.bottom, self.giftHeadImage.width, 34 * WIDTH_NIT);
    
    self.goldImage.frame = CGRectMake(0, self.giftHeadImage.top - 14 * WIDTH_NIT, 15 * WIDTH_NIT, 14 * WIDTH_NIT);
    self.goldImage.center = CGPointMake(self.giftHeadImage.centerX + self.giftHeadImage.width + 20 * WIDTH_NIT, self.goldImage.centerY);
    
    self.silverImage.frame = CGRectMake(self.goldImage.left + self.giftHeadImage.width + 20 * WIDTH_NIT, self.goldImage.top, self.goldImage.width, self.goldImage.height);
    
    self.tongImage.frame = CGRectMake(self.silverImage.left + self.giftHeadImage.width + 20 * WIDTH_NIT, self.silverImage.top, self.silverImage.width, self.silverImage.height);
    
//    CGFloat radius = 29.5 * WIDTH_NIT;
    
    for (int i = 0; i < 4; i++) {
        UIImageView *headImage = self.giftRankArray[i];
        headImage.frame = CGRectMake(self.giftHeadImage.right + 20 * WIDTH_NIT + (20 * WIDTH_NIT + 45 * WIDTH_NIT) * i, self.giftHeadImage.top, self.giftHeadImage.width, self.giftHeadImage.height);
        headImage.layer.cornerRadius = headImage.width / 2;
        headImage.layer.masksToBounds = YES;
        
        UILabel *label = self.lableArray[i];
        label.frame = CGRectMake(headImage.left, headImage.bottom, headImage.width, 34 * WIDTH_NIT);
        
//        if (i == 0) {
//            
//            self.goldImage.transform = CGAffineTransformIdentity;
//            self.goldImage.transform = CGAffineTransformRotate(self.goldImage.transform, M_PI_4);
//            self.goldImage.center = CGPointMake(headImage.centerX + radius / 1.414, headImage.centerY - radius / 1.414);
//            
//        }
        
        
//        if (i == 0) {
//            
//            CGAffineTransform trans = [self GetCGAffineTransformRotateAroundPointWithCenterX:self.goldImage.centerX centerY:self.goldImage.centerY x:headImage.centerX y:headImage.centerY angle:M_PI_4];
//            self.goldImage.transform = CGAffineTransformIdentity;
//            self.goldImage.transform = trans;
//            
//        }
//        else if (i == 1) {
//            CGAffineTransform trans = [self GetCGAffineTransformRotateAroundPointWithCenterX:self.silverImage.centerX centerY:self.silverImage.centerY x:headImage.centerX y:headImage.centerY angle:M_PI_4];
//            self.silverImage.transform = CGAffineTransformIdentity;
//            self.silverImage.transform = trans;
//        } else if (i == 2) {
//            CGAffineTransform trans = [self GetCGAffineTransformRotateAroundPointWithCenterX:self.tongImage.centerX centerY:self.tongImage.centerY x:headImage.centerX y:headImage.centerY angle:M_PI_4];
//            self.tongImage.transform = CGAffineTransformIdentity;
//            self.tongImage.transform = trans;
//        }
        
        
    }
    
    for (int i = 0; i < 5; i++) {
        UIButton *button = self.buttonArray[i];
        button.frame = CGRectMake(self.giftHeadImage.right + 20 * WIDTH_NIT + (20 * WIDTH_NIT + 45 * WIDTH_NIT) * i, self.giftHeadImage.top, self.giftHeadImage.width, self.giftHeadImage.height);
    }
    
    self.moreImage.frame = CGRectMake(self.width - 16 * WIDTH_NIT - 12 * WIDTH_NIT, 0, 12 * WIDTH_NIT, 20 * WIDTH_NIT);
    self.moreImage.center = CGPointMake(self.moreImage.centerX, self.giftHeadImage.centerY);
    
}

// 旋转
- (CGAffineTransform)GetCGAffineTransformRotateAroundPointWithCenterX:(CGFloat)centerX centerY:(CGFloat)centerY x:(CGFloat)x y:(CGFloat)y angle:(CGFloat)angle {
    x = x - centerX; //计算(x,y)从(0,0)为原点的坐标系变换到(CenterX ，CenterY)为原点的坐标系下的坐标
    y = y - centerY; //(0，0)坐标系的右横轴、下竖轴是正轴,(CenterX,CenterY)坐标系的正轴也一样
    
    CGAffineTransform  trans = CGAffineTransformMakeTranslation(x, y);
    trans = CGAffineTransformRotate(trans,angle);
    trans = CGAffineTransformTranslate(trans,-x, -y);
    return trans;
}

- (void)setGiftDataSource:(NSArray *)giftDataSource {
    _giftDataSource = giftDataSource;
    
    NSInteger totalNum = 0;
    for (GiftUserModel *model in giftDataSource) {
        totalNum += [model.giftNumber integerValue];
    }
    self.totalGiftLabel.text = [NSString stringWithFormat:@"%ld", totalNum];
    
    if (giftDataSource.count >= 4) {
        for (int i = 0; i < 4; i++) {
            
            GiftUserModel *model = giftDataSource[i];
            
            UIImageView *headImage = self.giftRankArray[i];
            UILabel *label = self.lableArray[i];
            
            NSString *url = [NSString stringWithFormat:GET_USER_HEAD, [XWAFNetworkTool md5HexDigest:model.phone]];
            [headImage sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"头像"]];
            headImage.hidden = NO;
            
            label.text = model.giftNumber;
            label.hidden = headImage.hidden;
            
        }
        
//        if (giftDataSource.count == 4) {
//            self.moreImage.hidden = YES;
//        } else {
//            self.moreImage.hidden = NO;
//        }
        
        self.goldImage.hidden = NO;
        self.silverImage.hidden = NO;
        self.tongImage.hidden = NO;
        self.giftView.hidden = NO;
        
    } else if (giftDataSource.count == 3) {
        for (int i = 0; i < 4; i++) {
            UIImageView *headImage = self.giftRankArray[i];
            UILabel *label = self.lableArray[i];
            
            if (i < 3) {
                GiftUserModel *model = giftDataSource[i];
                NSString *url = [NSString stringWithFormat:GET_USER_HEAD, [XWAFNetworkTool md5HexDigest:model.phone]];
                [headImage sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"头像"]];
                headImage.hidden = NO;
                
                label.text = model.giftNumber;
                
            } else {
                headImage.hidden = YES;
            }
            
            label.hidden = headImage.hidden;
  
        }
        
//        self.moreImage.hidden = YES;
        self.goldImage.hidden = NO;
        self.silverImage.hidden = NO;
        self.tongImage.hidden = NO;
        self.giftView.hidden = NO;
        
    } else if (giftDataSource.count == 2) {
        for (int i = 0; i < 4; i++) {
            UIImageView *headImage = self.giftRankArray[i];
            UILabel *label = self.lableArray[i];
            
            if (i < 2) {
                GiftUserModel *model = giftDataSource[i];
                NSString *url = [NSString stringWithFormat:GET_USER_HEAD, [XWAFNetworkTool md5HexDigest:model.phone]];
                [headImage sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"头像"]];
                
                label.text = model.giftNumber;
                
                headImage.hidden = NO;
            } else {
                headImage.hidden = YES;
            }
            
            label.hidden = headImage.hidden;
            
        }
        
//        self.moreImage.hidden = YES;
        self.goldImage.hidden = NO;
        self.silverImage.hidden = NO;
        self.tongImage.hidden = YES;
        self.giftView.hidden = NO;
        
    } else if (giftDataSource.count == 1) {
        
        for (int i = 0; i < 4; i++) {
            UIImageView *headImage = self.giftRankArray[i];
            UILabel *label = self.lableArray[i];
            
            if (i < 1) {
                GiftUserModel *model = giftDataSource[i];
                NSString *url = [NSString stringWithFormat:GET_USER_HEAD, [XWAFNetworkTool md5HexDigest:model.phone]];
                [headImage sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"头像"]];
                
                label.text = model.giftNumber;
                
                headImage.hidden = NO;
            } else {
                headImage.hidden = YES;
            }
            
            label.hidden = headImage.hidden;
            
        }
        
//        self.moreImage.hidden = YES;
        self.goldImage.hidden = NO;
        self.silverImage.hidden = YES;
        self.tongImage.hidden = YES;
        self.giftView.hidden = NO;
        
    } else if (giftDataSource.count == 0) {
        
//        self.moreImage.hidden = YES;
        self.goldImage.hidden = YES;
        self.silverImage.hidden = YES;
        self.tongImage.hidden = YES;
        self.giftView.hidden = YES;
        
    }
    
}

// 按钮方法
- (void)buttonAction:(UIButton *)sender {
    
    NSLog(@"!!!!!!!!!!!!!!!!!!!!!!!!!%ld", sender.tag);
    
    switch (sender.tag - 100) {
        case 0: {
            if (self.giftDataSource.count >= 1) {
                
                GiftUserModel *model = self.giftDataSource[0];
                
                if (self.selectUserBlock) {
                    self.selectUserBlock(model.user_id);
                }
            }
        }
            break;
        case 1: {
            if (self.giftDataSource.count >= 2) {
                
                GiftUserModel *model = self.giftDataSource[1];
                
                if (self.selectUserBlock) {
                    self.selectUserBlock(model.user_id);
                }
            }
        }
            break;
        case 2: {
            if (self.giftDataSource.count >= 3) {
                
                GiftUserModel *model = self.giftDataSource[2];
                
                if (self.selectUserBlock) {
                    self.selectUserBlock(model.user_id);
                }
            }
        }
            break;
        case 3: {
            if (self.giftDataSource.count >= 4) {
                
                GiftUserModel *model = self.giftDataSource[3];
                
                if (self.selectUserBlock) {
                    self.selectUserBlock(model.user_id);
                }
            }
        }
            break;
        case 4: {
            if (self.giftDataSource.count > 0) {
            
                if (self.moreUserBlock) {
                    self.moreUserBlock();
                }
            }
        }
            break;
            
        default:
            break;
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
