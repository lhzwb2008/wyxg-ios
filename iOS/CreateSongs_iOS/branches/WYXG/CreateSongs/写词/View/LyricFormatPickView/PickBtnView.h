//
//  PickBtnView.h
//  CreateSongs
//
//  Created by axg on 16/6/30.
//  Copyright © 2016年 AXG. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PickBtnView;

typedef void(^FormatBlock)(NSInteger index, PickBtnView *pickBtn);

@interface PickBtnView : UIView

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, assign) NSInteger index;

// 0 1 2  2表示高亮
@property (nonatomic, assign) NSInteger lightLevel;

@property (nonatomic, copy) FormatBlock formatBlock;

@property (nonatomic, strong) PickBtnView *leftBtnView;
@property (nonatomic, strong) PickBtnView *rightBtnView;

@end
