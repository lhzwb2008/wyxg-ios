//
//  TianciMainView.h
//  CreateSongs
//
//  Created by axg on 16/8/1.
//  Copyright © 2016年 AXG. All rights reserved.
//

#import "CreateSongs.h"

typedef void(^TianciShouldDone)(BOOL shouldDone);

@interface TianciMainView : UIView

@property (nonatomic, strong) NSMutableArray *inputTextViewArray;// 输入框父视图(TianciTextView)存放数组

@property (nonatomic, strong) NSArray *lyTextArray;// 模板歌词数组

@property (nonatomic, strong) InputTextView *titleText;

@property (nonatomic, copy) TianciShouldDone tianciShouldDone;

@property (nonatomic, assign) NSInteger fullLyricCount;

@property (nonatomic, strong) NSArray *lyricModelArray;

@property (nonatomic, strong) NSMutableArray *textFieldTextArray;

@end
