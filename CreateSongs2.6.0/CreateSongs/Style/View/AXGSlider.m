//
//  AXGSlider.m
//  CreateSongs
//
//  Created by 爱写歌 on 16/7/20.
//  Copyright © 2016年 AXG. All rights reserved.
//

#import "AXGSlider.h"
#import "AXGHeader.h"

#define CIRCLE_HEIGHT self.height / 204 * 120
#define RIGHT_POINT self.width - 37.5 * WIDTH_NIT
#define LEFT_POINT 37.5 * WIDTH_NIT

typedef enum : NSUInteger {
    DirectionLeft = 0,
    DirectionRight,// 水平
    DirectionUp,
    DirectionDown,   // 垂直
    DirectionNone,
} PgrDirection;

@implementation AXGSlider

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self createView];
    }
    return self;
}

- (void)createView {
    
    UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 17.5 * WIDTH_NIT, 0.5)];
    [self addSubview:line1];
    line1.backgroundColor = HexStringColor(@"#441D11");
    line1.center = CGPointMake(line1.centerX, self.height / 2);
    
    UILabel *manLabel = [[UILabel alloc] initWithFrame:CGRectMake(line1.right, 0, 20 * WIDTH_NIT, self.height)];
    manLabel.text = @"慢";
    [self addSubview:manLabel];
    manLabel.font = NORML_FONT(12);
    manLabel.textColor = HexStringColor(@"#535353");
    manLabel.textAlignment = NSTextAlignmentCenter;
    
    UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(manLabel.right, line1.top, self.width - 75 * WIDTH_NIT, line1.height)];
    [self addSubview:line2];
    line2.backgroundColor = line1.backgroundColor;
    
    UILabel *kuaiLabel = [[UILabel alloc] initWithFrame:CGRectMake(line2.right, manLabel.top, manLabel.width, manLabel.height)];
    [self addSubview:kuaiLabel];
    kuaiLabel.textAlignment = NSTextAlignmentCenter;
    kuaiLabel.textColor = manLabel.textColor;
    kuaiLabel.text = @"快";
    kuaiLabel.font = manLabel.font;
    
    UIView *line3 = [[UIView alloc] initWithFrame:CGRectMake(kuaiLabel.right, line2.top, line1.width, line1.height)];
    [self addSubview:line3];
    line3.backgroundColor = line1.backgroundColor;
    
    self.sliderView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.height, self.height)];
    [self addSubview:self.sliderView];
    self.sliderView.image = [UIImage imageNamed:@"曲速icon"];
    self.sliderView.center = CGPointMake(self.width / 2, self.height / 2);
    
    UIView *circleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CIRCLE_HEIGHT, CIRCLE_HEIGHT)];
    [self.sliderView addSubview:circleView];
    circleView.layer.cornerRadius = circleView.width / 2;
    circleView.layer.masksToBounds = YES;
    circleView.layer.borderColor = HexStringColor(@"#A0A0A0").CGColor;
    circleView.layer.borderWidth = 0.5;
    circleView.center = CGPointMake(self.sliderView.width / 2, self.sliderView.height / 2);
    
    self.sliderLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.sliderView.width, self.sliderView.height)];
    [self.sliderView addSubview:self.sliderLabel];
    self.sliderLabel.text = @"100%";
    self.sliderLabel.textColor = HexStringColor(@"#535353");
    self.sliderLabel.font = TECU_FONT(15);
    self.sliderLabel.textAlignment = NSTextAlignmentCenter;
    
    self.sliderView.userInteractionEnabled = YES;
    
    UIView *panView = [[UIView alloc] initWithFrame:self.sliderView.bounds];
    [self.sliderView addSubview:panView];
    panView.backgroundColor = [UIColor clearColor];
    
    UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(move:)];
    [panRecognizer setMinimumNumberOfTouches:1];
    [panRecognizer setMaximumNumberOfTouches:1];
    [panRecognizer setDelegate:self];
    [panView addGestureRecognizer:panRecognizer];
    
    
    CGFloat speedScale = arc4random() % 255 / 255.0;
    
    CGFloat totalW = (LEFT_POINT + CIRCLE_HEIGHT / 2) - (RIGHT_POINT - CIRCLE_HEIGHT / 2);
    
    CGFloat randerW = speedScale * totalW;
    
    CGFloat finalX = (RIGHT_POINT - CIRCLE_HEIGHT / 2) + randerW;
    
    self.sliderView.centerX = finalX;
    
    [self sliderValueChanged:self.sliderView.centerX];
}

#pragma mark - Action
// 移动
-(void)move:(UIPanGestureRecognizer *)sender {
    
    CGPoint translatedPoint = [(UIPanGestureRecognizer*)sender translationInView:self.sliderView];
    
    if([(UIPanGestureRecognizer*)sender state] == UIGestureRecognizerStateBegan) {
        _firstX = [self.sliderView center].x;
        _firstY = [self.sliderView center].y;
    } else if (sender.state == UIGestureRecognizerStateCancelled || sender.state == UIGestureRecognizerStateEnded || sender.state == UIGestureRecognizerStateFailed) {
//        [self panGestureEndChangePlayerProgress:self.sliderView.centerX / self.mainView.width];
        
    }
    
    CGPoint sliderCenter = self.sliderView.center;
    
    sliderCenter.x += translatedPoint.x;
    
    static PgrDirection direction = DirectionNone;
    
    CGPoint velocity = [sender velocityInView:sender.view];
    
    if (fabs(velocity.x) > fabs(velocity.y)) {
        
        direction = (velocity.x)>=0 ? DirectionRight : DirectionLeft;
    } else {
        direction = (velocity.y)>=0 ? DirectionDown : DirectionUp;
    }
    
    if (sliderCenter.x > (RIGHT_POINT - CIRCLE_HEIGHT / 2) && direction == DirectionRight) {
        [sender setTranslation:CGPointZero inView:sender.view];
        return;
    } else if (sliderCenter.x < (LEFT_POINT + CIRCLE_HEIGHT / 2) && direction == DirectionLeft) {
        [sender setTranslation:CGPointZero inView:sender.view];
        return;
    }

    sliderCenter.x = MIN(MAX(sliderCenter.x, 0), self.width);
    
    self.sliderView.center = sliderCenter;
    
    [self sliderValueChanged:self.sliderView.centerX];
    
    [sender setTranslation:CGPointZero inView:sender.view];
    
//    [self setProgressInView];
}

// 滑动条改变方法
- (void)sliderValueChanged:(CGFloat)value {
    
    CGFloat percent = (value - (LEFT_POINT + CIRCLE_HEIGHT / 2)) / ((RIGHT_POINT - CIRCLE_HEIGHT / 2) - (LEFT_POINT + CIRCLE_HEIGHT / 2));
    NSLog(@"percent = %f", percent);
    self.speedScale = percent;
    
    if (self.sliderDidChangedBlock) {
        self.sliderDidChangedBlock(percent);
    }
    
    if (percent >= 0 && percent < 0.5) {
        NSInteger labelNum = 50 + 100 * percent;
        self.sliderLabel.text = [NSString stringWithFormat:@"%ld", labelNum];
        self.sliderLabel.text = [self.sliderLabel.text stringByAppendingString:@"%"];
    } else if (percent >= 0.5 && percent <= 1) {
        NSInteger labelNum = 100 + 200 * (percent - 0.5);
        self.sliderLabel.text = [NSString stringWithFormat:@"%ld", labelNum];
        self.sliderLabel.text = [self.sliderLabel.text stringByAppendingString:@"%"];
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
