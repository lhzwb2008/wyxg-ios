//
//  TYView.h
//  SentenceMidiChange
//
//  Created by axg on 16/5/9.
//  Copyright © 2016年 axg. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^TYLastBlock)();

typedef void(^TYNextBlock)();

@interface TYView : UIView

@property (nonatomic, strong) UIScrollView *tyScrollView;

@property (nonatomic, copy) TYLastBlock tyLastBlock;
@property (nonatomic, copy) TYNextBlock tyNextBlock;

- (void)showTyViewWithIndex:(NSInteger)index;

/**
 *  改变当前显示的调音视图
 *
 *  @param index 
 */
- (void)changeShowTyViewWithIndex:(NSInteger)index;

- (void)clickDoneBtn;

@end
