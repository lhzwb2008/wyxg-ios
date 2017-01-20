//
//  TianciTextView.m
//  CreateSongs
//
//  Created by axg on 16/8/1.
//  Copyright © 2016年 AXG. All rights reserved.
//

#import "TianciTextView.h"

@implementation TianciTextView

- (void)setAlignment {
    self.textField.textAlignment = NSTextAlignmentLeft;
}
- (void)textValueChanged:(id)sender {
    
    if (self.textValueChangedBlock) {
        self.textValueChangedBlock(self.textField.text);
    }
}
@end
