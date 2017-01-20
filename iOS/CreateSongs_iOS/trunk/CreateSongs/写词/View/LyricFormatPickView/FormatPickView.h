//
//  FormatPickView.h
//  CreateSongs
//
//  Created by axg on 16/6/30.
//  Copyright © 2016年 AXG. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PickBtnView;




@interface FormatPickView : UIView <UIScrollViewDelegate> {
    CGFloat _btnWidth;
}
@property (nonatomic, strong) UIScrollView *bgScrollView;

@property (nonatomic, strong) NSMutableArray *btnArray;

// 备用btnView 在移动的时候用到
@property (nonatomic, strong) PickBtnView *movedBtnView;



@end
