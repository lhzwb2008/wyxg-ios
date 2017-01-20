
//
//  FormatPickView.m
//  CreateSongs
//
//  Created by axg on 16/6/30.
//  Copyright © 2016年 AXG. All rights reserved.
//

#import "FormatPickView.h"
#import "PickBtnView.h"
#import "AXGHeader.h"

@implementation FormatPickView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubViews];
    }
    return self;
}

- (void)initSubViews {
    
    self.bgScrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    self.bgScrollView.bounces = YES;
    self.bgScrollView.delegate = self;
    self.bgScrollView.backgroundColor = [UIColor whiteColor];
    self.bgScrollView.showsHorizontalScrollIndicator = NO;
    self.bgScrollView.showsVerticalScrollIndicator = NO;
    [self addSubview:self.bgScrollView];
    
    _btnWidth = self.bounds.size.width / 5;
    
    NSArray *btnTitles = @[@"空白", @"吐槽", @"祝福", @"唯美", @"表白"];
    
    self.movedBtnView = [PickBtnView new];
    self.movedBtnView.frame = CGRectMake(999, 0, _btnWidth, self.bounds.size.height);
    [self.bgScrollView addSubview:self.movedBtnView];
    
    for (NSInteger i = 0; i < 5; i++) {
        PickBtnView *btn = [PickBtnView new];
        btn.frame = CGRectMake(_btnWidth * (i + 2), 0, _btnWidth, self.bounds.size.height);
        btn.titleLabel.text = btnTitles[i];
        btn.index = i;
        WEAK_SELF;
        btn.formatBlock = ^(NSInteger index, PickBtnView *pickBtn) {
            STRONG_SELF;
            [self changeBtnStateCenterIndex:index withPickBtn:pickBtn];
        };
        [self.bgScrollView addSubview:btn];
        [self.btnArray addObject:btn];
    }
    PickBtnView *rightBtn = nil;
    PickBtnView *leftBtn = nil;
    for (NSInteger i = 0; i < 5; i++) {
        PickBtnView *btn = self.btnArray[i];

        if (i < 4) {
            rightBtn = self.btnArray[i+1];
        } else {
            rightBtn = nil;
        }
        
        if (i > 0) {
            leftBtn = self.btnArray[i-1];
        } else {
            leftBtn = nil;
        }
        btn.leftBtnView = leftBtn;
        btn.rightBtnView = rightBtn;
    }
    
    self.bgScrollView.contentSize = CGSizeMake(_btnWidth*(5 + 4), 0);
    self.bgScrollView.contentOffset = CGPointMake(_btnWidth*2, 0);
}

- (void)changeBtnStateCenterIndex:(NSInteger)index withPickBtn:(PickBtnView *)pickBtn{
    if (index < self.btnArray.count) {
        for (PickBtnView *btn in self.btnArray) {
            btn.lightLevel = 0;
        }
        
//        if (index > 2) {
//            [self moveToLeft:index];
//        } else if (index < 2) {
//            [self moveToRight:index];
//        }
        
        [self.bgScrollView setContentOffset:CGPointMake(_btnWidth * (index), 0) animated:YES];
        
        // 中心显示的btn
        PickBtnView *centerBtn = pickBtn;
        centerBtn.lightLevel = 2;
        if (pickBtn.leftBtnView != nil) {
            pickBtn.leftBtnView.lightLevel = 1;
        }
        if (pickBtn.rightBtnView != nil) {
            pickBtn.rightBtnView.lightLevel = 1;
        }
    }
}

// 选中的是右侧按钮  向左平移
- (void)moveToLeft:(NSInteger)index {
    
    CGFloat moveX = - _btnWidth;
    if (index == 3) {
        for (PickBtnView *btnView in self.btnArray) {
            [UIView animateWithDuration:0.1 animations:^{
                btnView.frame = CGRectMake(btnView.frame.origin.x + moveX, btnView.frame.origin.y, _btnWidth, self.bounds.size.height);
            } completion:^(BOOL finished) {
                btnView.index -= 1;
            }];
        }
    } else if (index == 4) {
        moveX = - _btnWidth * 2;
        for (PickBtnView *btnView in self.btnArray) {
            [UIView animateWithDuration:0.2 animations:^{
                btnView.frame = CGRectMake(btnView.frame.origin.x + moveX, btnView.frame.origin.y, _btnWidth, self.bounds.size.height);
                
            } completion:^(BOOL finished) {
                 btnView.index -= 2;
            }];
        }
    }
}

// 选中的是左侧按钮 向右平移
- (void)moveToRight:(NSInteger)index {
    CGFloat moveX =  _btnWidth;
    if (index == 1) {
        for (PickBtnView *btnView in self.btnArray) {
            [UIView animateWithDuration:0.1 animations:^{
                btnView.frame = CGRectMake(btnView.frame.origin.x + moveX, btnView.frame.origin.y, _btnWidth, self.bounds.size.height);
            } completion:^(BOOL finished) {
                btnView.index += 1;
            }];
        }
    } else if (index == 0) {
        moveX =  _btnWidth * 2;
        for (PickBtnView *btnView in self.btnArray) {
            [UIView animateWithDuration:0.2 animations:^{
                btnView.frame = CGRectMake(btnView.frame.origin.x + moveX, btnView.frame.origin.y, _btnWidth, self.bounds.size.height);
                
            } completion:^(BOOL finished) {
                btnView.index += 2;
            }];
        }
    }
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
}

- (NSMutableArray *)btnArray {
    if (_btnArray == nil) {
        _btnArray = [NSMutableArray array];
    }
    return _btnArray;
}


@end
