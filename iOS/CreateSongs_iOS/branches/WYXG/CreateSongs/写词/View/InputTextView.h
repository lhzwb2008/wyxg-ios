//
//  InputTextView.h
//  WriteLyricView
//
//  Created by axg on 16/4/22.
//  Copyright © 2016年 axg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AXGHeader.h"
#import "UITextField+PlaceHolder.h"
#import "AppDelegate.h"
#import "MBProgressHUD+MJ.h"
#import "MBProgressHUD.h"
#import "NSString+Emojize.h"

@interface InputTextView : UIView<UITextFieldDelegate>

@property (nonatomic, strong) UILabel *lineLabel;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UIButton *deleteBtn;

@property (nonatomic,copy) void(^textValueChangedBlock)(NSString *);
@property (nonatomic,copy) void(^editDidBeginBlock)();
@property (nonatomic,copy) void(^editDidEndBlock)();
@property (nonatomic,copy) void(^shouldReturnBlock)(NSInteger,InputTextView *);

@property (nonatomic, copy) NSString *placeHolder;
/**
 *  键盘工具栏
 */
@property (nonatomic, strong) UIToolbar *topView;

@property (nonatomic, assign) BOOL shouldHaveCharacters;

@property (nonatomic, assign) NSInteger index;

@end
