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
    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 64, self.view.width, self.view.height - 64)];
    NSProgress *progress  = [[NSProgress alloc] init];

  
    [self.webView loadRequest:[NSURLRequest requestWithURL:self.url]];
    self.webView.delegate = self;
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
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = false;
    self.navTitle.text = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];;
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
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
