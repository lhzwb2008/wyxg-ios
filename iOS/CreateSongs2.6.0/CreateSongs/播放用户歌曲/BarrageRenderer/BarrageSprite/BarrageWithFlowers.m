//
//  BarrageWithFlowers.m
//  CreateSongs
//
//  Created by axg on 16/8/24.
//  Copyright © 2016年 AXG. All rights reserved.
//

#import "BarrageWithFlowers.h"

#import "AXGHeader.h"
#import "FlowersBgView.h"

@interface BarrageWithFlowers ()



@end

@implementation BarrageWithFlowers

@synthesize fontSize = _fontSize;
@synthesize textColor = _textColor;
@synthesize text = _text;
@synthesize fontFamily = _fontFamily;
@synthesize shadowColor = _shadowColor;
@synthesize shadowOffset = _shadowOffset;
@synthesize attributedText = _attributedText;
@synthesize imageUrl = _imageUrl;
@synthesize userName = _userName;
@synthesize upCount = _upCount;

- (instancetype)init {
    if (self = [super init]) {
        _textColor = [UIColor blackColor];
        _fontSize = 16.0f;
        _shadowColor = nil;
        _shadowOffset = CGSizeMake(0, -1);
    }
    return self;
}


#pragma mark - launch

- (UIView *)bindingView {
    
    FlowersBarrageView *headView = [FlowersBarrageView new];
    
//    headView.backgroundColor = [UIColor redColor];
    
    headView.text = _text;
    headView.userName = _userName;
    headView.upCount = _upCount;
    headView.headUrl = _imageUrl;
    
    CGSize nameSize = [self.userName getWidth:self.userName andFont:[UIFont boldSystemFontOfSize:15]];
    CGSize textSize = [self.text getWidth:self.text andFont:[UIFont systemFontOfSize:15]];
    
    CGSize finalSize = CGSizeZero;
    finalSize.width = textSize.width + nameSize.width + 45 + 7 + 20 + 3;
    finalSize.height = 45;
    headView.frame = CGRectMake(0, finalSize.height, finalSize.width, finalSize.height);
    
    FlowersBgView *flowerBg = [[FlowersBgView alloc] initWithFrame:CGRectMake(0, 0, finalSize.width + 100, finalSize.height * 3)];
    flowerBg.backgroundColor = [UIColor clearColor];
    
    [flowerBg addSubview:headView];
//    flowerBg.frame = CGRectMake(0, 0, finalSize.width + 100, finalSize.height * 3);
    
    return flowerBg;
}

- (CGSize)size {
    
    CGSize nameSize = [self.userName getWidth:self.userName andFont:[UIFont boldSystemFontOfSize:15]];
    CGSize textSize = [self.text getWidth:self.text andFont:[UIFont systemFontOfSize:15]];
    
    CGSize finalSize = CGSizeZero;
    finalSize.width = (textSize.width + nameSize.width + 45 + 7 + 20 + 3) + 100;
    finalSize.height = 45*3;
    
    return finalSize;
}



@end
