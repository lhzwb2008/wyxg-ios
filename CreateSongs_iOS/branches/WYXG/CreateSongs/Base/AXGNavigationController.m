//
//  AXGNavigationController.m
//  CreateSongs
//
//  Created by axg on 16/3/14.
//  Copyright © 2016年 AXG. All rights reserved.
//

#import "AXGNavigationController.h"

@interface AXGNavigationController ()

@end

@implementation AXGNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

+ (void)initialize {
    UINavigationBar *appearance = [UINavigationBar appearance];
    appearance.barTintColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.5];
}

- (void)setNavigationBarHidden:(BOOL)hidden animated:(BOOL)animated {
    UINavigationBar *appearance = [UINavigationBar appearance];
    CGFloat tmp = 64;
    if (hidden) {
        tmp = -64;
    }
    [UIView animateWithDuration:0.5 animations:^{
        appearance.transform = CGAffineTransformMakeTranslation(tmp, 0);
    }];
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
