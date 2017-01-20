//
//  Toast.m
//  CreateSongs
//
//  Created by Hope on 16/2/15.
//  Copyright © 2016年 Hope. All rights reserved.
//

#import "Toast.h"
#import "AXGHeader.h"

@interface Toast()

@property (nonatomic, retain)UILabel *label;
@property (nonatomic, copy)NSString *title;
@property (nonatomic, assign)CGFloat time;

@end

@implementation Toast
 


- (UILabel *)label{
    if (!_label) {
        self.label = [[UILabel alloc] initWithFrame:CGRectMake(3, 3, self.frame.size.width - 6, 30)];
        _label.textColor = [UIColor whiteColor];
        _label.font = [UIFont systemFontOfSize:14];
        _label.adjustsFontSizeToFitWidth = YES;
        _label.text = _title;
        _label.textAlignment = NSTextAlignmentCenter;
        
    }
    return _label;
}
/*
 便利构造器的方法
 */
+(id)toastWithView:(UIView *)view title:(NSString *)title timestamp:(CGFloat)time{
    Toast *toast = [[[self class] alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width / 3, 40)];
    if (toast) {
        CGPoint center = view.center;
        center.y = view.frame.size.height - view.frame.size.height / 5*3;
        toast.center = center;
        toast.alpha = 0.8;
        toast.backgroundColor = [UIColor colorWithHexString:@"#333333"];
        toast.time = time;
        toast.title = title;
        toast.layer.masksToBounds = YES;
        toast.layer.cornerRadius =  20;
        [toast addSubview:toast.label];
        [view addSubview:toast];
    }
    return toast;
}

- (void)show{
    [UIView animateWithDuration:self.time animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
