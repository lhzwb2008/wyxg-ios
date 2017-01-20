//
//  AXGDeleAnimateCell.m
//  CreateSongs
//
//  Created by axg on 16/9/18.
//  Copyright © 2016年 AXG. All rights reserved.
//

#import "AXGDeleAnimateCell.h"
#import "YYImage.h"
#import "AXGHeader.h"


@interface AXGDeleAnimateCell ()

@property (nonatomic, strong) UIImageView *leftImageView;
@property (nonatomic, strong) UIImageView *rightImageView;

@end

@implementation AXGDeleAnimateCell


- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.leftImageView];
        [self addSubview:self.rightImageView];
    }
    return self;
}

#pragma mark - set

- (UIImageView *)leftImageView {
    if (_leftImageView == nil) {
        _leftImageView = [UIImageView new];
        _leftImageView.image = [YYImage imageNamed:@"引导_内容"];
        _leftImageView.frame = CGRectMake(0, 0, screenWidth(), self.height);
    }
    return _leftImageView;
}

- (UIImageView *)rightImageView {
    if (_rightImageView == nil) {
        _rightImageView = [UIImageView new];
        _rightImageView.image = [YYImage imageNamed:@"引导_草稿箱删除"];
        _rightImageView.frame = CGRectMake(screenWidth(), 0, 132 / 2 * WIDTH_NIT, self.height);
    }
    return _rightImageView;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
