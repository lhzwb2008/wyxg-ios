//
//  TYPopView.h
//  CreateSongs
//
//  Created by axg on 16/6/7.
//  Copyright © 2016年 AXG. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^PopSelectBlock)(NSInteger index);

@interface TYPopView : UIView

@property (nonatomic, assign) CGFloat cellHeight;

@property (nonatomic, copy) PopSelectBlock popSelect;


- (void)showLineWithNumber:(NSInteger)lineNumber;

- (void)changeSelectedIndex:(NSInteger)index;

@property (nonatomic, strong) NSArray *dataArray;

@end
