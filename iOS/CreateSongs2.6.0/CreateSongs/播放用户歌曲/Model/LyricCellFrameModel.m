//
//  LyricCellFrameModel.m
//  CreateSongs
//
//  Created by axg on 16/5/4.
//  Copyright © 2016年 AXG. All rights reserved.
//

#import "LyricCellFrameModel.h"
#import "AXGHeader.h"

@implementation LyricCellFrameModel

- (void)setLyric:(NSString *)lyric {
    _lyric = lyric;
    
    CGFloat leftPad = 16;
    CGFloat topPad = 25*WIDTH_NIT;
    CGFloat padding = 10*WIDTH_NIT;
    
    CGSize titleSize = [@"歌曲" getWidth:@"歌曲" andFont:JIACU_FONT(15*WIDTH_NIT)];
    
    CGSize lyricSize = [@"歌词" getWidth:@"歌词" andFont:NORML_FONT(15*WIDTH_NIT)];
    
    self.songNameLabelFrame = CGRectMake(leftPad, topPad, SCREEN_W - leftPad*2, titleSize.height);
    
    self.lyricTitleFrame = CGRectZero;
    
    NSArray *array1 = [lyric componentsSeparatedByString:@":"];

    if (array1.count > 0) {
        
        self.songNameStr = [array1 firstObject];
        
        NSArray *array2 = [[array1 lastObject] componentsSeparatedByString:@","];
        
        for (NSInteger i = 0; i < array2.count; i++) {
            CGRect lyricR = CGRectMake(leftPad, CGRectGetMaxY(self.songNameLabelFrame) + 15*WIDTH_NIT + (padding + lyricSize.height) * i, self.songNameLabelFrame.size.width, lyricSize.height);
            self.cellHeight = CGRectGetMaxY(lyricR) + 40*WIDTH_NIT;
            
            if (array2.count < 4) {
                CGRect lyricNew = CGRectMake(leftPad, CGRectGetMaxY(self.songNameLabelFrame) + 15*WIDTH_NIT + padding + (padding + lyricSize.height) * 3, self.songNameLabelFrame.size.width, lyricSize.height);
                self.cellHeight = CGRectGetMaxY(lyricNew) + 40*WIDTH_NIT;
            }
            [self.lyricFrameArray addObject:NSStringFromCGRect(lyricR)];
            
            [self.lyricStrArray addObject:array2[i]];
        }
    }
    self.lineFrame = CGRectMake(0, self.cellHeight-0.5, SCREEN_W, 0.5);
}

- (NSMutableArray *)lyricFrameArray {
    if (_lyricFrameArray == nil) {
        _lyricFrameArray = [NSMutableArray array];
    }
    return _lyricFrameArray;
}

- (NSMutableArray *)lyricStrArray {
    if (_lyricStrArray == nil) {
        _lyricStrArray = [NSMutableArray array];
    }
    return _lyricStrArray;
}

@end
