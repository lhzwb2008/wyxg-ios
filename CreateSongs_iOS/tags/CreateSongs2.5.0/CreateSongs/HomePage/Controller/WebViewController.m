//
//  WebViewController.m
//  CreateSongs
//
//  Created by 爱写歌 on 16/7/18.
//  Copyright © 2016年 AXG. All rights reserved.
//

#import "WebViewController.h"
#import "UIWebView+AFNetworking.h"
#import "AXGMediator+MediatorModuleAActions.h"
#import "AXGMediator.h"

@interface WebViewController ()<UIWebViewDelegate>

@property (nonatomic, strong) UIWebView *webView;

@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self initNavView];
    [self createWebView];
    
    NSLog(@"%@", self.url);
    
    [self.view bringSubviewToFront:self.navView];
}

#pragma mark - 初始化界面
- (void)initNavView {
    [super initNavView];
//    self.navLeftImage.image = [UIImage imageNamed:@"返回"];
    [self.navLeftButton setImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];
    [self.navLeftButton setImage:[UIImage imageNamed:@"返回_高亮"] forState:UIControlStateHighlighted];
    [self.navLeftButton addTarget:self action:@selector(backButtonAction:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)createWebView {
    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 64, self.view.width, self.view.height - 64)];
    NSProgress *progress  = [[NSProgress alloc] init];

  
    [self.webView loadRequest:[NSURLRequest requestWithURL:self.url]];
    self.webView.delegate = self;
    [self.view addSubview:self.webView];
    
    NSString *oldAgent = [self.webView stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"];
    NSLog(@"old agent :%@", oldAgent);

}

#pragma mark - Action

- (void)backButtonAction:(UIButton *)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

#pragma mark - webViewDelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = false;
    self.navTitle.text = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];;
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    NSURL *requestUrl = [request URL];
    NSString *urlString = requestUrl.absoluteString;
    NSLog(@"%@", urlString);
    
    if ([urlString hasPrefix:@"wyxg"]) {
        
        // 拦截到特殊url 进行约定操作
        
        [AXGMediator AXGMeidator_showShareWithUrl:urlString loadResult:^(id view) {
            
        } hideAction:^(NSDictionary *info) {
            
        }];
        
        return NO;
    }
    
    return YES;
}

// 通信格式  @"wyxg://www.woyaoxiege.com?action=share&img=%@&title=%@&description=%@&url=%@"

- (void)webViewDidStartLoad:(UIWebView *)webView {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = true;
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
