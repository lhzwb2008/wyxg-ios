//
//  ForumWebViewController.m
//  CreateSongs
//
//  Created by 爱写歌 on 16/7/6.
//  Copyright © 2016年 AXG. All rights reserved.
//

#import "ForumWebViewController.h"
#import "AXGHeader.h"

@interface ForumWebViewController ()<UIWebViewDelegate>

@property (nonatomic, strong) UIView *navView;

@property (nonatomic, strong) UIWebView *webView;

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
    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 44, self.view.width, self.view.height - 44)];
    [self.webView loadRequest:[NSURLRequest requestWithURL:self.url]];
    self.webView.delegate = self;
    [self.view addSubview:self.webView];
}

#pragma mark - Action

- (void)backButtonAction:(UIButton *)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

#pragma mark - webViewDelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    self.navTitle.text = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];;
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
