//
//  WebViewController.m
//  CreateSongs
//
//  Created by 爱写歌 on 16/7/18.
//  Copyright © 2016年 AXG. All rights reserved.
//

#import "WebViewController.h"
#import "AXGMediator+MediatorModuleAActions.h"
#import "AXGMediator.h"
#import <WebKit/WebKit.h>

@interface WebViewController ()<WKUIDelegate, WKNavigationDelegate>

@property (nonatomic, strong) WKWebView *webView;

@property (nonatomic, copy) NSString *urlString;

@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.urlString = @"";
    
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
    
    [self.navRightButton setTitle:@"分享" forState:UIControlStateNormal];
    [self.navRightButton addTarget:self action:@selector(shareButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navRightButton.hidden = YES;
    
}

- (void)createWebView {
    self.webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 64, self.view.width, self.view.height - 64)];
    NSProgress *progress  = [[NSProgress alloc] init];

  
    [self.webView loadRequest:[NSURLRequest requestWithURL:self.url]];
    self.webView.navigationDelegate = self;
    self.webView.UIDelegate = self;
    [self.view addSubview:self.webView];
    
//    NSString *oldAgent = [self.webView stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"];
//    NSLog(@"old agent :%@", oldAgent);

}

#pragma mark - Action

- (void)backButtonAction:(UIButton *)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

// 分享按钮方法
- (void)shareButtonAction:(UIButton *)sender {
    
    NSLog(@"%@", self.urlString);
    
    [AXGMediator AXGMeidator_showShareWithUrl:self.urlString loadResult:^(id view) {
        
    } hideAction:^(NSDictionary *info) {
        
    }];
    
}

#pragma mark - webViewDelegate

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    if ([self shouldContinueWithRequest:navigationAction.request]) {
        decisionHandler(WKNavigationActionPolicyAllow);
        return;
    }
    decisionHandler(WKNavigationActionPolicyCancel);
}


- (BOOL)shouldContinueWithRequest:(NSURLRequest *)request {
    NSURL *requestUrl = [request URL];
    NSString *urlString = requestUrl.absoluteString;
    NSLog(@"%@", urlString);
    
    NSURL *url = requestUrl;
    NSString *query = [url query];
    NSArray *array = [query componentsSeparatedByString:@"&"];
    NSMutableDictionary *notificationDic = [[NSMutableDictionary alloc] initWithCapacity:0];
    for (NSString *string in array) {
        NSArray *subArray = [string componentsSeparatedByString:@"="];
        [notificationDic setObject:[subArray lastObject] forKey:[subArray firstObject]];
    }
    
    if ([urlString hasPrefix:@"wyxg"]) {
        
        if ([notificationDic[@"action"] isEqualToString:@"shareButton"]) {
            // 显示分享按钮
            self.navRightButton.hidden = NO;
            self.urlString = urlString;
        
        } else if ([notificationDic[@"action"] isEqualToString:@"share"]) {
            // 拦截到特殊url 进行约定操作
            
            [AXGMediator AXGMeidator_showShareWithUrl:urlString loadResult:^(id view) {
                
            } hideAction:^(NSDictionary *info) {
                
            }];
        }
        return NO;
    }
    
    NSString *host = [url host];
    
    NSLog(@"%@", host);
    
    if ([host isEqualToString:@"www.woyaoxiege.com"]) {
        self.navRightButton.hidden = YES;
        self.urlString = @"";
    }
    
    return YES;
}

// 通信格式  @"wyxg://www.woyaoxiege.com?action=share&img=%@&title=%@&description=%@&url=%@"


@end
