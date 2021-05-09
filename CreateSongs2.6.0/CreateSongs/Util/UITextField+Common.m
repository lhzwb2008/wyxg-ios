//
//  UITextField+Common.m
//  CreateSongs
//
//  Created by axg on 16/8/1.
//  Copyright © 2016年 AXG. All rights reserved.
//

#import "UITextField+Common.h"
#import <UIKit/UIKit.h>

@implementation UITextField (Common)

- (NSRange)finalSelectedTextRange {
    UITextPosition* beginning = self.beginningOfDocument;
    
    UITextRange* selectedRange = self.selectedTextRange;
    UITextPosition* selectionStart = selectedRange.start;
    UITextPosition* selectionEnd = selectedRange.end;
    
    const NSInteger location = [self offsetFromPosition:beginning toPosition:selectionStart];
    const NSInteger length = [self offsetFromPosition:selectionStart toPosition:selectionEnd];
    ////http://139.129.131.20:8080/mosque/search
    return NSMakeRange(location, length);
}

@end
