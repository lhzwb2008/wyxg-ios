//
//  CreateSongs.m
//  WriteLyricView
//
//  Created by axg on 16/4/22.
//  Copyright © 2016年 axg. All rights reserved.
//

#import "CreateSongs.h"


#define CELL_HEIGHT 38 * HEIGHT_NIT

@interface CreateSongs ()<UIScrollViewDelegate>

@end

@implementation CreateSongs

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.placeHolderTextArr = @[@"请输入第一句", @"请输入第二句", @"请输入第三句", @"请输入第四句", @"请输入第五句", @"请输入第六句", @"请输入第七句", @"请输入第八句", @"请输入第九句", @"请输入第十句", @"请输入第十一句", @"请输入第十二句", @"请输入第十三句", @"请输入第十四句", @"请输入第十五句", @"请输入第十六句"];
//        self.placeHolderTextArr = @[@"输入第一句输入第一句第一句", @"输入第二句输入第一句", @"输入第三句", @"输入", @"输入第五句输入第一句第一", @"输入第六句输入第一句第一句", @"输入第七句输入第一句第一句", @"输入第八句", @"输入第九句", @"输入第十句", @"输入第十一句", @"输入第十二句", @"输入第十三句", @"输入第十四句", @"输入第十五句", @"输入第十六句"];
//        self.placeHolderTextArr = @[@"输入歌词", @" ", @" ", @" ", @" ", @" ", @" ", @" ", @" ", @" ", @" ", @" ", @" ", @" ", @" ", @" "];
        self.lyricNumber = 4;
        
//        // 歌词高亮通知
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(highLightAction:) name:@"textFieldHighLight" object:nil];
//        
//        // 标题高亮通知
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(titleHighLight) name:@"titleHighLight" object:nil];
//        
//        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectedFormat:) name:@"selectedLyricFormat" object:nil];
        
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectedBlack) name:@"selectedBlack" object:nil];
        
        for (int i = 0; i < 16; i++) {
            [self.lyTextfArr addObject:@"x"];
        }
        
        [self createTableView];
        
    }
    return self;
}

- (void)resetLyricTextArray {
    [self.lyTextfArr removeAllObjects];
    
    for (int i = 0; i < 16; i++) {
        [self.lyTextfArr addObject:@"x"];
    }
}

- (void)selectedBlack {
    self.lyricNumber = 4;
    [self resetLyricTextArray];
    self.titleText.textField.text = @"";
    [self.tableView reloadData];
    [self.tableView setContentOffset:CGPointZero animated:YES];
}

- (void)selectedFormat:(NSNotification *)message {
    NSDictionary *dic = message.object;
    NSArray *lyricArray = dic[@"lyric"];
    NSString *lyricTitle = dic[@"title"];
    // 7 9 11 13 14 15
    NSLog(@"%lu", lyricArray.count);
    self.lyricNumber = lyricArray.count;
    
    [self.lyTextfArr removeAllObjects];
    [self.lyTextfArr addObjectsFromArray:lyricArray];

    if (self.lyricNumber == 16) {
        [self addButtonDisAppearAction];
    } else {
        [self addButtonAppearAction];
        for (NSInteger i = self.lyricNumber-1; i < 16; i++) {
            [self.lyTextfArr addObject:@"x"];
        }
    }
    
    
//    self.lyTextfArr = (NSMutableArray *)lyricArray;
    self.titleText.textField.text = lyricTitle;
    
    [self.tableView reloadData];
    
    [self.tableView setContentOffset:CGPointZero animated:YES];
}

- (void)createTableView {
    
    self.tableView = [[TPKeyboardAvoidingTableView alloc] initWithFrame:self.bounds style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.showsVerticalScrollIndicator = NO;
    [self addSubview:self.tableView];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.tableHeaderView = [self getHeadView];
//    self.tableView.tableFooterView = [self getFootView];
    [self.tableView registerClass:[XieciTableViewCell class] forCellReuseIdentifier:@"defaultIdentifier"];
}

- (UIView *)getHeadView {
    self.headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.width, 78 * HEIGHT_NIT)];
    self.headView.backgroundColor = [UIColor clearColor];
    
    self.titleText = [[InputTextView alloc] initWithFrame:CGRectMake(0, 20 * HEIGHT_NIT, self.tableView.width, 48 * HEIGHT_NIT)];
    [self.headView addSubview:self.titleText];
    self.titleText.textField.delegate = self;
    self.titleText.textField.textAlignment = NSTextAlignmentCenter;
    self.titleText.placeHolder = @"请输入歌名";
    self.titleText.index = 99;
    self.titleText.shouldHaveCharacters = YES;
    [self.titleText.textField setFont:JIACU_FONT(18)];
    
    self.titleText.textField.returnKeyType = UIReturnKeyNext;
    
    return self.headView;
}

//- (UIView *)getFootView {
//    self.footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, 35 * HEIGHT_NIT + 50 * WIDTH_NIT)];
//    self.footView.backgroundColor = [UIColor clearColor];
//    
//    UIButton *nextButton = [UIButton new];
//    [self.footView addSubview:nextButton];
//    nextButton.frame = CGRectMake(0, 0, 250 * WIDTH_NIT, 50 * WIDTH_NIT);
//    nextButton.center = CGPointMake(self.width / 2, self.footView.height - 35 * HEIGHT_NIT - 25 * WIDTH_NIT);
//    nextButton.backgroundColor = HexStringColor(@"#879999");
//    nextButton.layer.cornerRadius = nextButton.height / 2;
//    nextButton.layer.masksToBounds = YES;
//    nextButton.titleLabel.font = JIACU_FONT(18);
//    [nextButton setTitle:@"下一步" forState:UIControlStateNormal];
//    
//    return self.footView;
//}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.lyricNumber;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    XieciTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"defaultIdentifier"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor whiteColor];
    cell.inputText.textField.delegate = self;
    cell.inputText.placeHolder = self.placeHolderTextArr[indexPath.row];
    NSString *lrc = self.lyTextfArr[indexPath.row];
    
    cell.inputText.textField.text = lrc;
    
    if (indexPath.row == self.lyricNumber - 1) {
        cell.inputText.textField.returnKeyType = UIReturnKeyDone;
        cell.subImage.hidden = NO;
        cell.addImage.hidden = NO;
        cell.subButton.enabled = YES;
        cell.addButton.enabled = YES;
    } else {
        cell.inputText.textField.returnKeyType = UIReturnKeyNext;
        cell.subImage.hidden = YES;
        cell.addImage.hidden = YES;
        cell.subButton.enabled = NO;
        cell.addButton.enabled = NO;
    }
    
    WEAK_SELF;
    cell.addBlock = ^ () {
        STRONG_SELF;
        [self addButtonAction:nil];
    };
    
    cell.subBlock = ^ () {
        STRONG_SELF;
        [self subButtonAction:nil];
    };
    
    if ([lrc isEqualToString:@"x"]) {
        cell.inputText.textField.text = @"";
    } else {
        cell.inputText.textField.text = lrc;
    }
    
    cell.inputText.index = indexPath.row;
    [self.inputViewArray addObject:cell.inputText];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return CELL_HEIGHT;
}

// 添加按钮方法
- (void)addButtonAction:(UIButton *)sender {
    
    NSLog(@"---%ld", (long)self.lyricNumber);
    if (self.lyricNumber >= 16) {
        return;
    }
    
    // 16句消失
    if (self.lyricNumber == 12) {
        [self addButtonDisAppearAction];
    }
    if (self.lyricNumber == 2) {
        [self subButtonAppearAction];
    }
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.lyricNumber - 1 inSection:0];
    NSIndexPath *indexPath2 = [NSIndexPath indexPathForRow:self.lyricNumber inSection:0];
    NSIndexPath *indexPath4 = [NSIndexPath indexPathForRow:self.lyricNumber + 1 inSection:0];
    NSIndexPath *indexPath5 = [NSIndexPath indexPathForRow:self.lyricNumber + 2 inSection:0];
    
    if (self.lyricNumber == 2 || self.lyricNumber == 3 || self.lyricNumber == 4 || self.lyricNumber == 5) {
        
        self.lyricNumber = self.lyricNumber + 1;
        
        [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
    } else if (self.lyricNumber == 6 || self.lyricNumber == 8 || self.lyricNumber == 10) {
        self.lyricNumber = self.lyricNumber + 2;
        
        [self.tableView insertRowsAtIndexPaths:@[indexPath, indexPath2] withRowAnimation:UITableViewRowAnimationFade];

    } else {
        self.lyricNumber = self.lyricNumber + 4;
        
        [self.tableView insertRowsAtIndexPaths:@[indexPath, indexPath2, indexPath4, indexPath5] withRowAnimation:UITableViewRowAnimationFade];
        
    }
    
    [self.tableView reloadData];
    
    [self.delegate addLineDelegate];
    
    NSIndexPath *indexPath3 = [NSIndexPath indexPathForRow:self.lyricNumber - 1 inSection:0];
    [self.tableView scrollToRowAtIndexPath:indexPath3 atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
    
//    XieciTableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath3];
//    [cell.inputText.textField becomeFirstResponder];

}

// 减少按钮方法
- (void)subButtonAction:(UIButton *)sender {
    
    if (self.lyricNumber <= 2) {
        return;
    }
    
    // 2句时候按钮消失
    if (self.lyricNumber == 3) {
        [self subButtonDisappearAction];
    }
    if (self.lyricNumber == 16) {
        [self addButtonAppearAction];
    }
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.lyricNumber - 1 inSection:0];
    NSIndexPath *indexPath2 = [NSIndexPath indexPathForRow:self.lyricNumber - 2 inSection:0];
    NSIndexPath *indexPath3 = [NSIndexPath indexPathForRow:self.lyricNumber - 3 inSection:0];
    NSIndexPath *indexPath4 = [NSIndexPath indexPathForRow:self.lyricNumber - 4 inSection:0];
    
    if (self.lyricNumber == 16) {
        self.lyricNumber = self.lyricNumber - 4;
        [self.tableView deleteRowsAtIndexPaths:@[indexPath, indexPath2, indexPath3, indexPath4] withRowAnimation:UITableViewRowAnimationBottom];
    } else if (self.lyricNumber == 12 || self.lyricNumber == 10 || self.lyricNumber == 8) {
        self.lyricNumber = self.lyricNumber - 2;
        [self.tableView deleteRowsAtIndexPaths:@[indexPath, indexPath2] withRowAnimation:UITableViewRowAnimationBottom];
    } else {
        self.lyricNumber = self.lyricNumber - 1;
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationBottom];
    }

    [self.delegate subLineDelegate];
    
    [self.tableView reloadData];
    
}

// subButton disappear action
- (void)subButtonDisappearAction {
    
    WEAK_SELF;
    [UIView animateWithDuration:0.5 animations:^{
        STRONG_SELF;
        
        self.addButton.frame = CGRectMake(self.addButton.left, self.addButton.top, self.footView.width - 60 * WIDTH_NIT, self.addButton.height);
        
        self.subButton.frame = CGRectMake(self.subButton.left + self.addButton.width / 2, self.subButton.top, 0, self.subButton.height);
        
        self.subButton.alpha = 0;
        
    }];
}

// subButton appear action
- (void)subButtonAppearAction {
    
    WEAK_SELF;
    [UIView animateWithDuration:0.5 animations:^{
        STRONG_SELF;
        self.addButton.frame = CGRectMake(30 * WIDTH_NIT, 29, 123 * WIDTH_NIT, 43);
        
        self.subButton.frame = CGRectMake(self.footView.width - self.addButton.left - self.addButton.width, self.addButton.top, self.addButton.width, self.addButton.height);
        
        self.subButton.alpha = 1;
    }];
}

// addButton disappear action
- (void)addButtonDisAppearAction {
    WEAK_SELF;
    [UIView animateWithDuration:0.5 animations:^{
        STRONG_SELF;
        
        self.subButton.frame = CGRectMake(self.addButton.left, self.addButton.top, self.footView.width - 60 * WIDTH_NIT, self.addButton.height);
        
        self.addButton.frame = CGRectMake(self.addButton.left, self.addButton.top, 0, self.addButton.height);
        
        self.addButton.alpha = 0;
    }];
}

// addButton appear action
- (void)addButtonAppearAction {
    WEAK_SELF;
    [UIView animateWithDuration:0.5 animations:^{
        STRONG_SELF;
        self.addButton.frame = CGRectMake(30 * WIDTH_NIT, 29, 123 * WIDTH_NIT, 43);
        
        self.subButton.frame = CGRectMake(self.footView.width - self.addButton.left - self.addButton.width, self.addButton.top, self.addButton.width, self.addButton.height);
        
        self.addButton.alpha = 1;
    }];
}

#pragma mark - Action

- (void)nextStepButtonAction {
    
    [[UIResponder currentFirstResponder] resignFirstResponder];
    
    [self.delegate nextStepDelegate];
}

#pragma mark - TextFieldDelegate;
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if (textField == self.titleText.textField) {
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        XieciTableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        [cell.inputText.textField becomeFirstResponder];

    } else {
        
        InputTextView *inputView = (InputTextView *)textField.superview;
        NSInteger index = inputView.index;
        
        if (textField.returnKeyType == UIReturnKeyDone) {
            [[UIResponder currentFirstResponder] resignFirstResponder];
        } else {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index + 1 inSection:0];
            XieciTableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
            [cell.inputText.textField becomeFirstResponder];
        }
        
    }
    
    return YES;
}


- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    
    InputTextView *inputView = (InputTextView *)textField.superview;
    
    NSInteger index = inputView.index;
    
    NSLog(@"%ld", index);
    
    if (index < self.lyTextfArr.count) {
        
        if (textField.text.length == 0) {
            [self.lyTextfArr replaceObjectAtIndex:index withObject:@"x"];
        } else {
            [self.lyTextfArr replaceObjectAtIndex:index withObject:textField.text];
        }
    }
    
    return YES;
}


// 高亮提示

// 歌词高亮提示
- (void)highLightAction:(NSNotification *)message {
    NSString *str = message.object;
    NSInteger index = str.integerValue;
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
    
    XieciTableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    
    [self noticeBoth:cell.inputText];
    
}

// 标题高亮提示
- (void)titleHighLight {
    
    NSInteger index = 0;
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    
    [self noticeBoth:self.titleText];
    
}

-(void)noticeBoth:(InputTextView *)view{
    
    [[UIResponder currentFirstResponder] resignFirstResponder];
    
    view.lineLabel.backgroundColor = [UIColor clearColor];
    
    [UIView transitionWithView:view duration:0.1 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
    } completion:^(BOOL finished) {
        [UIView transitionWithView:view duration:1 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
            view.lineLabel.backgroundColor = [UIColor clearColor];
        } completion:nil];
    }];
}

- (NSMutableArray *)inputViewArray {
    if (_inputViewArray == nil) {
        _inputViewArray = [NSMutableArray array];
    }
    return _inputViewArray;
}

- (NSMutableArray *)lyTextfArr {
    if (_lyTextfArr == nil) {
        _lyTextfArr = [NSMutableArray array];
    }
    return _lyTextfArr;
}

@end
