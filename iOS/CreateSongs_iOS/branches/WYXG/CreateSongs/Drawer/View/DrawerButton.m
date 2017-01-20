//
//  DrawerButton.m
//  CreateSongs
//
//  Created by 爱写歌 on 16/8/8.
//  Copyright © 2016年 AXG. All rights reserved.
//

#import "DrawerButton.h"
#import "AXGHeader.h"

@implementation DrawerButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.imageView.frame = CGRectMake(19 * WIDTH_NIT, 0, 40 * WIDTH_NIT, 40 * WIDTH_NIT);
    self.imageView.center = CGPointMake(self.imageView.centerX, self.height / 2);
    self.imageView.layer.cornerRadius = self.imageView.width / 2;
    self.imageView.layer.masksToBounds = YES;
    
    self.titleLabel.frame = CGRectMake(self.imageView.right + 35 * WIDTH_NIT, self.imageView.top, self.width - self.imageView.right - 35 * WIDTH_NIT, self.imageView.height);
    self.titleLabel.textAlignment = NSTextAlignmentLeft;
    self.titleLabel.font = JIACU_FONT(15);
    [self setTitleColor:HexStringColor(@"#441D11") forState:UIControlStateSelected];
    [self setTitleColor:HexStringColor(@"#A0A0A0") forState:UIControlStateNormal];
    [self setTitleColor:HexStringColor(@"#535353") forState:UIControlStateHighlighted];
    
}

@end
