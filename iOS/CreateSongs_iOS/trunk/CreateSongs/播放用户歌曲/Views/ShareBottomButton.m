//
//  ShareBottomButton.m
//  CreateSongs
//
//  Created by 爱写歌 on 16/8/12.
//  Copyright © 2016年 AXG. All rights reserved.
//

#import "ShareBottomButton.h"
#import "AXGHeader.h"

@implementation ShareBottomButton

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, 0.5)];
    [self addSubview:self.lineView];
    self.lineView.backgroundColor = HexStringColor(@"#FFDC74");
    
}

- (void)setHighlighted:(BOOL)highlighted {
    [super setHighlighted:highlighted];
    if (highlighted) {
        self.lineView.backgroundColor = HexStringColor(@"#ffffff");
    } else {
        self.lineView.backgroundColor = HexStringColor(@"#FFDC74");
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
