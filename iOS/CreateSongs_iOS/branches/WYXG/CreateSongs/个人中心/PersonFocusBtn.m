//
//  PersonFocusBtn.m
//  CreateSongs
//
//  Created by axg on 16/7/29.
//  Copyright © 2016年 AXG. All rights reserved.
//

#import "PersonFocusBtn.h"
#import "AXGHeader.h"

@implementation PersonFocusBtn

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if ([self.titleLabel.text isEqualToString:@"关注"]) {//12x12
        CGSize titleSize = [self.titleLabel.text getWidth:self.titleLabel.text andFont:self.titleLabel.font];
        
        self.titleLabel.centerX = self.width/2 + (titleSize.width)/2-3;
        
        self.titleLabel.centerY = self.height / 2;
        
        self.imageView.frame = CGRectMake(self.titleLabel.left - 5- 12, 0, 12, 12);
        
        self.imageView.centerY = self.height / 2;
    } else {
        self.titleLabel.centerX = self.width / 2;
        self.titleLabel.centerY = self.height / 2;
    }
}

@end
