//
//  STBottomBtn.m
//  CreateSongs
//
//  Created by axg on 16/7/11.
//  Copyright © 2016年 AXG. All rights reserved.
//

#import "STBottomBtn.h"
#import "AXGHeader.h"

@implementation STBottomBtn

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


- (void)layoutSubviews {
    [super layoutSubviews];
    self.titleLabel.frame = CGRectMake(0, self.imageView.bottom+6*HEIGHT_NIT, self.width*2, 12*WIDTH_NIT);
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.center = CGPointMake(self.imageView.centerX, self.titleLabel.centerY);
}



@end
