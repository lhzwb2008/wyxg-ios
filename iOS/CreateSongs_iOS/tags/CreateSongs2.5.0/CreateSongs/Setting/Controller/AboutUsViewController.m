//
//  AboutUsViewController.m
//  CreateSongs
//
//  Created by 爱写歌 on 16/6/21.
//  Copyright © 2016年 AXG. All rights reserved.
//

#import "AboutUsViewController.h"
#import "AboutUs.h"
#import "AXGHeader.h"
#import "KVNProgress.h"

@interface AboutUsViewController ()

@property (nonatomic, strong) AboutUs *aboutUsView;

@end

@implementation AboutUsViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self createAboutUsView];
    [self initNavView];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(popUserAgreementAction:) name:@"popUserAgreement" object:nil];
    
}

#pragma mark - 初始化界面
- (void)createAboutUsView {
    self.aboutUsView = [[AboutUs alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.aboutUsView];
}

- (void)initNavView {
    [super initNavView];
//    self.navLeftImage.image = [UIImage imageNamed:@"返回"];
    self.navTitle.text = @"关于我们";
    
    [self.navLeftButton setImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];
    [self.navLeftButton setImage:[UIImage imageNamed:@"返回_高亮"] forState:UIControlStateHighlighted];
    
    [self.navLeftButton addTarget:self action:@selector(backButtonAction:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)backButtonAction:(UIButton *)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

// 弹出用户协议界面
- (void)popUserAgreementAction:(NSNotification *)message {
    
    if (![XWAFNetworkTool checkNetwork]) {
        
        //        [MBProgressHUD showError:@"网络不给力"];
        [KVNProgress showErrorWithStatus:@"网络不给力"];
        
        return;
    }
    
//    AgreementWebViewViewController *webViewVC = [[AgreementWebViewViewController alloc] init];
//    [self presentViewController:webViewVC animated:YES completion:^{
//        
//    }];
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
