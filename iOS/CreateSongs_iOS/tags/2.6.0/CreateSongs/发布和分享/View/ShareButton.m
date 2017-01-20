//
//  ShareButton.m
//  CreateSongs
//
//  Created by 爱写歌 on 16/8/9.
//  Copyright © 2016年 AXG. All rights reserved.
//

#import "ShareButton.h"
#import "AXGHeader.h"

@implementation ShareButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.imageView.frame = CGRectMake(0, 0, 50 * WIDTH_NIT, 50 * WIDTH_NIT);
    self.imageView.center = CGPointMake(self.width / 2, self.imageView.centerY);
    
    self.titleLabel.frame = CGRectMake(self.imageView.left - self.imageView.width * 0.25, self.imageView.bottom, self.imageView.width * 1.5, 24 * HEIGHT_NIT);
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.font = NORML_FONT(12 * WIDTH_NIT);
    [self setTitleColor:HexStringColor(@"#535353") forState:UIControlStateNormal];
    [self setTitleColor:HexStringColor(@"#576D6D") forState:UIControlStateHighlighted];
    
}

@end
