//
//  MsgButton.m
//  CreateSongs
//
//  Created by 爱写歌 on 16/8/23.
//  Copyright © 2016年 AXG. All rights reserved.
//

#import "MsgButton.h"
#import "AXGHeader.h"

@implementation MsgButton

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.imageView.frame = CGRectMake(15 * WIDTH_NIT, 15 * HEIGHT_NIT, self.width - 30 * WIDTH_NIT, self.height - 30 * HEIGHT_NIT);
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


@end
