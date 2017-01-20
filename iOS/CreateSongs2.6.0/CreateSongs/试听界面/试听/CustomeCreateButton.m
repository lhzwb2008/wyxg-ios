//
//  CustomeCreateButton.m
//  CreateSongs
//
//  Created by 爱写歌 on 16/3/21.
//  Copyright © 2016年 AXG. All rights reserved.
//

#import "CustomeCreateButton.h"
#import "AXGHeader.h"
#import <QuartzCore/QuartzCore.h>

@implementation CustomeCreateButton

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = frame.size.height / 2;
        [self createCustomButton];
    }
    return self;
}

- (void)createCustomButton {
    
    self.customeEnable = YES;
    
    self.title = [[UILabel alloc] initWithFrame:self.bounds];
    [self addSubview:self.title];
//    self.title.text = @"制作歌曲";
    self.title.textColor = [UIColor whiteColor];
    self.title.textAlignment = NSTextAlignmentCenter;
    self.title.font = JIACU_FONT(18*WIDTH_NIT);
    
    self.backgroundColor = [UIColor colorWithHexString:@"#879999"];
    
    // 阴影效果
    self.layer.masksToBounds = NO;
    self.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    self.layer.shadowOffset = CGSizeMake(0, 2);
    self.layer.shadowRadius = 2;
    self.layer.shadowOpacity = 0.4;
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    if (self.customeEnable) {
        [UIView animateWithDuration:0.2 animations:^{
//            self.backgroundColor = BUTTON_TOUCH_DOWN_COLOR;
        }];
    }
//    self.alpha = 0.5;
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    if (self.customeEnable) {
        self.backgroundColor = THEME_COLOR;
        
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [self.target performSelector:self.action withObject:nil];
#pragma clang diagnostic pop
    }

}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
