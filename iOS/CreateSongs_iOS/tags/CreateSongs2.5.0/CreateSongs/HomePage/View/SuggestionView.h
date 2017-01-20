//
//  SuggestionView.h
//  CreateSongs
//
//  Created by 爱写歌 on 16/3/8.
//  Copyright © 2016年 AXG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD+MJ.h"

@protocol SendSuggestionDelegate <NSObject>

- (void)sendMessageToByMail:(NSString *)content;

@end

@interface SuggestionView : UIView<UITextViewDelegate, UITextFieldDelegate>

@property (nonatomic, strong) UIImageView *bgImage;
@property (nonatomic, strong) UIButton *submitButton;
@property (nonatomic, strong) UITextView *feedback;
@property (nonatomic, strong) UILabel *placeholderText;
@property (nonatomic, strong) UITextField *contactText;
//@property (nonatomic, strong) UITextView *contact;
//@property (nonatomic, strong) UILabel *placeholderText2;

@property (nonatomic, weak) id<SendSuggestionDelegate> delegate;

@end
