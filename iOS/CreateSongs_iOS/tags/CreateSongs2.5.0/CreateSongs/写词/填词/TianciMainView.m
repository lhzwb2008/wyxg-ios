//
//  TianciMainView.m
//  CreateSongs
//
//  Created by axg on 16/8/1.
//  Copyright © 2016年 AXG. All rights reserved.
//

#import "TianciMainView.h"
#import "TianciTableCell.h"
#import "TianciLyricModel.h"

/*
 发如雪-周杰伦
 
 狼牙月 伊人憔悴
 我举杯 饮尽了风雪
 是谁打翻前世柜 惹尘埃是非
 缘字诀 几番轮回
 你锁眉 哭红颜唤不回
 纵然青史已经成灰
 我爱不灭 繁华如三千东流水
 我只取一瓢爱了解 只恋你化身的蝶
 你发如雪 凄美了离别
 我焚香感动了谁
 邀明月 让回忆皎洁
 爱在月光下完美
 你发如雪 纷飞了眼泪
 我等待苍老了谁
 红尘醉 微醺的岁月
 我用无悔 刻永世爱你的碑
 你发如雪 凄美了离别
 我焚香感动了谁
 邀明月 让回忆皎洁
 爱在月光下完美
 你发如雪 纷飞了眼泪
 我等待苍老了谁
 红尘醉 微醺的岁月
 狼牙月 伊人憔悴
 我举杯 饮尽了风雪
 是谁打翻前世柜 惹尘埃是非
 缘字诀 几番轮回
 你锁眉 哭红颜唤不回
 纵然青史已经成灰
 我爱不灭 繁华如三千东流水
 我只取一瓢爱了解
 只恋你化身的蝶
 你发如雪 凄美了离别
 我焚香感动了谁
 邀明月 让回忆皎洁
 爱在月光下完美
 你发如雪 纷飞了眼泪
 我等待苍老了谁
 红尘醉 微醺的岁月
 我用无悔 刻永世爱你的碑
 你发如雪 凄美了离别
 我焚香感动了谁
 邀明月 让回忆皎洁
 爱在月光下完美
 你发如雪 纷飞了眼泪
 我等待苍老了谁
 红尘醉 微醺的岁月
 你发如雪 凄美了离别
 我焚香感动了谁
 邀明月 让回忆皎洁
 爱在月光下完美
 你发如雪 纷飞了眼泪
 我等待苍老了谁
 红尘醉 微醺的岁月
 我用无悔 刻永世爱你的碑
 啦儿啦 啦儿啦 啦儿啦儿啦
 啦儿啦 啦儿啦 啦儿啦儿啦
 铜镜映无邪 扎马尾
 你若撒野 今生我把酒奉陪
 啦儿啦 啦儿啦 啦儿啦儿啦	
 啦儿啦 啦儿啦 啦儿啦儿啦	
 铜镜映无邪 扎马尾	
 你若撒野 今生我把酒奉陪	

 */
@interface TianciMainView () <UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UIView *headView;


@property (nonatomic, strong) TPKeyboardAvoidingTableView *tableView;

@property (nonatomic, strong) NSMutableArray *cellArray;

@property (nonatomic, strong) UILabel *titleLeftLine;
@property (nonatomic, strong) UILabel *titleRightLine;

@end

@implementation TianciMainView

- (NSMutableArray *)cellArray {
    if (_cellArray == nil) {
        _cellArray = [NSMutableArray array];
    }
    return _cellArray;
}


- (NSMutableArray *)inputTextViewArray {
    if (_inputTextViewArray == nil) {
        _inputTextViewArray = [NSMutableArray array];
    }
    return _inputTextViewArray;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        [self createTianciTableView];
    }
    return self;
}

- (NSMutableArray *)textFieldTextArray {
    if (_textFieldTextArray == nil) {
        _textFieldTextArray = [NSMutableArray array];
    }
    return _textFieldTextArray;
}

- (void)setLyTextArray:(NSArray *)lyTextArray {
    _lyTextArray = lyTextArray;
    for (id object in _lyTextArray) {
        [self.textFieldTextArray addObject:@""];
    }
}

- (void)setLyricModelArray:(NSArray *)lyricModelArray {
    _lyricModelArray = lyricModelArray;
    if (_lyricModelArray != nil) {
        for (TianciLyricModel *model in _lyricModelArray) {
            NSInteger index = model.index;
            NSString *lyric = model.lyric;
            [self.textFieldTextArray replaceObjectAtIndex:index withObject:lyric];
        }
    }
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    [super willMoveToSuperview:newSuperview];
    
}

- (UIView *)getHeadView {
    
    
    self.titleLeftLine = [UILabel new];
    self.titleRightLine = [UILabel new];
    
    self.titleLeftLine.backgroundColor = [UIColor colorWithHexString:@"#a0a0a0"];
    self.titleRightLine.backgroundColor = [UIColor colorWithHexString:@"#a0a0a0"];
    
    
    CGSize titleSize = [@"歌名" getWidth:@"歌名" andFont:TECU_FONT(18*WIDTH_NIT)];
    
    self.headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.width, 35 * HEIGHT_NIT + titleSize.height)];
    self.headView.backgroundColor = [UIColor clearColor];
    
    self.titleText = [[InputTextView alloc] initWithFrame:CGRectMake(0, 35 * HEIGHT_NIT, self.tableView.width, titleSize.height)];
    WEAK_SELF;
    self.titleText.textValueChangedBlock = ^(NSString *value) {
        STRONG_SELF;
        [self changeTitleBottomLine:value];
    };
    [self.headView addSubview:self.titleText];
    self.titleText.textField.delegate = self;
    self.titleText.textField.textAlignment = NSTextAlignmentCenter;
    self.titleText.placeHolder = @"请输入歌名";
    self.titleText.index = 99;
    self.titleText.shouldHaveCharacters = YES;
    [self.titleText.textField setFont:TECU_FONT(18*WIDTH_NIT)];
    
    self.titleText.textField.returnKeyType = UIReturnKeyNext;

    CGSize titlePlaceSize = [self.titleText.placeHolder getWidth:self.titleText.placeHolder andFont:self.titleText.textField.font];
    
    self.titleRightLine.frame = CGRectMake(self.titleText.centerX, self.titleText.bottom, titlePlaceSize.width / 2, 1);
    self.titleLeftLine.frame = CGRectMake(self.titleRightLine.left - self.titleRightLine.width, self.titleRightLine.top, self.titleRightLine.width, self.titleRightLine.height);
    [self.headView addSubview:self.titleRightLine];
    [self.headView addSubview:self.titleLeftLine];
    
    return self.headView;
}

- (void)changeTitleBottomLine:(NSString *)value {
    CGSize titleSize = [self.titleText.textField.text getWidth:self.titleText.textField.text andFont:self.titleText.textField.font];
    CGSize titlePlaceSize = [@"请输入歌名" getWidth:@"请输入歌名" andFont:self.titleText.textField.font];
    
    if (titleSize.width < titlePlaceSize.width) {
        titleSize = titlePlaceSize;
    }
    CGRect frame2 = self.titleRightLine.frame;
    frame2.size.width = titleSize.width / 2;
    self.titleRightLine.frame = frame2;
    
    self.titleLeftLine.frame = CGRectMake(self.titleRightLine.left - self.titleRightLine.width, self.titleRightLine.top, self.titleRightLine.width, self.titleRightLine.height);
}

- (void)createTianciTableView {
    self.tableView = [[TPKeyboardAvoidingTableView alloc] initWithFrame:self.bounds style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.showsVerticalScrollIndicator = NO;
    [self addSubview:self.tableView];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.tableHeaderView = [self getHeadView];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *CellIdentifier = [NSString stringWithFormat:@"Cell%ld%ld", [indexPath section], [indexPath row]];
    TianciTableCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];//不再复用
    if (cell == nil) {
        cell = [[TianciTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        if (![self.textFieldTextArray[indexPath.row] isEqualToString:@""]) {
            cell.tianciInputText.textField.text = self.textFieldTextArray[indexPath.row];
        }
        cell.tianciLyric = self.lyTextArray[indexPath.row];
        [self.cellArray addObject:cell];
        [self.inputTextViewArray addObject:cell.tianciInputText];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];
    cell.tianciInputText.textField.delegate = self;
    if (indexPath.row == self.lyTextArray.count - 1) {
        cell.tianciInputText.textField.returnKeyType = UIReturnKeyDone;
    } else {
        cell.tianciInputText.textField.returnKeyType = UIReturnKeyNext;
    }
    cell.tianciInputText.index = indexPath.row;
    WEAK_SELF;
    cell.turnToNextField = ^(TianciTextView *currentTextView){
        STRONG_SELF;
        [self turnToNextTextField:currentTextView];
    };
    cell.checkLyricIsAllFull = ^{
        STRONG_SELF;
        [self checkAllLyricIsFull];
    };
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    TianciTableCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell.tianciInputText.textField becomeFirstResponder];
    NSLog(@"---%@", cell.tianciInputText.textField.text);
    
}

- (void)checkAllLyricIsFull {
    BOOL isFull = NO;
    self.fullLyricCount = 0;
    for (TianciTableCell *cell in self.cellArray) {
        if (cell.isFullLyric) {
            isFull = YES;
            self.fullLyricCount += 1;
        } else {
            isFull = NO;
        }
    }
    if (self.tianciShouldDone) {
        self.tianciShouldDone(isFull);
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CGSize lyricSize = [@"我是歌词" getWidth:@"我是歌词" andFont:ZHONGDENG_FONT(18*WIDTH_NIT)];
    return lyricSize.height * 2 + 35*HEIGHT_NIT + 15*HEIGHT_NIT;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.lyTextArray.count;
}

- (void)turnToNextTextField:(TianciTextView *)currentTextView {
    NSInteger index = currentTextView.index;
    if (index < self.lyTextArray.count-1) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index + 1 inSection:0];
        TianciTableCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        [cell.tianciInputText.textField becomeFirstResponder];
    } else if (index == self.lyTextArray.count-1) {
        [[UIResponder currentFirstResponder] resignFirstResponder];
    }
}

#pragma mark - TextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if (textField == self.titleText.textField) {
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        TianciTableCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        [cell.tianciInputText.textField becomeFirstResponder];
        
    } else {
        
        InputTextView *inputView = (InputTextView *)textField.superview;
        NSInteger index = inputView.index;
        
        if (textField.returnKeyType == UIReturnKeyDone) {
            [[UIResponder currentFirstResponder] resignFirstResponder];
        } else {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index + 1 inSection:0];
            TianciTableCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
            [cell.tianciInputText.textField becomeFirstResponder];
        }
    }
    return YES;
}


- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    
    return YES;
}
@end
