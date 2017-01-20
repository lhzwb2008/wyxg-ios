//
//  MYNoteView.m
//  CreateSongs
//
//  Created by axg on 16/9/19.
//  Copyright © 2016年 AXG. All rights reserved.
//

#import "MYNoteView.h"
#import "AXGHeader.h"
#import "TYHeader.h"

@implementation MYNoteView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.lyricLabel];
        [self addSubview:self.rightLine];
        
        self.lyricLabel.frame = CGRectMake(0, 0, 100, self.height);
        self.lyricLabel.centerX = self.width / 2;
        
        self.rightLine.frame = CGRectMake(self.width - 35, 0, 30, self.height);
        self.rightLine.centerY = self.height / 2;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
}

- (UILabel *)lyricLabel {
    if (_lyricLabel == nil) {
        _lyricLabel = [UILabel new];
        _lyricLabel.backgroundColor = [UIColor clearColor];
        _lyricLabel.textAlignment = NSTextAlignmentCenter;
        _lyricLabel.font = [UIFont systemFontOfSize:15*WIDTH_NIT];
        _lyricLabel.textColor = TY_NOTE_TEXT;
    }
    return _lyricLabel;
}

- (UILabel *)rightLine {
    if (_rightLine == nil) {
        _rightLine = [UILabel new];
        _rightLine.backgroundColor = [UIColor clearColor];
        _rightLine.text = @"|";
        _rightLine.textColor = [UIColor blackColor];
        _rightLine.font = [UIFont systemFontOfSize:5];
        _rightLine.textAlignment = NSTextAlignmentRight;
    }
    return _rightLine;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
