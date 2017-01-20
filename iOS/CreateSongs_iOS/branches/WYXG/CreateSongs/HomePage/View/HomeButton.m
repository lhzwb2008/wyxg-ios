//
//  HomeButton.m
//  CreateSongs
//
//  Created by 爱写歌 on 16/8/8.
//  Copyright © 2016年 AXG. All rights reserved.
//

#import "HomeButton.h"
#import "AXGHeader.h"

@implementation HomeButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.imageView.frame = CGRectMake(0, 15 * WIDTH_NIT, 40 * WIDTH_NIT, 40 * WIDTH_NIT);
    self.imageView.center = CGPointMake(self.width / 2, self.imageView.centerY);
    self.imageView.layer.cornerRadius = self.imageView.width / 2;
    self.imageView.layer.masksToBounds = YES;
    
    self.titleLabel.frame = CGRectMake(self.imageView.left, self.imageView.bottom, self.imageView.width, 30 * WIDTH_NIT);
    self.titleLabel.font = ZHONGDENG_FONT(12);
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    
}


@end
