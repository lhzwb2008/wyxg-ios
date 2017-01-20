//
//  PlayUserUpBtn.m
//  CreateSongs
//
//  Created by axg on 16/8/11.
//  Copyright © 2016年 AXG. All rights reserved.
//

#import "PlayUserUpBtn.h"
#import "AXGHeader.h"

@implementation PlayUserUpBtn

- (void)layoutSubviews {
    [super layoutSubviews];
    CGSize countSize = [@"9999" getWidth:@"9999" andFont:NORML_FONT(10*WIDTH_NIT)];
//    self.titleLabel.backgroundColor = [UIColor redColor];
    self.titleLabel.frame = CGRectMake(self.imageView.right, 0, countSize.width, countSize.height);
    self.titleLabel.centerY = self.imageView.centerY;
    self.titleLabel.textAlignment = NSTextAlignmentRight;
}

@end
