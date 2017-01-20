//
//  TotalMsgButton.m
//  CreateSongs
//
//  Created by 爱写歌 on 16/8/23.
//  Copyright © 2016年 AXG. All rights reserved.
//

#import "TotalMsgButton.h"
#import "AXGHeader.h"

@implementation TotalMsgButton

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.imageView.frame = CGRectMake(16 * WIDTH_NIT, 15 * WIDTH_NIT, 25 * WIDTH_NIT, 25 * WIDTH_NIT);
    
    self.titleLabel.frame = CGRectMake(self.imageView.right + 15 * WIDTH_NIT, 0, self.width - self.imageView.right - 15 * WIDTH_NIT, self.height);
    self.titleLabel.font = JIACU_FONT(15);
    self.titleLabel.textAlignment = NSTextAlignmentLeft;
    [self setTitleColor:HexStringColor(@"#441D11") forState:UIControlStateNormal];
    
    self.backgroundColor = HexStringColor(@"#ffffff");
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
