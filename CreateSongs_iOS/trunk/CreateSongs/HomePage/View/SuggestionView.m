//
//  SuggestionView.m
//  CreateSongs
//
//  Created by 爱写歌 on 16/3/8.
//  Copyright © 2016年 AXG. All rights reserved.
//

#import "SuggestionView.h"
#import "AXGHeader.h"
#import "MBProgressHUD+MJ.h"
#import "XWBaseMethod.h"
#import "KVNProgress.h"
#import <sys/utsname.h>
#import "AXGTools.h"

@interface SuggestionView ()


@end

@implementation SuggestionView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self createSuggestionView];
    }
    return self;
}

- (void)createSuggestionView {
    
    self.backgroundColor = HexStringColor(@"#eeeeee");
    
    UIView *bgView1 = [[UIView alloc] init];
    bgView1.backgroundColor = [UIColor whiteColor];
    [self addSubview:bgView1];
    
    if (kDevice_Is_iPad3 || kDevice_Is_iPad || kDevice_Is_iPhone4) {
        bgView1.frame = CGRectMake(0, 64, self.width, 100 * HEIGHT_NIT);
    } else {
        bgView1.frame = CGRectMake(0, 64, self.width, 125 * HEIGHT_NIT);
    }
    
    [[UITextField appearance] setTintColor:HexStringColor(@"#535353")];
    [[UITextView appearance] setTintColor:HexStringColor(@"#535353")];
    // 反馈文字
    self.feedback = [[UITextView alloc] initWithFrame:CGRectMake(30 * WIDTH_NIT, bgView1.top + 25 * HEIGHT_NIT, self.width - 60 * WIDTH_NIT, bgView1.height - 50 * HEIGHT_NIT)];
    self.feedback.backgroundColor = [UIColor clearColor];
    self.feedback.textColor = HexStringColor(@"#535353");
    self.feedback.font = JIACU_FONT(12);
    self.feedback.delegate = self;
    [self addSubview:self.feedback];
    self.feedback.returnKeyType = UIReturnKeyNext;
    
    self.placeholderText = [[UILabel alloc] initWithFrame:CGRectMake(self.feedback.left, self.feedback.top, self.feedback.width, 20)];
    [self addSubview:self.placeholderText];
    self.placeholderText.text = SUGEST_TXT;
    self.placeholderText.font = NORML_FONT(12);
    self.placeholderText.textColor = HexStringColor(@"#a0a0a0");
    
    // 联系方式背景
    UIView *bgView2 = [[UIView alloc] initWithFrame:CGRectMake(0, bgView1.bottom + 25 * HEIGHT_NIT, self.width, 40 * HEIGHT_NIT)];
    [self addSubview:bgView2];
    bgView2.backgroundColor = [UIColor whiteColor];
//    bgView2.alpha = 0.05;
    
    // 联系方式
    
    self.contactText = [[UITextField alloc] initWithFrame:CGRectMake(30 * WIDTH_NIT, bgView2.top, bgView2.width - 60 * WIDTH_NIT, bgView2.height)];
    self.contactText.textColor = HexStringColor(@"#535353");
    [self.contactText addTarget:self action:@selector(textDidChange:) forControlEvents:UIControlEventEditingChanged];
    self.contactText.returnKeyType = UIReturnKeyDone;
    [self addSubview:self.contactText];
    self.contactText.delegate = self;
    self.contactText.font = NORML_FONT(12);
    self.contactText.attributedPlaceholder = [[NSAttributedString alloc] initWithString:CONTECT_TXT attributes:@{
                                                                                                                               NSForegroundColorAttributeName: HexStringColor(@"#a0a0a0")
                                                                                                                               }];
    
    // 提交按钮
    
    self.submitButton = [UIButton new];
    self.submitButton.frame = CGRectMake(50 * WIDTH_NIT, self.height - 268 * HEIGHT_NIT - 40 * WIDTH_NIT, 315 * WIDTH_NIT, 40 * WIDTH_NIT);
    self.submitButton.center = CGPointMake(self.width / 2, self.submitButton.centerY);
    self.submitButton.enabled = NO;
    [self.submitButton addTarget:self action:@selector(finalButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.submitButton];
//    self.submitButton.backgroundColor = HexStringColor(@"#879999");
    [self.submitButton setBackgroundImage:[UIImage imageNamed:@"按钮背景色"] forState:UIControlStateNormal];
    [self.submitButton setBackgroundImage:[UIImage imageNamed:@"按钮背景色高亮"] forState:UIControlStateHighlighted];
    [self.submitButton setTitleColor:HexStringColor(@"#441D11") forState:UIControlStateNormal];
    [self.submitButton setTitleColor:HexStringColor(@"#ffffff") forState:UIControlStateHighlighted];
    [self.submitButton setTitle:@"提  交" forState:UIControlStateNormal];
    self.submitButton.titleLabel.font = JIACU_FONT(18);
    self.submitButton.layer.cornerRadius = self.submitButton.height / 2;
    self.submitButton.layer.masksToBounds = YES;
    
}

// 仿照站位文字
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {

    self.placeholderText.text = @"";

    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView {
    
//    if (textView == self.feedback) {
        if (self.feedback.text.length == 0) {
            self.placeholderText.text = SUGEST_TXT;
        } else {
            self.placeholderText.text = @"";
        }

    if (textView.returnKeyType == UIReturnKeyDone) {
        [[UIResponder currentFirstResponder] resignFirstResponder];
    }

    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    [self changeSubBtnState];
    if ([text isEqualToString:@"\n"]){ //判断输入的字是否是回车，即按下return
        
        //在这里做你响应return键的代码
        [self.contactText becomeFirstResponder];
        return NO;
    }
    return YES;
}

- (void)changeSubBtnState {
    if ([AXGTools getNumType:self.contactText.text] == isMail || [AXGTools getNumType:self.contactText.text] == isTel) {
        if (self.feedback.text.length > 0) {
            self.submitButton.enabled = YES;
        }
    } else {
        self.submitButton.enabled = NO;
    }
}

- (void)textDidChange:(id)sender {
    UITextField *textField = (UITextField *)sender;

    if( textField.text.length < 1) {
        textField.rightViewMode = UITextFieldViewModeNever;
    } else {
        textField.rightViewMode = UITextFieldViewModeWhileEditing;
    }
    if (textField == self.contactText) {

        [self changeSubBtnState];
    }
}

// 收回键盘
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [[UIResponder currentFirstResponder] resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [[UIResponder currentFirstResponder] resignFirstResponder];
    return YES;
}

/**
 *  按钮事件
 */
- (void)finalButtonAction:(UIButton *)sender {
    
    [UIView animateWithDuration:0.2 animations:^{
        self.submitButton.alpha = 1;
    }];
    
    if (![XWAFNetworkTool checkNetwork]) {
//        [MBProgressHUD showError:@"网络不给力"];
        [KVNProgress showErrorWithStatus:@"网络不给力"];
        return;
    }
    [XWBaseMethod showHUDAddedTo:self animated:YES];
    if (self.delegate && [self.delegate respondsToSelector:@selector(sendMessageToByMail:)]) {
        NSString *content = nil;
        
        // iOS版本信息
        NSString *systemVersion = [[UIDevice currentDevice] systemVersion];
        // 设备信息
        NSString *phoneName = [AXGTools deviceName];
        // APP版本
        NSString *appVersion = [NSString stringWithFormat:@"V %@", [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]];
        
        if (self.feedback.text.length > 0 && self.contactText.text.length > 0) {
            content = [NSString stringWithFormat:EMAIL_FORMAT, self.feedback.text, self.contactText.text, phoneName, systemVersion, appVersion];
        } else {
            content = [NSString stringWithFormat:EMAIL_FORMAT, self.placeholderText.text, self.contactText.placeholder, phoneName, systemVersion, appVersion];
        }
        
        NSLog(@"用户反馈信息：%@", content);
        
        [self.delegate sendMessageToByMail:content];
    }
    [[UIResponder currentFirstResponder] resignFirstResponder];
}

/**
 *  touch cancel
 */

- (void)buttonAction:(UIButton *)sender {
    
    [UIView animateWithDuration:0.2 animations:^{
        self.submitButton.alpha = 1;
    }];
}

// 提交按钮方法
- (void)submitButtonAction:(UIButton *)sender {
    [UIView animateWithDuration:0.2 animations:^{
        self.submitButton.alpha = 0.5;
    }];
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
