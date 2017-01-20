//
//  CustomNaviController.m
//  AXGTY
//
//  Created by axg on 16/4/1.
//  Copyright © 2016年 axg. All rights reserved.
//

#import "CustomNaviController.h"
//#import "TyViewController.h"
@interface CustomNaviController ()

@end

@implementation CustomNaviController

- (instancetype)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return toInterfaceOrientation != UIDeviceOrientationPortrait;
}

- (BOOL)shouldAutorotate
{
//    if ([self.topViewController isKindOfClass:[TyViewController class]]) { // 如果是这个 vc 则支持自动旋转
//        return YES;
//    }
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations
{
    if ([self.topViewController isKindOfClass:[UIViewController class]]) {
        return UIInterfaceOrientationMaskLandscapeRight | UIInterfaceOrientationMaskLandscapeLeft;
    }
    return UIInterfaceOrientationMaskAllButUpsideDown;
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
