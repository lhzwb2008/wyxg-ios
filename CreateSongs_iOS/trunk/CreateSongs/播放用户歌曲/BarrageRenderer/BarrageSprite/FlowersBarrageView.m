//
//  FlowersBarrageView.m
//  CreateSongs
//
//  Created by axg on 16/8/24.
//  Copyright © 2016年 AXG. All rights reserved.
//

#import "FlowersBarrageView.h"

@implementation FlowersBarrageView

- (instancetype)init {
    self = [super init];
    if (self) {
        
        self.bgView = [UILabel new];
        self.userNameLabel = [UILabel new];
        self.upCountLabel = [UILabel new];
        self.headImageView = [UIImageView new];
        self.textLabel = [UILabel new];
        
        self.bgView.backgroundColor = [[UIColor colorWithHexString:@"#000000"] colorWithAlphaComponent:0.7];
        self.bgView.clipsToBounds = YES;
        self.bgView.layer.cornerRadius = 30 / 2;
        
//        self.upCountLabel.clipsToBounds = YES;
//        self.upCountLabel.layer.cornerRadius = 30 / 2;
//        self.upCountLabel.backgroundColor = [UIColor colorWithHexString:@"#1b1b1b"];
//        self.upCountLabel.textColor = [UIColor colorWithHexString:@"#ffdc74"];
//        self.upCountLabel.font = [UIFont systemFontOfSize:15];
//        self.upCountLabel.textAlignment = NSTextAlignmentCenter;
        
        self.userNameLabel.font = [UIFont boldSystemFontOfSize:15];
        self.userNameLabel.textColor = [UIColor colorWithHexString:@"#ffdc74"];
        
        self.textLabel.font = [UIFont systemFontOfSize:15];
        self.textLabel.textColor = [UIColor colorWithHexString:@"#ffffff"];
        
        self.headImageView.backgroundColor = [UIColor clearColor];
        [self.headImageView zy_cornerRadiusRoundingRect];
        [self.headImageView zy_attachBorderWidth:1 color:[UIColor colorWithHexString:@"#ffffff"]];
        self.headImageView.image = [UIImage imageNamed:@"playUser头像"];
        
        [self addSubview:self.headImageView];
        [self addSubview:self.bgView];
        [self.bgView addSubview:self.userNameLabel];
        [self.bgView addSubview:self.textLabel];
//        [self.bgView addSubview:self.upCountLabel];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    
    CGSize nameSize = [self.userName getWidth:self.userName andFont:self.userNameLabel.font];
    CGSize textSize = [self.text getWidth:self.text andFont:self.textLabel.font];
    
    self.headImageView.frame = CGRectMake(0, 0, 45, 45);
    self.bgView.frame = CGRectMake(self.headImageView.right + 7, 0, self.width - self.headImageView.width - 7, 30);
    self.userNameLabel.frame = CGRectMake(13, 0, nameSize.width, nameSize.height);
    self.textLabel.frame = CGRectMake(self.userNameLabel.right + 3, 0, textSize.width, textSize.height);
//    self.upCountLabel.frame = CGRectMake(self.bgView.width-45, 0, 45, self.bgView.height);
    
    self.userNameLabel.centerY = self.bgView.height / 2;
    self.headImageView.centerY = self.height / 2;
    self.textLabel.centerY = self.bgView.height / 2;
    self.headImageView.centerY = self.bgView.height / 2;
}

@end
