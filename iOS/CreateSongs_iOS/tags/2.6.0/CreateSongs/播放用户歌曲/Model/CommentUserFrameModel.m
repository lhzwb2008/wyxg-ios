//
//  CommentUserFrameModel.m
//  CreateSongs
//
//  Created by axg on 16/5/3.
//  Copyright © 2016年 AXG. All rights reserved.
//

#import "CommentUserFrameModel.h"
#import "AXGHeader.h"

@implementation CommentUserFrameModel


- (void)setCommentModel:(UserCommentsModel *)commentModel {
    _commentModel = commentModel;
    
    CGFloat leftPad = 16*WIDTH_NIT;
    CGFloat topPad = 15*WIDTH_NIT;
    CGFloat rightPad = 16;
    
    
    self.userHeadFrame = CGRectMake(leftPad + 21*WIDTH_NIT, topPad, 45*WIDTH_NIT, 45*WIDTH_NIT);
    self.userNameFrame = CGRectMake(15*WIDTH_NIT + self.userHeadFrame.origin.x + self.userHeadFrame.size.width, topPad + 2*WIDTH_NIT, 12 * 15, 12);
    
    CGSize createTimeWidth = [@"2000.00.00" getWidth:@"2000.00.00" andFont:NORML_FONT(10*WIDTH_NIT)];
    CGFloat timeW = createTimeWidth.width;
    
    self.timeLabelFrame = CGRectMake(SCREEN_W - timeW - rightPad, topPad, timeW, 12);
    
    
    CGSize contentSize = [self sizeWithString:_commentModel.content font:JIACU_FONT(12*WIDTH_NIT) maxSize:CGSizeMake(SCREEN_W - self.userNameFrame.origin.x - rightPad/2-11*WIDTH_NIT, MAXFLOAT)];
    self.userContentFrame = CGRectMake(self.userNameFrame.origin.x, self.userHeadFrame.origin.y + 22.5*WIDTH_NIT + 15*WIDTH_NIT, contentSize.width, contentSize.height);
    
    CGSize countSize = [@"99999" getWidth:@"99999" andFont:NORML_FONT(10*WIDTH_NIT)];
    
    self.upBtnFrame = CGRectMake(screenWidth()-rightPad-15*WIDTH_NIT-countSize.width-15*WIDTH_NIT, self.userContentFrame.size.height + self.userContentFrame.origin.y + 15*WIDTH_NIT, countSize.width + 15*WIDTH_NIT, 15*WIDTH_NIT);
    
    self.bgFrame = CGRectMake(leftPad, topPad + 22.5*WIDTH_NIT, SCREEN_W-leftPad-rightPad, contentSize.height + 15*WIDTH_NIT + 30*WIDTH_NIT + 6*WIDTH_NIT);
    
    self.cellHeight = self.bgFrame.origin.y + self.bgFrame.size.height;
}
/*  计算文本的高
 @param str   需要计算的文本
 @param font  文本显示的字体
 @param maxSize 文本显示的范围，可以理解为limit
 
 @return 文本占用的真实宽高
 */
-(CGSize)sizeWithString:(NSString *)str font:(UIFont *)font maxSize:(CGSize)maxSize {
    NSDictionary *dict = @{NSFontAttributeName : font};
    // 如果将来计算的文字的范围超出了指定的范围,返回的就是指定的范围
    // 如果将来计算的文字的范围小于指定的范围, 返回的就是真实的范围
    CGSize size = [str boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
    return size;
}

@end
