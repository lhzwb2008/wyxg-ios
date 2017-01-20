//
//  PersonInfoView.h
//  CreateSongs
//
//  Created by 爱写歌 on 16/4/23.
//  Copyright © 2016年 AXG. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    nickType,
    signatureType,
    weiboType,
    qqType,
    weChatType,
    schoolType,
} TextType;

@protocol PersonViewDelegate <NSObject>

- (void)backButtonDelegate;
- (void)selectGender;
- (void)selectHeadImage;
- (void)saveButtonDelegate;

@end

typedef void(^ShowMaskBlock)();

typedef void(^HideMaskBlock)();

@interface PersonInfoView : UIView<UITextFieldDelegate, UITextViewDelegate>

@property (nonatomic, assign) id<PersonViewDelegate>delegate;

@property (nonatomic, copy) NSString *accont;

@property (nonatomic, strong) UIButton *completeButton;

@property (nonatomic, strong) UIImageView *headImage;

@property (nonatomic, strong) UITextField *nickName;

@property (nonatomic, strong) UITextField *gender;

@property (nonatomic, strong) UITextField *birthTextField;

@property (nonatomic, strong) UITextView *signitureText;

@property (nonatomic, strong) UILabel *signiturePlaceholder;

@property (nonatomic, strong) UITextField *weiboText;

@property (nonatomic, strong) UITextField *QQText;

@property (nonatomic, strong) UITextField *weChatText;

@property (nonatomic, strong) UITextField *locationText;

@property (nonatomic, strong) UITextField *schoolOrCompanyText;

@property (nonatomic, strong) UIView *datePickView;

@property (nonatomic, strong) UIView *cityPickView;

@property (nonatomic, strong) UILabel *signitureLabel;

@property (nonatomic, strong) UIView *blockView1;

@property (nonatomic, strong) UIView *blockView2;

@property (nonatomic, strong) UIView *blockView3;

@property (nonatomic, assign) CGFloat originHeight;

@property (nonatomic, strong) UIView *maskView;

@property (nonatomic, strong) UIView *textEditView;

@property (nonatomic, strong) UILabel *editingTipsLabel;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UITextView *editTextField;

@property (nonatomic, strong) UILabel *placeholderLabel;

@property (nonatomic, strong) UIButton *editBtnConfirm;

@property (nonatomic, strong) UIButton *editBtnCancel;

@property (nonatomic, assign) TextType textType;

@property (nonatomic, strong) UIButton *signatureButton;

@property (nonatomic, assign) CGRect originRect;

@property (nonatomic, assign) CGRect startRect;

@property (nonatomic, assign) CGRect endRect;

@property (nonatomic, copy) ShowMaskBlock showMaskBlock;

@property (nonatomic, copy) HideMaskBlock hideMaskBlock;

@end
