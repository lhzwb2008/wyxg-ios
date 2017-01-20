//
//  BaseViewController.m
//  CreateSongs
//
//  Created by 爱写歌 on 16/7/13.
//  Copyright © 2016年 AXG. All rights reserved.
//

#import "BaseViewController.h"
#import "MobClick.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self initNavView];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    NSString *vcName = NSStringFromClass([self class]);
    [MobClick beginLogPageView:vcName];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    NSString *vcName = NSStringFromClass([self class]);
    [MobClick endLogPageView:vcName];
}

#pragma mark - 初始化界面
- (void)initNavView {
    
    self.navView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 64)];
    [self.view addSubview:self.navView];
    self.navView.backgroundColor = HexStringColor(@"#FFDC74");
    
//    self.navLeftImage = [[UIImageView alloc] initWithFrame:CGRectMake(16, 0, 23, 18)];
    self.navLeftImage = [[UIImageView alloc] initWithFrame:CGRectMake(16, 0, 23, 20)];
    [self.navView addSubview:self.navLeftImage];
    self.navLeftImage.center = CGPointMake(self.navLeftImage.centerX, 42);
    
    self.navLeftButton = [NavLeftButton buttonWithType:UIButtonTypeCustom];
    self.navLeftButton.frame = CGRectMake(0, 0, 64, 64);
    [self.navView addSubview:self.navLeftButton];
    self.navLeftButton.backgroundColor = [UIColor clearColor];
    
    self.navRightImage = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.width - 23 - 16, self.navLeftImage.top, self.navLeftImage.width, self.navLeftImage.height)];
    [self.navView addSubview:self.navRightImage];
    
    self.navRightButton = [NavRightButton buttonWithType:UIButtonTypeCustom];
    self.navRightButton.frame = CGRectMake(self.view.width - 64, 0, 64, 64);
    [self.navView addSubview:self.navRightButton];
    self.navRightButton.backgroundColor = [UIColor clearColor];
    
    self.navTitle = [[UILabel alloc] initWithFrame:CGRectMake(55, 0, self.view.width - 110, 44)];
    [self.navView addSubview:self.navTitle];
    self.navTitle.center = CGPointMake(self.navTitle.centerX, self.navLeftImage.centerY);
    self.navTitle.textColor = HexStringColor(@"#441D11");
    self.navTitle.textAlignment = NSTextAlignmentCenter;
    [self.navTitle setFont:TECU_FONT(18)];
    
    self.msgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 7.5, 7.5)];
    self.msgView.center = CGPointMake(self.navLeftButton.imageView.right - 3.75, self.navLeftButton.imageView.bottom - 3.75);
    [self.navView addSubview:self.msgView];
    self.msgView.layer.cornerRadius = self.msgView.height / 2;
    self.msgView.layer.masksToBounds = YES;
    self.msgView.backgroundColor = HexStringColor(@"#cc2424");
    self.msgView.hidden = YES;
    
    self.navLeftImage.image = [self setLeftBtnImage];
    self.navRightImage.image = [self setRightBtnImage];
    self.navTitle.text = [self setTitleTxt];
    
    self.navLeftImage.hidden = YES;
    self.navRightImage.hidden = YES;

}

- (NSString *)setTitleTxt {
    return nil;
}

- (UIImage *)setLeftBtnImage {
    return nil;
}

- (UIImage *)setRightBtnImage {
    return nil;
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
