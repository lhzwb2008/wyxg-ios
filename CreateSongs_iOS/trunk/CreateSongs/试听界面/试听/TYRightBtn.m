//
//  TYRightBtn.m
//  CreateSongs
//
//  Created by axg on 16/6/22.
//  Copyright © 2016年 AXG. All rights reserved.
//

#import "TYRightBtn.h"
#import "Masonry.h"
#import "UIView+UIViewAdditions.h"

const CGFloat leftHeight = 16.5;
const CGFloat leftWidth = 10;
const CGFloat rightHeight = 16.5;
const CGFloat rightWidth = 10;
const CGFloat midleHeight = 3;

@interface TYRightBtn ()

@property (nonatomic, strong) UIImageView *leftImageView;
@property (nonatomic, strong) UIImageView *rightImageView;
@property (nonatomic, strong) UIImageView *midleImageView;

@end

@implementation TYRightBtn
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubViews];
    }
    return self;
}

- (void)initSubViews {
    [self.leftImageView setAutoresizingMask:UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin];
    [self.rightImageView setAutoresizingMask:UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin];
    [self.midleImageView setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    
    self.leftImageView.image = [UIImage imageNamed:@"tyleft"];
    self.rightImageView.image = [UIImage imageNamed:@"tyright"];
    self.midleImageView.image = [UIImage imageNamed:@"ty矩形"];
//    self.midleImageView.backgroundColor = [UIColor whiteColor];
    
    self.leftImageView.frame = CGRectMake(-1, 0, leftWidth, leftHeight);
    self.rightImageView.frame = CGRectMake(self.bounds.size.width - rightWidth + 1, 0, rightWidth, rightHeight);
    self.midleImageView.frame = CGRectMake(0, 0, self.bounds.size.width, midleHeight);
    
    self.leftImageView.center = CGPointMake(self.leftImageView.center.x, self.bounds.size.height / 2);
    self.rightImageView.center = CGPointMake(self.rightImageView.center.x, self.bounds.size.height / 2);
    self.midleImageView.center = CGPointMake(self.midleImageView.center.x, self.bounds.size.height / 2);
    
    [self addSubview:self.leftImageView];
    [self addSubview:self.rightImageView];
    [self addSubview:self.midleImageView];
    
//    [self.leftImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(self);
//        make.top.mas_equalTo((self.bounds.size.height - leftHeight) / 2);
//        make.size.mas_equalTo(CGSizeMake(leftWidth, leftHeight));
//    }];
//    [self.rightImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.mas_equalTo(self);
//        make.top.mas_equalTo((self.bounds.size.height - rightHeight) / 2);
//        make.size.mas_equalTo(CGSizeMake(rightWidth, rightHeight));
//    }];
}

- (void)layoutSubviews {
    [super layoutSubviews];
}

- (void)doubleWidth {
    self.shouldTap = NO;
    [UIView animateWithDuration:0.3 animations:^{
        self.midleImageView.transform = CGAffineTransformMakeScale(1.5, 1.0f);
        self.leftImageView.frame = CGRectMake(self.midleImageView.frame.origin.x - 1, self.leftImageView.frame.origin.y, self.leftImageView.frame.size.width, self.leftImageView.frame.size.height);
        self.rightImageView.frame = CGRectMake(self.midleImageView.width - self.rightImageView.width * 2 + 6, self.leftImageView.top, self.rightImageView.width, self.rightImageView.height);
    } completion:^(BOOL finished) {
        self.shouldTap = YES;
    }];
}

- (void)halfWidth {
    self.shouldTap = NO;
    [UIView animateWithDuration:0.3 animations:^{
        self.midleImageView.transform = CGAffineTransformIdentity;
        self.leftImageView.frame = CGRectMake(self.midleImageView.frame.origin.x - 1, self.leftImageView.frame.origin.y, self.leftImageView.frame.size.width, self.leftImageView.frame.size.height);
        self.rightImageView.frame = CGRectMake(self.midleImageView.width - self.rightImageView.width + 1, self.leftImageView.top, self.rightImageView.width, self.rightImageView.height);
    } completion:^(BOOL finished) {
        self.shouldTap = YES;
    }];
}

- (UIImageView *)leftImageView {
    if (_leftImageView == nil) {
        _leftImageView = [UIImageView new];
    }
    return _leftImageView;
}

- (UIImageView *)rightImageView {
    if (_rightImageView == nil) {
        _rightImageView = [UIImageView new];
    }
    return _rightImageView;
}
- (UIImageView *)midleImageView {
    if (_midleImageView == nil) {
        _midleImageView = [UIImageView new];
    }
    return _midleImageView;
}

@end
