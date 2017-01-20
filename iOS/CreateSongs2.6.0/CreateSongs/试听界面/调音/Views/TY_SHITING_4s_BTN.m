//
//  TY_SHITING_4s_BTN.m
//  CreateSongs
//
//  Created by axg on 16/7/28.
//  Copyright © 2016年 AXG. All rights reserved.
//

#import "TY_SHITING_4s_BTN.h"
#import "AXGHeader.h"

@implementation TY_SHITING_4s_BTN

- (void)layoutSubviews {
    [super layoutSubviews];
    CGSize titleSize = [self.titleLabel.text getWidth:self.titleLabel.text andFont:self.titleLabel.font];
    
    self.imageView.frame = CGRectMake(0, 0, 27.5, 21.5);
    self.imageView.centerX = self.width / 2 - 27.5/2 - 7;
    self.imageView.centerY = self.height / 2;
    
    self.titleLabel.frame = CGRectMake(0, 0, titleSize.width, titleSize.height);
    self.titleLabel.centerX = self.width / 2 + titleSize.width / 2 + 7;
    self.titleLabel.centerY = self.height / 2;
}

@end
