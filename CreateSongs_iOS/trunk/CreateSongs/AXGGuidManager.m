//
//  AXGGuidManager.m
//  CreateSongs
//
//  Created by axg on 16/9/18.
//  Copyright © 2016年 AXG. All rights reserved.
//

#import "AXGGuidManager.h"
#import "AXGHeader.h"
#import "YYImage.h"
#import "AXGBlingView.h"
#import "NoteView.h"
#import "AXGDeleAnimateCell.h"
#import "AXGRadarView.h"
#import "MYNoteView.h"

@interface AXGGuidManager () {
    NSInteger moveCount;
}


@property (nonatomic, strong) UIView *homeFatherView;


@property (nonatomic, strong) UIView *draftsFatherView;


@property (nonatomic, strong) UIView *tyFatherView;

@property (nonatomic, strong) AXGBlingView *blingView;

@property (nonatomic, assign) BOOL tyGuidIsShowed;

@property (nonatomic, strong) MYNoteView *tyNoteView;
@property (nonatomic, strong) UIImageView *tyRightImage;
@property (nonatomic, strong) UIImageView *tyRightUpDownImage;

@end

@implementation AXGGuidManager

XLSingletonM(AXGGuidManager)

#pragma mark - class method

+ (void)showHomeGuidUnderView:(UIView *)view {
    [[AXGGuidManager sharedAXGGuidManager] showHomeUnderView:view];
}

+ (void)showDraftsGuidUnderView:(UIView *)view {
    [[AXGGuidManager sharedAXGGuidManager] showDraftsUnderView:view];
}

+ (void)showTYGuidUnderView:(UIView *)view {
    [[AXGGuidManager sharedAXGGuidManager] showTYUnderView:view];
}

#pragma mark - method

- (void)showHomeUnderView:(UIView *)view {
    self.homeFatherView = view;
    self.homeGuidView.alpha = 1.0f;
    [self addMyView:self.homeGuidView toSuperView:view];
    
//    AXGRadarView *rader = [[AXGRadarView alloc] initWithFrame:CGRectMake(0, 0, view.width/2, view.height/2)];
//    rader.center = view.center;
//    [self.homeGuidView addSubview:rader];
    [self.homeGuidView addSubview:self.blingView];
}

- (void)showDraftsUnderView:(UIView *)view {
    self.draftsFatherView = view;
    self.draftsGuidView.alpha = 1.0f;
    [view addSubview:self.draftsGuidView];
//    [self addMyView:self.draftsGuidView toSuperView:view];
}

- (void)showTYUnderView:(UIView *)view {
    self.tyFatherView = view;
    self.tyGuidView.alpha = 1.0f;
    [view addSubview:self.tyGuidView];
    [view bringSubviewToFront:self.tyGuidView];
//    [self addMyView:self.tyGuidView toSuperView:view];
}

#pragma mark - common

- (void)addMyView:(UIView *)view toSuperView:(UIView *)superView{
    if (superView) {
        UIView *fatherView = superView.superview;
        [fatherView addSubview:view];
        [fatherView bringSubviewToFront:superView];
    } else {
        [kKeyWindow addSubview:view];
    }
}


#pragma mark - get

- (UIView *)homeGuidView {
    if (_homeGuidView == nil) {
        _homeGuidView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth(), screehHeight())];
        _homeGuidView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.91];
        UIImageView *guidImage = [UIImageView new];
        guidImage.image = [YYImage imageNamed:@"点击图标·开始创作"];
        CGFloat guidImageHeight = 249/2*WIDTH_NIT;
        CGFloat guidImageWidth = 591/2*WIDTH_NIT;
        CGFloat guidX = self.homeFatherView.centerX - guidImageWidth;
        CGFloat guidY = self.homeFatherView.frame.origin.y-guidImageHeight;
        guidImage.frame = CGRectMake(guidX, guidY, guidImageWidth, guidImageHeight);
        [_homeGuidView addSubview:guidImage];
    }
    return _homeGuidView;
}

- (AXGBlingView *)blingView {
    if (_blingView == nil) {
        _blingView = [[AXGBlingView alloc] initWithFrame:CGRectMake(self.homeFatherView.frame.origin.x-1.6, self.homeFatherView.frame.origin.y + 2.0, self.homeFatherView.bounds.size.width + 30, self.homeFatherView.bounds.size.height + 30)];
        _blingView.text = @"·";
        _blingView.textColor = [UIColor colorWithHexString:@"#ffdc74"];
        _blingView.textAlignment = NSTextAlignmentCenter;
        _blingView.clipsToBounds = YES;
        _blingView.backgroundColor = [UIColor clearColor];
        _blingView.font = [UIFont fontWithName:@"Helvetica-Bold" size:self.homeFatherView.height * 3.8];
        _blingView.alpha = 1.0f;
        _blingView.glowSize = 40;
        _blingView.glowColor = [UIColor colorWithHexString:@"#ffdc74"];
        _blingView.innerGlowSize = 4;
        _blingView.center = self.homeFatherView.center;
        _blingView.centerX = self.homeFatherView.centerX + 0.07;
        _blingView.centerY = self.homeFatherView.centerY + 1.8;
        [_blingView.layer addAnimation:[self opacityForever_Animation:1] forKey:nil];
    }
    return _blingView;
}

- (void)leftAndRightMove {

    if ([AXGGuidManager sharedAXGGuidManager].tyGuidIsShowed) {
        return;
    }
    
    MYNoteView *noteView = [AXGGuidManager sharedAXGGuidManager].tyNoteView;
    
    UIImageView *rightImage = [AXGGuidManager sharedAXGGuidManager].tyRightImage;
    UIImageView *upDownImage = [AXGGuidManager sharedAXGGuidManager].tyRightUpDownImage;
    
     CGRect noteFrame = noteView.frame;
     CGRect rightFrame = rightImage.frame;
     CGRect upDownFrame = upDownImage.frame;
    
    CGRect lyricFrame = noteView.lyricLabel.frame;
    CGRect rightLineFrame = noteView.rightLine.frame;

    CGFloat noteH = [[UIScreen mainScreen] bounds].size.width / 13;
    
    noteFrame = noteView.frame;
    
    if (moveCount == 13) {
        moveCount = 0;
    }
    
    if (moveCount > 3 && moveCount < 7) {
        
        NSLog(@"2");
        
        noteFrame.size.width -= noteH;
        
        lyricFrame.origin.x -= noteH/2;
        rightLineFrame.origin.x -= noteH;
        
        rightFrame.origin.x -= noteH;
        
    } else if (moveCount <= 3 && moveCount > 0){
        
         NSLog(@"1");
        
        noteFrame.size.width += noteH;
        
        lyricFrame.origin.x += noteH/2;
        rightLineFrame.origin.x += noteH;
        
        rightFrame.origin.x += noteH;
        
    } else if (moveCount >= 7 && moveCount < 10) {
        
         NSLog(@"3");
        
        noteFrame.origin.y -= noteH;
        upDownFrame.origin.y -= noteH;
        
    } else if (moveCount >= 10) {
        
         NSLog(@"4");
        
        noteFrame.origin.y += noteH;
        
        upDownFrame.origin.y += noteH;
        
    }
    
    if (moveCount < 7) {
        [UIView animateKeyframesWithDuration:0.3 delay:0.3 options:0 animations:^{
            if (![AXGGuidManager sharedAXGGuidManager].tyGuidIsShowed) {
                
                rightImage.hidden = NO;
                upDownImage.hidden = YES;
                
                noteView.frame = noteFrame;
                
                rightImage.frame = rightFrame;
                
                noteView.lyricLabel.frame = lyricFrame;
                noteView.rightLine.frame = rightLineFrame;
                
//                [noteView setNeedsDisplay];
            }
        } completion:^(BOOL finished) {
            [self leftAndRightMove];
        }];
    } else if (moveCount > 0){
        
        [UIView animateKeyframesWithDuration:0.3 delay:0.3 options:0 animations:^{
            if (![AXGGuidManager sharedAXGGuidManager].tyGuidIsShowed) {
                
                rightImage.hidden = YES;
                upDownImage.hidden = NO;
                
                noteView.frame = noteFrame;
                
                upDownImage.frame = upDownFrame;
                
//                [noteView setNeedsDisplay];
            }
        } completion:^(BOOL finished) {
            [self leftAndRightMove];
        }];
    }
    moveCount += 1;
}

+ (void)beginAnimageForNote {
    
    [AXGGuidManager sharedAXGGuidManager]->moveCount = 0;
    
    [[AXGGuidManager sharedAXGGuidManager] leftAndRightMove];
    
}

- (UIView *)tyGuidView {
    if (_tyGuidView == nil) {
        _tyGuidView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth(), screehHeight())];
        _tyGuidView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.91];
        
        UIImageView *guidTxt = [UIImageView new];
        guidTxt.image = [YYImage imageNamed:@"上下拖动·调整音高"];
        CGFloat guidTxtW = 425 / 2 * WIDTH_NIT;
        CGFloat guidTxtH = 141 / 2 * WIDTH_NIT;
        CGFloat guidTxtY = _tyGuidView.height - 390 / 2 * HEIGHT_NIT - guidTxtH;
        guidTxt.frame = CGRectMake(0, guidTxtY, guidTxtW, guidTxtH);
        guidTxt.centerX = screenWidth() / 2;
        [_tyGuidView addSubview:guidTxt];
        
        CGFloat noteH = [[UIScreen mainScreen] bounds].size.width / 13;
        CGFloat noteW = noteH * 5;
        
//        NoteView *noteView = [[NoteView alloc] initWithFrame:CGRectMake(80 * WIDTH_NIT, 240 * HEIGHT_NIT, noteW, noteH)];
//        [noteView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin];
//        noteView.lyricStr = @"音符";
//        noteView.isGuidNote = YES;
//        noteView.showNoteView.backgroundColor = [UIColor colorWithHexString:@"#ffdc74"];
//        [_tyGuidView addSubview:noteView];
        
        MYNoteView *noteView = [[MYNoteView alloc] initWithFrame:CGRectMake(80 * WIDTH_NIT, 240 * HEIGHT_NIT, noteW, noteH)];
        [noteView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin];
        noteView.lyricLabel.text = @"音符";
        noteView.backgroundColor = [UIColor colorWithHexString:@"#ffdc74"];
        [_tyGuidView addSubview:noteView];
        
        UIImageView *rightImage = [UIImageView new];
        rightImage.image = [YYImage imageNamed:@"箭头"];
        CGFloat rightW = 93 / 2 * WIDTH_NIT;
        CGFloat rightH = 55 / 2 * WIDTH_NIT;
        rightImage.frame = CGRectMake(noteView.right + 6, 0, rightW, rightH);
        rightImage.centerY = noteView.centerY;
        [_tyGuidView addSubview:rightImage];
        
        self.tyRightUpDownImage = [UIImageView new];
        self.tyRightUpDownImage.image = [YYImage imageNamed:@"箭头上下"];
        CGFloat upDownW = 55 / 2 * WIDTH_NIT;
        CGFloat upDownH = 120 / 2 * WIDTH_NIT;
        self.tyRightUpDownImage.frame = CGRectMake(noteView.right + 24, 0, upDownW, upDownH);
        self.tyRightUpDownImage.centerY = noteView.centerY;
        self.tyRightUpDownImage.hidden = YES;
        [_tyGuidView addSubview:self.tyRightUpDownImage];
        
        self.tyNoteView = noteView;
        self.tyRightImage = rightImage;
        self.tyRightImage.hidden = YES;
        
        UIButton *topBtn = [UIButton new];
        topBtn.frame = CGRectMake(0, 0, screenWidth(), screehHeight());
        topBtn.backgroundColor = [UIColor clearColor];
        [topBtn addTarget:self action:@selector(hideDraftsGuid:) forControlEvents:UIControlEventTouchDown];
        [_tyGuidView addSubview:topBtn];
    }
    return _tyGuidView;
}

- (UIView *)draftsGuidView {
    if (_draftsGuidView == nil) {
        _draftsGuidView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth(), screehHeight())];
        _draftsGuidView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.91];
        
        AXGDeleAnimateCell *cellView = [[AXGDeleAnimateCell alloc] initWithFrame:CGRectMake(0, 64, screenWidth(), 241 / 2 * WIDTH_NIT)];
        cellView.centerX = screenWidth() / 2;
//        [cellView.layer addAnimation:[self autoMove_Animation:1 forView:cellView] forKey:nil];
        [_draftsGuidView addSubview:cellView];
        
        [self autoMoveForView:cellView];
        
        UIImageView *imageView = [UIImageView new];
        imageView.image = [YYImage imageNamed:@"左划"];
        CGFloat imageW = 405 / 2 * WIDTH_NIT;
        CGFloat imageH = 55 / 2 * WIDTH_NIT;
        imageView.frame = CGRectMake(0, cellView.bottom + 37.5 * HEIGHT_NIT, imageW, imageH);
        imageView.centerX = screenWidth() / 2;
        [_draftsGuidView addSubview:imageView];
        
        UIButton *topBtn = [UIButton new];
        topBtn.frame = CGRectMake(0, 0, screenWidth(), screehHeight());
        topBtn.backgroundColor = [UIColor clearColor];
        [topBtn addTarget:self action:@selector(hideDraftsGuid:) forControlEvents:UIControlEventTouchDown];
        [_draftsGuidView addSubview:topBtn];
    }
    return _draftsGuidView;
}

- (void)hideDraftsGuid:(UIButton *)btn {
    __block UIView *guidView = btn.superview;
    if (guidView == self.tyGuidView) {
        self.tyGuidIsShowed = YES;
    }
    [UIView animateWithDuration:0.3 animations:^{
        guidView.alpha = 0.0f;
    } completion:^(BOOL finished) {
        [guidView removeFromSuperview];
        guidView = nil;
    }];
}

#pragma mark - animation

- (CABasicAnimation *)opacityForever_Animation:(float)time {
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    animation.fromValue = [NSNumber numberWithFloat:1.0f];
    animation.toValue = [NSNumber numberWithFloat:0.5f];
    animation.autoreverses = YES;
    animation.duration = time;
    animation.repeatCount = MAXFLOAT;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    animation.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    return animation;
}

- (CABasicAnimation *)autoMove_Animation:(float)time forView:(UIView *)view{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position.x"];
    animation.fromValue = @(view.centerX);
    animation.toValue = @(view.centerX-132 / 2 * WIDTH_NIT);
    animation.autoreverses = YES;
    animation.duration = time;
    animation.repeatCount = MAXFLOAT;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    animation.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    return animation;
}

- (void)autoMoveForView:(UIView *)view {
    [UIView animateWithDuration:0.5 animations:^{
        view.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        
        [UIView animateKeyframesWithDuration:0.5 delay:1 options:UIViewKeyframeAnimationOptionLayoutSubviews animations:^{
            view.transform = CGAffineTransformMakeTranslation(-132 / 2 * WIDTH_NIT, 0);
        } completion:^(BOOL finished) {
            [self performSelector:@selector(autoMoveForView:) withObject:view afterDelay:1];
        }];
    }];
}

- (CAAnimationGroup *)noteGroup_Animation:(float)time forView:(UIView *)view{
    CABasicAnimation *positionAnimation = [CABasicAnimation animationWithKeyPath:@"position.x"];
    positionAnimation.fromValue = @(view.centerX);
    positionAnimation.toValue = @(view.centerX-132 / 2 * WIDTH_NIT);
    positionAnimation.autoreverses = YES;
    positionAnimation.duration = time;
    
    CAAnimationGroup *animationgroup = [CAAnimationGroup animation];
    animationgroup.animations = [NSArray arrayWithObjects:positionAnimation, nil];
    animationgroup.duration = time;
    animationgroup.fillMode = kCAFillModeForwards;
    animationgroup.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    return animationgroup;
}


@end
