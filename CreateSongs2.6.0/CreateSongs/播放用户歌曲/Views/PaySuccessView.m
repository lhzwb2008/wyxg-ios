//
//  PaySuccessView.m
//  CreateSongs
//
//  Created by axg on 16/8/17.
//  Copyright © 2016年 AXG. All rights reserved.
//

#import "PaySuccessView.h"
#import "AXGHeader.h"

@implementation PaySuccessView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:0.000 alpha:0.9];
        [self initSubViews];
    }
    return self;
}

- (void)initSubViews {
    self.successImage = [UIImageView new];
    self.successImage.frame = CGRectMake(0, 250*HEIGHT_NIT, 178*HEIGHT_NIT, 216*HEIGHT_NIT);
    self.successImage.centerX = self.width / 2;
    self.successImage.image = [UIImage imageNamed:@"playUser支付成功"];
    
    self.successLabel = [UILabel new];
    self.successLabel.frame = CGRectMake(0, self.height-75*HEIGHT_NIT-15, self.width, 15);
    self.successLabel.text = @"恭喜您，成功送出一朵鲜花";
    self.successLabel.textAlignment = NSTextAlignmentCenter;
    self.successLabel.textColor = [UIColor colorWithHexString:@"#ffffff"];
    self.successLabel.font = [UIFont boldSystemFontOfSize:15];
    
    [self addSubview:self.successImage];
    [self addSubview:self.successLabel];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
