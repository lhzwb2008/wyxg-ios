//
//  BarrageSpriteWithHead.m
//  CreateSongs
//
//  Created by axg on 16/8/15.
//  Copyright © 2016年 AXG. All rights reserved.
//

#import "BarrageSpriteWithHead.h"

#import "AXGHeader.h"
#import "HeadBarrageView.h"
#import "NormalBarrageView.h"

@implementation BarrageSpriteWithHead

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
    NormalBarrageView *headView = [NormalBarrageView new];

    headView.text = _text;
    headView.userName = _userName;
    headView.upCount = _upCount;
//    headView.headUrl = _imageUrl;
//    headView.textLabel.font = NORML_FONT(_fontSize);
//    headView.textLabel.text = _text;
//    headView.textLabel.textColor = _textColor;
//    headView.headImageView.image = _image;
    
    return headView;
}

- (CGSize)size {
    
    CGSize nameSize = [self.userName getWidth:self.userName andFont:[UIFont boldSystemFontOfSize:15]];
    CGSize textSize = [self.text getWidth:self.text andFont:[UIFont systemFontOfSize:15]];

    CGSize finalSize = CGSizeZero;
    finalSize.width = textSize.width + 45 + 7 + 45 + 20 + 3;
    finalSize.height = 45;
    
    return finalSize;
}


@end
