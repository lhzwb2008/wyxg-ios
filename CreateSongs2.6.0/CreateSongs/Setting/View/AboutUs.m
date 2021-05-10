//
//  AboutUs.m
//  CreateSongs
//
//  Created by 爱写歌 on 16/3/8.
//  Copyright © 2016年 AXG. All rights reserved.
//

#import "AboutUs.h"
#import "AXGHeader.h"
#import "KVNProgress.h"

@implementation AboutUs

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self createAboutUsView];
    }
    return self;
}

- (void)createAboutUsView {
    
    self.backgroundColor = [UIColor whiteColor];
    CGFloat navH = kDevice_Is_iPhoneX ? 88 : 64;
    UIImageView *logoImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, navH + 185 * HEIGHT_NIT, 153 * WIDTH_NIT, 66.5 * WIDTH_NIT)];
    logoImage.image = [UIImage imageNamed:@"设置_关于我们"];
    logoImage.center = CGPointMake(self.centerX, logoImage.centerY);
    logoImage.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:logoImage];
    
    
    /***************************进入测试模式代码*****************************/
    
    UIView *testTapView = [[UIView alloc] initWithFrame:CGRectMake(logoImage.left, logoImage.bottom, logoImage.width, logoImage.height)];
    [self addSubview:testTapView];
    testTapView.backgroundColor = [UIColor clearColor];
    
    UITapGestureRecognizer *testTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(enterTestMode)];
    testTap.numberOfTapsRequired = 6;
    [testTapView addGestureRecognizer:testTap];
    
    /***************************进入测试模式代码*****************************/
    
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(0, self.bottom - 80 * HEIGHT_NIT, self.width / 2 - 30 * WIDTH_NIT, 15 * HEIGHT_NIT)];
//    label1.text = @"版本：V 1.4";
    label1.text = [NSString stringWithFormat:@"V %@", [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]];
    label1.textColor = HexStringColor(@"#a0a0a0");
    label1.font = NORML_FONT(11 * HEIGHT_NIT);
    label1.textAlignment = NSTextAlignmentRight;
    [self addSubview:label1];
    
    UILabel *agreementLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.centerX - 10 * WIDTH_NIT, label1.top, label1.width, label1.height)];
//    agreementLabel.text = @"用户协议";
    agreementLabel.textColor = HexStringColor(@"#a0a0a0");
    agreementLabel.font = NORML_FONT(11 * HEIGHT_NIT);
    agreementLabel.textAlignment = NSTextAlignmentLeft;
    [self addSubview:agreementLabel];
    NSMutableAttributedString *content = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"用户服务协议"]];
    NSRange contentRange = {0,[content length]};
    [content addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:contentRange];
    [content addAttribute:NSForegroundColorAttributeName value:HexStringColor(@"#a0a0a0") range:contentRange];
    [content addAttribute:NSFontAttributeName value:NORML_FONT(11 * HEIGHT_NIT) range:contentRange];
    agreementLabel.attributedText = content;
    agreementLabel.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [agreementLabel addGestureRecognizer:tap];
    
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(0, label1.bottom + 8 * HEIGHT_NIT, self.width, 15 * HEIGHT_NIT)];
    label2.text = @"爱写歌信息科技（上海）有限公司";
    label2.textColor = HexStringColor(@"#a0a0a0");
    label2.font = NORML_FONT(11 * HEIGHT_NIT);
    label2.textAlignment = NSTextAlignmentCenter;
    [self addSubview:label2];
    
    UILabel *label3 = [[UILabel alloc] initWithFrame:CGRectMake(0, label2.bottom + 8 * HEIGHT_NIT, self.width, 15 * HEIGHT_NIT)];
    label3.text = @"All Rights Reserved";
    label3.textColor = HexStringColor(@"#a0a0a0");
    label3.font = NORML_FONT(11 * HEIGHT_NIT);
    label3.textAlignment = NSTextAlignmentCenter;
    [self addSubview:label3];
    
}

- (void)tapAction:(UITapGestureRecognizer *)tap {
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"popUserAgreement" object:nil];
}

/**
 *  进入测试模式点击方法
 */
- (void)enterTestMode {
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:IS_TEST] isEqualToString:IS_TEST_YES]) {
        [KVNProgress showSuccessWithStatus:@"进入普通模式"];
        [[NSUserDefaults standardUserDefaults] setObject:IS_TEST_NO forKey:IS_TEST];
        NSLog(@"%@", [[NSUserDefaults standardUserDefaults] objectForKey:IS_TEST]);
    } else {
        [KVNProgress showSuccessWithStatus:@"进入测试模式"];
        [[NSUserDefaults standardUserDefaults] setObject:IS_TEST_YES forKey:IS_TEST];
        NSLog(@"%@", [[NSUserDefaults standardUserDefaults] objectForKey:IS_TEST]);
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
