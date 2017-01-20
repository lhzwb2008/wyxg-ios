//
//  RecordReleaseViewController.m
//  CreateSongs
//
//  Created by 爱写歌 on 16/8/22.
//  Copyright © 2016年 AXG. All rights reserved.
//

#import "RecordReleaseViewController.h"

@interface RecordReleaseViewController ()

@end

@implementation RecordReleaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark - 初始化界面
- (void)createLyric {
    [super createLyric];
}

- (UIView *)createLyricBgViewUnderView:(UIView *)customNaviView {
    UIImageView *lyricBg = [UIImageView new];
    lyricBg.backgroundColor = [UIColor clearColor];
    lyricBg.frame = CGRectMake(0,
                               customNaviView.bottom + 20 * HEIGHT_NIT,
                               width(self.view),
                               4 * self.cellHeight);
    lyricBg.center = CGPointMake(self.view.centerX, lyricBg.centerY);
    //    lyricBg.image = [UIImage imageNamed:@"stbg@2x"];
    [self.firstBgView addSubview:lyricBg];
    return lyricBg;
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
