//
//  CreateSongs.h
//  WriteLyricView
//
//  Created by axg on 16/4/22.
//  Copyright © 2016年 axg. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "TPKeyboardAvoidingScrollView.h"
#import "TPKeyboardAvoidingTableView.h"
#import "InputTextView.h"
#import "UIResponder+FirstResponder.h"
#import "AXGHeader.h"
#import "XieciTableViewCell.h"
#import <QuartzCore/QuartzCore.h>
#import "TPKeyboardAvoidingScrollView.h"
/**
 歌词行数类型
 */
typedef enum : NSUInteger {
    lyricFour,
    lyricEight,
} LYRIC_LINE;

@protocol AddCreateSongDelegate <NSObject>

- (void)addLineDelegate;
- (void)subLineDelegate;
- (void)nextStepDelegate;

@end

@interface CreateSongs : UIView<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>

@property (nonatomic, assign) CGFloat oldSecondBgY;
@property (nonatomic, assign) CGFloat oldSecondBgH;

@property (nonatomic, assign) CGFloat oldScrollH;
/**
 *  行数
 */
@property (nonatomic, assign) LYRIC_LINE lyric_line;

//@property (nonatomic, strong) TPKeyboardAvoidingScrollView *textScrollView;

@property (nonatomic, assign) id<AddCreateSongDelegate>delegate;

@property (nonatomic, strong) TPKeyboardAvoidingTableView *tableView;

@property (nonatomic, strong) UIView *headView;

@property (nonatomic, strong) UIView *footView;

@property (nonatomic, strong) UIButton *addButton;

@property (nonatomic, strong) UIButton *subButton;

@property (nonatomic, strong) CAShapeLayer *borderLayer;
@property (nonatomic, strong) CAShapeLayer *borderLayer2;

@property (nonatomic, strong) NSMutableArray *inputViewArray;

@property (nonatomic, strong) UIImageView *bgImageView1;
@property (nonatomic, strong) UIImageView *bgImageView2;

@property (nonatomic, assign) CGFloat bgImageView2Height;
@property (nonatomic, assign) CGFloat bgViewHeight;

@property (nonatomic, strong) InputTextView *titleText;
@property (nonatomic, strong) NSMutableArray *lyTextfArr;
@property (nonatomic, copy) NSString *songName;
@property (nonatomic, strong) NSArray *placeHolderTextArr;

@property (nonatomic, assign) NSInteger lyricNumber;
@property (nonatomic, strong) NSMutableArray *textFieldArrary;

@property (nonatomic, strong) TPKeyboardAvoidingScrollView *xieciScroll;

@property (nonatomic, strong) UIView *bottomView;

@property (nonatomic, assign) BOOL keyBoradShow;

@property (nonatomic, assign) CGSize originSize;

@property (nonatomic, assign) CGPoint originOffset;

@property (nonatomic, assign) CGRect originBottomFrame;

- (void)createTableView;

@end
