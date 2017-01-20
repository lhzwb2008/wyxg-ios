//
//  BottomScaleBtn.m
//  CreateSongs
//
//  Created by axg on 16/8/3.
//  Copyright © 2016年 AXG. All rights reserved.
//

#import "BottomScaleBtn.h"

static inline CGRect ScaleRect(CGRect rect, float n) {
    return CGRectMake((rect.size.width - rect.size.width * n)/ 2, (rect.size.height - rect.size.height * n) / 2, rect.size.width * n, rect.size.height * n);
}
@implementation BottomScaleBtn

//- (instancetype)initWithImage:(UIImage *)image {
//    self = [super initWithImage:image];
//    if (self) {
//        self.image = image;
//        self.highlightedImage = image;
//        self.userInteractionEnabled = YES;
//    }
//    return self;
//}

- (instancetype)init {
    self = [super init];
    if (self) {
//        [self addTarget];
    }
    return self;
}


//- (void)addTarget {
//    [self addTarget:self action:@selector(beginTouch) forControlEvents:UIControlEventTouchUpInside];
//}
//
//- (void)beginTouch {
//    if ([_delegate respondsToSelector:@selector(quadCurveMenuItemTouchesBegan:)]) {
//        [_delegate quadCurveMenuItemTouchesBegan:self];
//    }
//}
//
//- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
//    self.highlighted = YES;
//    if ([_delegate respondsToSelector:@selector(quadCurveMenuItemTouchesBegan:)]) {
//        [_delegate quadCurveMenuItemTouchesBegan:self];
//    }
//}
//
//- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
//    self.highlighted = NO;
//    CGPoint location = [[touches anyObject] locationInView:self];
//    if (CGRectContainsPoint(ScaleRect(self.bounds, 2.0f), location)) {
//        if ([_delegate respondsToSelector:@selector(quadCurveMenuItemTouchesEnd:)]) {
//            [_delegate quadCurveMenuItemTouchesEnd:self];
//        }
//    }
//}
//- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
//    CGPoint location = [[touches anyObject] locationInView:self];
//    if (!CGRectContainsPoint(ScaleRect(self.bounds, 2.0f), location)) {
//        self.highlighted = NO;
//    }
//    
//}
@end
