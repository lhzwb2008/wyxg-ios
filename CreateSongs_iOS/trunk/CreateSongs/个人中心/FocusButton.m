//
//  FocusButton.m
//  CreateSongs
//
//  Created by axg on 16/7/19.
//  Copyright © 2016年 AXG. All rights reserved.
//

#import "FocusButton.h"
#import "AXGHeader.h"

@implementation FocusButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)layoutSubviews {
    [super layoutSubviews];

    self.imageView.frame = CGRectMake(0, 11*HEIGHT_NIT, 25*WIDTH_NIT, 25*WIDTH_NIT);
    self.imageView.centerX = self.width / 2;
    
    self.titleLabel.frame = CGRectMake(0, self.imageView.bottom+4, 60, 10);
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.center = CGPointMake(self.imageView.centerX, self.titleLabel.centerY);
}


@end
