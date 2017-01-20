//
//  XieciTableViewCell.m
//  CreateSongs
//
//  Created by 爱写歌 on 16/4/27.
//  Copyright © 2016年 AXG. All rights reserved.
//

#import "XieciTableViewCell.h"
#import "InputTextView.h"
#import "AXGHeader.h"

@implementation XieciTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createCell];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.inputText.frame = CGRectMake(45.5 * WIDTH_NIT, 0, self.width - 91 * WIDTH_NIT, self.height);
    
    self.subImage.frame = CGRectMake(20 * WIDTH_NIT, 0, 15.5 * WIDTH_NIT, 15.5 * WIDTH_NIT);
    self.subImage.center = CGPointMake(self.subImage.centerX, self.height / 2);
    
    self.subButton.frame = CGRectMake(0, 0, 55.5 * WIDTH_NIT, self.height);
    
    self.addImage.frame = CGRectMake(self.width - 20 * WIDTH_NIT - 15.5 * WIDTH_NIT, 0, self.subImage.width, self.subImage.height);
    self.addImage.center = CGPointMake(self.addImage.centerX, self.subImage.centerY);
    
    self.addButton.frame = CGRectMake(self.width - 55.5 * WIDTH_NIT, 0, self.subButton.width, self.subButton.height);
}

- (void)createCell {

    self.inputText = [InputTextView new];
    [self addSubview:self.inputText];
    self.inputText.shouldHaveCharacters = NO;
    
    self.subImage = [UIImageView new];
    [self addSubview:self.subImage];
    self.subImage.image = [UIImage imageNamed:@"减号"];
    self.subImage.hidden = YES;
    self.subImage.contentMode = UIViewContentModeScaleAspectFit;
    
    self.subButton = [UIButton new];
    [self addSubview:self.subButton];
    self.subButton.enabled = NO;
    [self.subButton addTarget:self action:@selector(subButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    self.addImage = [UIImageView new];
    [self addSubview:self.addImage];
    self.addImage.image = [UIImage imageNamed:@"加号"];
    self.addImage.hidden = YES;
    self.addImage.contentMode = UIViewContentModeScaleAspectFit;
    
    self.addButton = [UIButton new];
    [self addSubview:self.addButton];
    self.addButton.enabled = NO;
    [self.addButton addTarget:self action:@selector(addButtonAction:) forControlEvents:UIControlEventTouchUpInside];
}

// 减号按钮方法
- (void)subButtonAction:(UIButton *)sender {
    
//    self.subImage.hidden = YES;
//    self.addImage.hidden = YES;
//    self.subButton.enabled = NO;
//    self.addButton.enabled = NO;
    
    self.subBlock();
}

// 加号按钮方法
- (void)addButtonAction:(UIButton *)sender {
    
//    self.subImage.hidden = YES;
//    self.addImage.hidden = YES;
//    self.subButton.enabled = NO;
//    self.addButton.enabled = NO;
    
    self.addBlock();
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
