//
//  LoveAndShareBtn.m
//  CreateSongs
//
//  Created by axg on 16/7/22.
//  Copyright © 2016年 AXG. All rights reserved.
//

#import "LoveAndShareBtn.h"
#import "AXGHeader.h"

@implementation LoveAndShareBtn

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.imageView.frame = CGRectMake(0, 0, 15*WIDTH_NIT, 15*WIDTH_NIT);
    self.imageView.centerX = self.width / 2;
    
    self.titleLabel.frame = CGRectMake(0, self.imageView.bottom+10, 60, 10);
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.center = CGPointMake(self.imageView.centerX, self.titleLabel.centerY);
}

@end
