//
//  ChatNavRightButton.m
//  CreateSongs
//
//  Created by 爱写歌 on 16/9/1.
//  Copyright © 2016年 AXG. All rights reserved.
//

#import "ChatNavRightButton.h"
#import "AXGHeader.h"

@implementation ChatNavRightButton

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.imageView.frame = CGRectMake(self.width - 27 - 16, 0, 27, 5);
    self.imageView.center = CGPointMake(self.imageView.centerX, 42);
    
    self.titleLabel.frame = CGRectMake(self.width - 100 * WIDTH_NIT - 16, 0, 100 * WIDTH_NIT, 30);
    self.titleLabel.center = CGPointMake(self.titleLabel.centerX, self.imageView.centerY);
    self.titleLabel.textAlignment = NSTextAlignmentRight;
    self.titleLabel.font = ZHONGDENG_FONT(15);
    
    [self setTitleColor:HexStringColor(@"#ffffff") forState:UIControlStateHighlighted];
    [self setTitleColor:HexStringColor(@"#441D11") forState:UIControlStateNormal];
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
