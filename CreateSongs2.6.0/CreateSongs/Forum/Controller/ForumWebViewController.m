//
//  ForumWebViewController.m
//  CreateSongs
//
//  Created by 爱写歌 on 16/7/6.
//  Copyright © 2016年 AXG. All rights reserved.
//

#import "ForumWebViewController.h"
#import "AXGHeader.h"
#import <WebKit/WebKit.h>

@interface ForumWebViewController ()

@property (nonatomic, strong) UIView *navView;

@property (nonatomic, strong) WKWebView *webView;

@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation ForumWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self createWebView];
    
    [self.view bringSubviewToFront:self.navView];
    
    [self.navLeftButton setImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];
    [self.navLeftButton setImage:[UIImage imageNamed:@"返回_高亮"] forState:UIControlStateHighlighted];
    [self.navLeftButton addTarget:self action:@selector(backButtonAction:) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - 初始化界面

//- (UIImage *)setLeftBtnImage {
//    return [UIImage imageNamed:@"返回"];
//}

- (void)createWebView {
    self.webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 44, self.view.width, self.view.height - 44)];
    [self.webView loadRequest:[NSURLRequest requestWithURL:self.url]];
    [self.view addSubview:self.webView];
}

#pragma mark - Action

- (void)backButtonAction:(UIButton *)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
