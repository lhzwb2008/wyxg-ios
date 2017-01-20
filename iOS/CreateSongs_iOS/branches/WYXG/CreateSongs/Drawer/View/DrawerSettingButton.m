//
//  DrawerSettingButton.m
//  CreateSongs
//
//  Created by 爱写歌 on 16/8/11.
//  Copyright © 2016年 AXG. All rights reserved.
//

#import "DrawerSettingButton.h"
#import "AXGHeader.h"

@implementation DrawerSettingButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.imageView.frame = CGRectMake(self.width - 20 * WIDTH_NIT - 26 * WIDTH_NIT, 20 * WIDTH_NIT, 26 * WIDTH_NIT, 24.5 * WIDTH_NIT);
    
}

@end
