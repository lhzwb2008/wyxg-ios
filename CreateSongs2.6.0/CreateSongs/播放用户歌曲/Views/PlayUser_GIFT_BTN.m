//
//  PlayUser_GIFT_BTN.m
//  CreateSongs
//
//  Created by axg on 16/8/16.
//  Copyright © 2016年 AXG. All rights reserved.
//

#import "PlayUser_GIFT_BTN.h"
#import "AXGHeader.h"

@implementation PlayUser_GIFT_BTN

- (void)layoutSubviews {
    [super layoutSubviews];
    self.imageView.frame = CGRectMake(0, 0, 25, 25);
    self.imageView.center = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2);
}

@end
