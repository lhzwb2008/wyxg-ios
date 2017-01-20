//
//  InputTextView.m
//  WriteLyricView
//
//  Created by axg on 16/4/22.
//  Copyright © 2016年 axg. All rights reserved.
//

#import "InputTextView.h"



@interface InputTextView ()

@end

@implementation InputTextView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self createToolBar];
        [self initSubViews];
    }
    return self;
}
/**
 *  自定义toolBar完成
 */
- (void)createToolBar {
    _topView = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, 44)];
    
    _topView.tintColor = [UIColor blackColor];
    
    [_topView setBarStyle:UIBarStyleDefault];
    
    UIBarButtonItem * button1 =[[UIBarButtonItem  alloc]initWithBarButtonSystemItem:                                        UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    
    UIBarButtonItem * button2 = [[UIBarButtonItem  alloc]initWithBarButtonSystemItem:                                        UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    //定义完成按钮
    UIBarButtonItem * doneButton = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStyleDone  target:self action:@selector(resignKeyboard)];
    
    NSArray * buttonsArray = [NSArray arrayWithObjects:button1,button2,doneButton,nil];
    [_topView setItems:buttonsArray];
}

-(void)resignKeyboard{
    [[UIResponder currentFirstResponder] resignFirstResponder];
}

- (void)setAlignment {
    self.textField.textAlignment = NSTextAlignmentCenter;
}

- (void)initSubViews {
    if (!_textField) {
        _textField = [UITextField new];
        _textField.delegate = self;
        [_textField setTextColor:HexStringColor(@"#535353")];
        [_textField setInputAccessoryView:_topView];
        [self setAlignment];
        
        if (self.shouldHaveCharacters) {
            [_textField setFont:JIACU_FONT(18)];
        } else {
            [_textField setFont:ZHONGDENG_FONT(18)];
        }

        [_textField addTarget:self action:@selector(editDidBegin:) forControlEvents:UIControlEventEditingDidBegin];
        [_textField addTarget:self action:@selector(textValueChanged:) forControlEvents:UIControlEventEditingChanged];
        [_textField addTarget:self action:@selector(editDidEnd:) forControlEvents:UIControlEventEditingDidEnd];
        [self addSubview:_textField];
        
        [[UITextField appearance] setTintColor:HexStringColor(@"#535353")];
    }
    if (!_lineLabel) {
        _lineLabel = [UILabel new];
        _lineLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:_lineLabel];
    }
    if (!_deleteBtn) {
        _deleteBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        _deleteBtn.backgroundColor = [UIColor clearColor];
        [_deleteBtn setImage:[UIImage imageNamed:@"lrcdelete@2x"] forState:UIControlStateNormal];
        [_deleteBtn addTarget:self action:@selector(deleteText:) forControlEvents:UIControlEventTouchUpInside];
        _textField.rightView = _deleteBtn;
    }
}

- (void)deleteText:(UIButton *)btn {
    _textField.text = @"";
    _textField.rightViewMode = UITextFieldViewModeNever;
}

- (void)setPlaceHolder:(NSString *)placeHolder {
    _placeHolder = placeHolder;
    
    if (self.shouldHaveCharacters) {
        self.textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:placeHolder attributes:@{NSForegroundColorAttributeName:HexStringColor(@"#a0a0a0"), NSFontAttributeName:JIACU_FONT(18)}];
    } else {
        self.textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:placeHolder attributes:@{NSForegroundColorAttributeName:HexStringColor(@"#a0a0a0"), NSFontAttributeName:ZHONGDENG_FONT(18)}];
    }
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _textField.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height - 2);
    _lineLabel.frame = CGRectMake(0, self.frame.size.height - 2, self.frame.size.width, 0.5);
    _deleteBtn.frame = CGRectMake(self.frame.size.width - (self.frame.size.height)/2, (self.frame.size.height)/2, (self.frame.size.height)/2, (self.frame.size.height)/2);
    _deleteBtn.center = CGPointMake(_deleteBtn.centerX, _textField.centerY);
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    if (!self.shouldHaveCharacters){
        NSArray *characters = @[@"A", @"a", @"B", @"b", @"C", @"c", @"D", @"d", @"E", @"e", @"F", @"f", @"G", @"g", @"H", @"h", @"I", @"i", @"J", @"j", @"K", @"k", @"L", @"l", @"M", @"m", @"N", @"n", @"O", @"o", @"P", @"p", @"Q", @"q", @"R", @"r", @"S", @"s", @"T", @"t", @"U", @"u", @"V", @"v", @"W", @"w", @"X", @"x", @"Y", @"y", @"Z", @"z", @" ",];
        for (NSString *str in characters) {
            _textField.text = [_textField.text stringByReplacingOccurrencesOfString:str withString:@""];
        }
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if (textField.returnKeyType == UIReturnKeyDone) {
        [[UIResponder currentFirstResponder] resignFirstResponder];
        return YES;
    }
    if (self.shouldReturnBlock) {
        self.shouldReturnBlock(self.index, self);
    }
    return YES;
}

- (void)editDidBegin:(id)sender {
    _textField.placeholderColor = [UIColor clearColor];
    self.lineLabel.backgroundColor = [UIColor clearColor];
    if (self.editDidBeginBlock) {
        self.editDidBeginBlock();
    }
    
    UITextField *textField = (UITextField *)sender;
    if( textField.text.length < 1) {
        textField.rightViewMode = UITextFieldViewModeNever;
    } else {
        textField.rightViewMode = UITextFieldViewModeWhileEditing;
    }
}

- (void)textValueChanged:(id)sender {
    UITextField *textField = (UITextField *)sender;
    NSString *text = textField.text;
    
    if( textField.text.length < 1) {
        textField.rightViewMode = UITextFieldViewModeNever;
    } else {
        textField.rightViewMode = UITextFieldViewModeWhileEditing;
    }
    
    if (self.shouldHaveCharacters) {
        if (textField.markedTextRange == Nil && text.length > 15) {
            textField.text = [text substringToIndex:15];
        }
        
//        textField.text = [textField.text removeEmojiString];
        
    }else{
        if (textField.markedTextRange == Nil) {
            NSString *temp = nil;
            NSMutableString *newText = [NSMutableString string];
            if (text.length > 13) {
                textField.text = [text substringToIndex:13];
            }
            for(int i = 0; i < [text length]; i++) {
                
                temp = [text substringWithRange:NSMakeRange(i, 1)];
                
                if ([temp isEqualToString:@"～"] && i != 0) {
                    [newText appendString:temp];
                } else {
                    NSString * regex = @"^[\u4e00-\u9fa5]$";
                    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
                    BOOL isMatch = [pred evaluateWithObject:temp];
                    if (isMatch == NO) {
                        
//                        if (textField.text.length > 0) {
//                            textField.text = [text substringToIndex:(textField.text.length - 1)];
//                        }
                        
                        textField.text = [textField.text stringByReplacingOccurrencesOfString:temp withString:@""];
                        
                        [MBProgressHUD showError:@"请输入中文"];
                        
                    } else {
                        [newText appendString:temp];
                    }
                }
            }
        }
    }
    if (self.textValueChangedBlock) {
        self.textValueChangedBlock(self.textField.text);
    }
}
- (void)editDidEnd:(id)sender {
    
    if (_textField.text.length == 0) {
        _textField.placeholderColor = HexStringColor(@"#a0a0a0");
    }
    self.lineLabel.backgroundColor = [UIColor clearColor];
    
    if (self.editDidEndBlock) {
        self.editDidEndBlock();
    }
}

@end
