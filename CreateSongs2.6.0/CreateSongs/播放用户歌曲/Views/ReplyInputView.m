//
//  AXGDelegateClass.m
//  CreateSongs
//
//  Created by axg on 16/4/18.
//  Copyright © 2016年 AXG. All rights reserved.
//

#import "ReplyInputView.h"
#import "HeaderContent.h"
#import "AXGHeader.h"
#import "UIView+Common.h"
#import "UIColor+expanded.h"

#define GIFT_ALLOW  1

@interface ReplyInputView()<UITextViewDelegate, UITextFieldDelegate>


@end
@implementation ReplyInputView

- (id)initForumReply:(CGRect)frame andAboveView:(UIView *)bgView {
    self = [super initWithFrame:frame];
    if (self) {
        
        UITapGestureRecognizer *tapGer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(disappear)];
        [self.tapView addGestureRecognizer:tapGer];
        
        [self addReplyView1];
        
        [self addConstraint1];
    }
    return self;
}

-(id)initWithFrame:(CGRect)frame andAboveView:(UIView *)bgView
{
    self = [super initWithFrame:frame];
    if (self) {

        UITapGestureRecognizer *tapGer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(disappear)];
        [self.tapView addGestureRecognizer:tapGer];
        
        [self addReplyView];
        
        [self addConstraint];
    }
    return self;
}
#define replyTextHeight 40
//#define textViewWidth screenWidth - 80


-(void)addReplyView {
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectZero];
    bgView.backgroundColor = [UIColor colorWithHexString:@"#ffdc74"];
    bgView.layer.borderColor = [UIColor colorWithHexString:@"#ffdc74"].CGColor;
    bgView.layer.borderWidth = 0.1;
    bgView.layer.cornerRadius = 35*WIDTH_NIT/2;
    bgView.layer.masksToBounds = NO;
    [self addSubview:bgView];
    self.bgView = bgView;

    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectZero];   //框框不由textview显示，只是由来能够实现协议的方法
    textView.backgroundColor = [UIColor colorWithHexString:@"#ffdc74"];
    textView.returnKeyType = UIReturnKeySend;
    textView.keyboardType = UIKeyboardAppearanceDefault;
    textView.delegate = self;
    textView.layer.cornerRadius = 35*WIDTH_NIT/2;
    textView.layer.masksToBounds = NO;
    textView.tintColor = [UIColor colorWithHexString:@"#576d6d"];
    textView.textColor = [UIColor colorWithHexString:@"#451d11"];
    textView.font = JIACU_FONT(12);
    [self addSubview:textView];
    self.sendTextView = textView;
//    [self.sendTextView becomeFirstResponder];
    
    CGFloat textLeftPad = 16*WIDTH_NIT;
    
    CGFloat textPad = 35*WIDTH_NIT/2;
    CGFloat sendLeftPad = 8*WIDTH_NIT;
    CGFloat sendRightPad = 16*WIDTH_NIT;
    CGFloat sendHeight = 35*WIDTH_NIT;
    CGFloat sendWidht = 60*WIDTH_NIT;
    
    CGSize holderSize = [@"随手一发弹幕" getWidth:@"随手一发弹幕" andFont:NORML_FONT(12)];
    UILabel *lblPlaceholder = [[UILabel alloc] initWithFrame:CGRectMake(sendRightPad + sendLeftPad + sendWidht, padding*2+2, width(self) - textLeftPad - sendRightPad - sendLeftPad - sendWidht - sendRightPad + sendRightPad, holderSize.height)];
    lblPlaceholder.centerY = 25*WIDTH_NIT;
    lblPlaceholder.font = NORML_FONT(12);
    lblPlaceholder.text = @"随手一发弹幕";
    lblPlaceholder.textColor = [UIColor colorWithHexString:@"#451d11"];
    lblPlaceholder.backgroundColor = [UIColor clearColor];
    lblPlaceholder.textAlignment = NSTextAlignmentCenter;
//    lblPlaceholder.centerX = 16 + (width(self) - 32 - 8 - 60)/2;
    [self addSubview:lblPlaceholder];
    self.lblPlaceholder = lblPlaceholder;
    
    
    PlayUser_GIFT_BTN *giftButton = [PlayUser_GIFT_BTN buttonWithType:UIButtonTypeCustom];
    giftButton.frame = CGRectZero;
//    [giftButton setTitle:@"发射" forState:0];
    giftButton.titleLabel.font = JIACU_FONT(12);
    giftButton.clipsToBounds = YES;
    giftButton.layer.cornerRadius = 35/2;
    giftButton.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
    [giftButton setImage:[UIImage imageNamed:@"playUser礼物"] forState:UIControlStateNormal];
    giftButton.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin;
    [giftButton addTarget:self action:@selector(sendGiftAction:) forControlEvents:UIControlEventTouchUpInside];
    [giftButton setTitleColor:[UIColor colorWithHexString:@"#ffdc74"] forState:UIControlStateNormal];
    [self addSubview:giftButton];
    self.giftButton = giftButton;
    
    UIImageView *animatView = self.giftButton.imageView;
    
    [self rotation:animatView];
}

- (void)rotation:(UIImageView *)animatView {
    
    CGFloat time = 0.2f;
    
    CAKeyframeAnimation *keyAnima = [CAKeyframeAnimation animation];
    
    keyAnima.keyPath = @"transform.rotation";
    
    //(-M_PI_4 /90.0 * 5)表示-5度 。
    keyAnima.values = @[@(-M_PI_4 /90.0 * 5),@(M_PI_4 /90.0 * 5),@(-M_PI_4 /90.0 * 5)];
//    keyAnima.values = @[@1, @1.5, @1];
    
    keyAnima.removedOnCompletion = NO;

    keyAnima.fillMode = kCAFillModeForwards;

    keyAnima.duration = time;

    keyAnima.repeatCount = MAXFLOAT;
    

    [animatView.layer addAnimation:keyAnima forKey:nil];
}

- (void)sendGiftAction:(UIButton *)btn {
    NSLog(@"gift");
    if (self.sendGiftBlock) {
        self.sendGiftBlock();
    }
}

-(void)addConstraint {

    /**
     *  添加约束 使得高度变化时 高度跟随变化
     */
    
    CGFloat textLeftPad = 16*WIDTH_NIT;
    
    CGFloat textPad = 35*WIDTH_NIT/2;
    CGFloat sendLeftPad = 8*WIDTH_NIT;
    CGFloat sendRightPad = 16*WIDTH_NIT;
    CGFloat sendHeight = 35*WIDTH_NIT;
    CGFloat sendWidht = 60*WIDTH_NIT;

    CGFloat textBottolPad = self.height - padding*WIDTH_NIT - sendHeight;

    
    self.giftButton.translatesAutoresizingMaskIntoConstraints = NO;
    NSString *buttonStringH = [NSString stringWithFormat:@"H:|-(%f)-[_giftButton(%f)]",sendRightPad, sendWidht];
    NSString *buttonStringV = [NSString stringWithFormat:@"V:|-(%f)-[_giftButton(%f)]",padding*WIDTH_NIT,sendHeight];
    NSArray *sendButtonConstraintH = [NSLayoutConstraint constraintsWithVisualFormat:buttonStringH options:0 metrics:0 views:NSDictionaryOfVariableBindings(_giftButton)];
    [self addConstraints:sendButtonConstraintH];
    
    NSArray *sendButtonConstraintV = [NSLayoutConstraint constraintsWithVisualFormat:buttonStringV options:0 metrics:0 views:NSDictionaryOfVariableBindings(_giftButton)];
    [self addConstraints:sendButtonConstraintV];
    
    
    self.bgView.translatesAutoresizingMaskIntoConstraints = NO;
    NSString *bgStringH = [NSString stringWithFormat:@"H:[_bgView(%f)]-(%f)-|",width(self) - textLeftPad - sendRightPad - sendLeftPad - sendWidht,textLeftPad];
    NSString *bgStringV = [NSString stringWithFormat:@"V:|-(%f)-[_bgView]-(%f)-|",padding*WIDTH_NIT,textBottolPad];
    NSArray *bgTextViewConstraintH = [NSLayoutConstraint constraintsWithVisualFormat:bgStringH options:0 metrics:0 views:NSDictionaryOfVariableBindings(_bgView)];
    [self addConstraints:bgTextViewConstraintH];
    
    
    
    NSArray *bgTextViewConstraintV = [NSLayoutConstraint constraintsWithVisualFormat:bgStringV options:0 metrics:0 views:NSDictionaryOfVariableBindings(_bgView)];
    [self addConstraints:bgTextViewConstraintV];
    
    
    self.sendTextView.translatesAutoresizingMaskIntoConstraints = NO;
    NSString *sendStringH = [NSString stringWithFormat:@"H:[_sendTextView(%f)]-(%f)-|",width(self)- textLeftPad - sendRightPad - sendLeftPad - sendWidht - textPad * 2,textLeftPad + textPad];
    NSString *sendStringV = [NSString stringWithFormat:@"V:|-(%f)-[_sendTextView]-(%f)-|",padding*WIDTH_NIT,textBottolPad];
    NSArray *sendTextViewConstraintH = [NSLayoutConstraint constraintsWithVisualFormat:sendStringH options:0 metrics:0 views:NSDictionaryOfVariableBindings(_sendTextView)];
    [self addConstraints:sendTextViewConstraintH];
    
    NSArray *sendTextViewConstraintV = [NSLayoutConstraint constraintsWithVisualFormat:sendStringV options:0 metrics:0 views:NSDictionaryOfVariableBindings(_sendTextView)];
    [self addConstraints:sendTextViewConstraintV];

    
//    self.sendButton.translatesAutoresizingMaskIntoConstraints = NO;
//    NSString *buttonStringH = [NSString stringWithFormat:@"H:[_sendButton(%f)]-(%f)-|",sendWidht,sendRightPad];
//    NSString *buttonStringV = [NSString stringWithFormat:@"V:|-(%f)-[_sendButton(%f)]",padding*WIDTH_NIT,sendHeight];
//    NSArray *sendButtonConstraintH = [NSLayoutConstraint constraintsWithVisualFormat:buttonStringH options:0 metrics:0 views:NSDictionaryOfVariableBindings(_sendButton)];
//    [self addConstraints:sendButtonConstraintH];
//    
//    NSArray *sendButtonConstraintV = [NSLayoutConstraint constraintsWithVisualFormat:buttonStringV options:0 metrics:0 views:NSDictionaryOfVariableBindings(_sendButton)];
//    [self addConstraints:sendButtonConstraintV];
}

-(void)addReplyView1 {
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectZero];
    bgView.backgroundColor = [UIColor colorWithHexString:@"#ffdc74"];
    bgView.layer.borderColor = [UIColor colorWithHexString:@"#ffdc74"].CGColor;
    bgView.layer.borderWidth = 0.1;
    bgView.layer.cornerRadius = 35*WIDTH_NIT/2;
    bgView.layer.masksToBounds = NO;
    [self addSubview:bgView];
    self.bgView = bgView;
    
    //UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(10.0f, padding, textViewWidth, textViewHeight)];   //框框不由textview显示，只是由来能够实现协议的方法
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectZero];   //框框不由textview显示，只是由来能够实现协议的方法
    textView.backgroundColor = [UIColor colorWithHexString:@"#ffdc74"];
    textView.returnKeyType = UIReturnKeySend;
    textView.keyboardType = UIKeyboardAppearanceDefault;
    textView.delegate = self;
    //    textView.layer.borderColor = [UIColor colorWithHexString:@"#879999"].CGColor;
    //    textView.layer.borderWidth = 0.1;
    textView.layer.cornerRadius = 35*WIDTH_NIT/2;
    textView.layer.masksToBounds = NO;
    textView.tintColor = [UIColor colorWithHexString:@"#576d6d"];
    textView.textColor = [UIColor colorWithHexString:@"#451d11"];
    textView.font = JIACU_FONT(12);
    [self addSubview:textView];
    self.sendTextView = textView;
    //    [self.sendTextView becomeFirstResponder];
    
    
    CGSize holderSize = [@"随手一发弹幕" getWidth:@"随手一发弹幕" andFont:NORML_FONT(12)];
    UILabel *lblPlaceholder = [[UILabel alloc] initWithFrame:CGRectMake(13.0f + 18.0f, padding*2+2, 200, holderSize.height)];
    lblPlaceholder.centerY = 25*WIDTH_NIT;
    lblPlaceholder.font = NORML_FONT(12);
    lblPlaceholder.text = @"随手一发弹幕";
    lblPlaceholder.textColor = [UIColor colorWithHexString:@"#451d11"];
    lblPlaceholder.backgroundColor = [UIColor clearColor];
    lblPlaceholder.textAlignment = NSTextAlignmentCenter;
    lblPlaceholder.centerX = 16 + (width(self) - 32 - 8 - 60)/2;
    [self addSubview:lblPlaceholder];
    self.lblPlaceholder = lblPlaceholder;
    
    UIButton *sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
    sendButton.frame = CGRectZero;
    [sendButton setTitle:@"发射" forState:0];
    sendButton.titleLabel.font = JIACU_FONT(12);
    sendButton.clipsToBounds = YES;
    sendButton.layer.cornerRadius = 35/2;
    sendButton.backgroundColor = [UIColor colorWithHexString:@"#ffdc74"];
    //    [sendButton setBackgroundImage:[[UIImage imageNamed:@"buttonSend.png"] stretchableImageWithLeftCapWidth:3 topCapHeight:(replyTextHeight-2*padding-4)] forState:UIControlStateNormal];
    sendButton.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin;
    [sendButton addTarget:self action:@selector(sendButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    sendButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [sendButton setTitleColor:[UIColor colorWithHexString:@"#451d11"] forState:UIControlStateNormal];
    [self addSubview:sendButton];
    self.sendButton = sendButton;
}

-(void)addConstraint1 {
    
    /**
     *  添加约束 使得高度变化时 高度跟随变化
     */
    CGFloat textLeftPad = 16*WIDTH_NIT;
    
    CGFloat textPad = 35*WIDTH_NIT/2;
    CGFloat sendLeftPad = 8*WIDTH_NIT;
    CGFloat sendRightPad = 16*WIDTH_NIT;
    CGFloat sendHeight = 35*WIDTH_NIT;
    CGFloat sendWidht = 60*WIDTH_NIT;
    
    CGFloat textBottolPad = self.height - padding*WIDTH_NIT - sendHeight;
    
    self.bgView.translatesAutoresizingMaskIntoConstraints = NO;
    NSString *bgStringH = [NSString stringWithFormat:@"H:|-(%f)-[_bgView(%f)]",textLeftPad,width(self) - textLeftPad - sendRightPad - sendLeftPad - sendWidht];
    NSString *bgStringV = [NSString stringWithFormat:@"V:|-(%f)-[_bgView]-(%f)-|",padding*WIDTH_NIT,textBottolPad];
    NSArray *bgTextViewConstraintH = [NSLayoutConstraint constraintsWithVisualFormat:bgStringH options:0 metrics:0 views:NSDictionaryOfVariableBindings(_bgView)];
    [self addConstraints:bgTextViewConstraintH];
    
    NSArray *bgTextViewConstraintV = [NSLayoutConstraint constraintsWithVisualFormat:bgStringV options:0 metrics:0 views:NSDictionaryOfVariableBindings(_bgView)];
    [self addConstraints:bgTextViewConstraintV];
    
    
    self.sendTextView.translatesAutoresizingMaskIntoConstraints = NO;
    NSString *sendStringH = [NSString stringWithFormat:@"H:|-(%f)-[_sendTextView(%f)]",textLeftPad + textPad,width(self)- textLeftPad - sendRightPad - sendLeftPad - sendWidht - textPad * 2];
    NSString *sendStringV = [NSString stringWithFormat:@"V:|-(%f)-[_sendTextView]-(%f)-|",padding*WIDTH_NIT,textBottolPad];
    NSArray *sendTextViewConstraintH = [NSLayoutConstraint constraintsWithVisualFormat:sendStringH options:0 metrics:0 views:NSDictionaryOfVariableBindings(_sendTextView)];
    [self addConstraints:sendTextViewConstraintH];
    
    NSArray *sendTextViewConstraintV = [NSLayoutConstraint constraintsWithVisualFormat:sendStringV options:0 metrics:0 views:NSDictionaryOfVariableBindings(_sendTextView)];
    [self addConstraints:sendTextViewConstraintV];
    
    
    self.sendButton.translatesAutoresizingMaskIntoConstraints = NO;
    NSString *buttonStringH = [NSString stringWithFormat:@"H:[_sendButton(%f)]-(%f)-|",sendWidht,sendRightPad];
    NSString *buttonStringV = [NSString stringWithFormat:@"V:|-(%f)-[_sendButton(%f)]",padding*WIDTH_NIT,sendHeight];
    NSArray *sendButtonConstraintH = [NSLayoutConstraint constraintsWithVisualFormat:buttonStringH options:0 metrics:0 views:NSDictionaryOfVariableBindings(_sendButton)];
    [self addConstraints:sendButtonConstraintH];
    
    NSArray *sendButtonConstraintV = [NSLayoutConstraint constraintsWithVisualFormat:buttonStringV options:0 metrics:0 views:NSDictionaryOfVariableBindings(_sendButton)];
    [self addConstraints:sendButtonConstraintV];
}

-(void)sendButtonPressed {
    if ([self.sendTextView.text isEqualToString:@""]) {  //用户没有输入评价内容
        return;
    }
    self.replyBlock(self.sendTextView.text,self.replyTag);
    [self disappear];
}

-(void)disappear {
    [self.sendTextView resignFirstResponder];
}

-(void)setContentSizeBlock:(ContentSizeBlock)block {
    self.sizeBlock = block;
}

-(void)setReplyAddBlock:(replyAddBlock)block {
    self.replyBlock = block;
}

- (void)updateInputHeight {
    [self textViewDidChange:self.sendTextView];
}
#pragma mark - textview delegate

//- (void)textViewDidBeginEditing:(UITextView *)textView {
//    
//}

-(void)textViewDidChange:(UITextView *)textView {
    
    self.lblPlaceholder.hidden = (textView.text.length > 0);
    CGSize contentSize = self.sendTextView.contentSize;

    self.sizeBlock(contentSize);
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView {
    
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField.returnKeyType == UIReturnKeySend) {
        
    }
    return YES;
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if ([@"\n" isEqualToString:text] == YES) {
        if ([self.sendTextView.text isEqualToString:@""]) {  //没有输入内容
            return NO;
        }
        self.replyBlock(self.sendTextView.text,self.replyTag);
        [self disappear];
        
        return NO;
    }
    return YES;
}

@end
