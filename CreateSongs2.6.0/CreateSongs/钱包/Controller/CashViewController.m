//
//  CashViewController.m
//  CreateSongs
//
//  Created by 爱写歌 on 16/8/18.
//  Copyright © 2016年 AXG. All rights reserved.
//

#import "CashViewController.h"

@interface CashViewController ()

@end

@implementation CashViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = HexStringColor(@"eeeeee");
    
    [self initNavView];
    [self createBody];
    
    [self.view bringSubviewToFront:self.navView];
    
}

#pragma mark - 初始化界面
- (void)initNavView {
    [super initNavView];
    
    [self.navLeftButton setImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];
    [self.navLeftButton setImage:[UIImage imageNamed:@"返回_高亮"] forState:UIControlStateHighlighted];
    self.navTitle.text = @"兑换收益";
    
    [self.navLeftButton addTarget:self action:@selector(backButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)createBody {
    UIImageView *emptyImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.navView.bottom + 70 * HEIGHT_NIT, 168.5 * WIDTH_NIT, 216 * WIDTH_NIT)];
    [self.view addSubview:emptyImage];
    emptyImage.image = [UIImage imageNamed:@"草稿空状态"];
    emptyImage.center = CGPointMake(self.view.width / 2, emptyImage.centerY);
    
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(0, emptyImage.bottom + 100 * HEIGHT_NIT - 9 * HEIGHT_NIT, self.view.width, 30 * HEIGHT_NIT)];
    [self.view addSubview:label1];
    label1.text = @"兑换收益相关操作";
    label1.textColor = HexStringColor(@"#441D11");
    label1.textAlignment = NSTextAlignmentCenter;
    label1.font = NORML_FONT(12);
    
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(0, emptyImage.bottom + 100 * HEIGHT_NIT + 12 * HEIGHT_NIT, self.view.width, 30 * HEIGHT_NIT)];
    [self.view addSubview:label2];
    label2.textAlignment = NSTextAlignmentCenter;
    label2.textColor = HexStringColor(@"#441D11");
    label2.font = NORML_FONT(12);
    label2.text = @"请关注我要写歌微信服务号";
    
    UIView *whiteView = [[UIView alloc] initWithFrame:CGRectMake(0, label2.bottom + 56 * HEIGHT_NIT, self.view.width, 30 * HEIGHT_NIT)];
    [self.view addSubview:whiteView];
    whiteView.backgroundColor = HexStringColor(@"#ffffff");
    
    UILabel *wechatLabel = [[UILabel alloc] initWithFrame:whiteView.bounds];
    [whiteView addSubview:wechatLabel];
    wechatLabel.textAlignment = NSTextAlignmentCenter;
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:@"我要写歌体验站" attributes:@{NSUnderlineStyleAttributeName:[NSNumber numberWithInteger:NSUnderlineStyleSingle], NSForegroundColorAttributeName:HexStringColor(@"#441D11"), NSFontAttributeName:JIACU_FONT(15)}];
    wechatLabel.attributedText = string;
}


#pragma mark - 方法
- (void)backButtonAction:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
