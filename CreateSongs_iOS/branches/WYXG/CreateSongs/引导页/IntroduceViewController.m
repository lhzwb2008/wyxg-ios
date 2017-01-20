//
//  IntroduceViewController.m
//  CreateSongs
//
//  Created by axg on 16/3/4.
//  Copyright © 2016年 axg. All rights reserved.
//

#import "IntroduceViewController.h"
#import "AppDelegate.h"
#import "IntroduceView.h"
#import "AXGHeader.h"
#import "SMPageControl.h"
#import "Masonry.h"

@interface IntroduceViewController ()

@property (nonatomic, strong) IntroduceView *inView;

@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, strong) NSArray *images;

@property (nonatomic, strong) SMPageControl *pageControl;

@property (nonatomic, strong) NSMutableArray *imageViewArray;

@property (nonatomic, assign) CGFloat lastOffset;

@property (nonatomic, strong) UIView *pageBgView;

@end

@implementation IntroduceViewController

- (NSMutableArray *)imageViewArray {
    if (_imageViewArray == nil) {
        _imageViewArray = [NSMutableArray array];
    }
    return _imageViewArray;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        
        NSArray *bgIMGNames = nil;
        
        if (kDevice_Is_iPhone4 || [[UIDevice currentDevice].model isEqualToString:@"iPad"]) {
            
            bgIMGNames = @[@"A640,960", @"B640,960", @"C640,960" ,@"D640,960"];
            
        } else if (kDevice_Is_iPhone5) {
            
            bgIMGNames = @[@"A640,1136", @"B640,1136", @"C640,1136", @"D640,1136"];
        } else if (kDevice_Is_iPhone6) {
            
            bgIMGNames = @[@"A750,1334", @"B750,1334", @"C750,1334", @"D750,1334"];
        } else if (kDevice_Is_iPhone6Plus) {
            
            bgIMGNames = @[@"A1242,2208", @"B1242,2208", @"C1242,2208", @"D1242,2208"];
        }
        self.images = [bgIMGNames copy];
    }
    return self;
}

- (NSUInteger)numberOfPages {
    return 5;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self configBgImages];
    [self configAnimations];
    [self configPageControl];
//    [self createIntroduceView];
}

- (void)configPageControl {
    
    
    
    self.pageControl = ({
        SMPageControl *pageControl = [[SMPageControl alloc] init];
        pageControl.numberOfPages = self.images.count;
        pageControl.userInteractionEnabled = NO;
//        pageControl.pageIndicatorImage = [UIImage imageNamed:@"Banner轮播2"];
        pageControl.pageIndicatorTintColor = [UIColor colorWithHexString:@"#FFDC74"];
//        pageControl.currentPageIndicatorImage = [UIImage imageNamed:@"Banner轮播"];
        pageControl.currentPageIndicatorTintColor = [UIColor colorWithHexString:@"#ff8f45"];
        [pageControl sizeToFit];
        pageControl.currentPage = 0;
        pageControl;
    });
    self.pageControl.frame = CGRectMake(0, kScreen_Height - kScaleFrom_iPhone6_Desgin(20)*2, kScreen_Width, kScaleFrom_iPhone6_Desgin(20));
    [self.view addSubview:self.pageControl];
//    [self.pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.size.mas_equalTo(CGSizeMake(kScreen_Width, kScaleFrom_iPhone6_Desgin(20)));
//        make.centerX.equalTo(self.view);
//        make.bottom.equalTo(self.view.mas_bottom).offset(-kScaleFrom_iPhone6_Desgin(20));
//    }];
}

- (void)configBgImages {
    NSInteger i = 0;
    [self.imageViewArray removeAllObjects];
    for (NSString *imageName in self.images) {
        UIImage *image = [UIImage imageNamed:imageName];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        imageView.frame = CGRectMake(kScreen_Width * i, 0, kScreen_Width, kScreen_Height);
        [self.contentView addSubview:imageView];
        [self.imageViewArray addObject:imageView];
        if (i == self.images.count - 1) {
            imageView.userInteractionEnabled = YES;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(lastPicAction:)];
            [imageView addGestureRecognizer:tap];
        }
        i++;
    }
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.images.count * kScreen_Width, 0, kScreen_Width, kScreen_Height)];
    imageView.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:imageView];
    [self.imageViewArray addObject:imageView];
}

- (void)lastPicAction:(UITapGestureRecognizer *)tgr {
    [self turnToHomeControler];
}

- (void)configAnimations {
    NSInteger i = 0;
    for (UIImageView *imageView in self.imageViewArray) {
        [self keepView:imageView onPage:i++];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(self.view.bounds.size);
            make.top.equalTo(self.view.mas_top);
        }];
    }
}

#pragma mark Super
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat currentOffset = scrollView.contentOffset.x;
    if (self.pageWidth > 0.f) {
        currentOffset = currentOffset / self.pageWidth;
    }
    [self animateCurrentFrame];
    NSInteger nearestPage = floorf(currentOffset + 0.5);
    
    if (nearestPage > 0) {
        self.view.backgroundColor = [UIColor clearColor];
    } else {
        self.view.backgroundColor = [UIColor whiteColor];
    }
    if (currentOffset > self.images.count-1) {
        self.pageControl.hidden = YES;
    } else {
        
    }
    if (currentOffset - self.lastOffset < 0) {
        self.pageControl.hidden = NO;
    }
    
    self.lastOffset = currentOffset;
    
    if (nearestPage >= self.images.count) {
        return;
    }
    self.pageControl.currentPage = nearestPage;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (self.lastOffset >= self.images.count) {
        [self.view removeFromSuperview];
        [self removeFromParentViewController];
    }
    NSLog(@"111");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

/**
 *  切换到首页
 */
- (void)turnToHomeControler {

    WEAK_SELF;
    [UIView animateWithDuration:0.6 delay:0.6 options:UIViewAnimationOptionCurveEaseIn animations:^{
        STRONG_SELF;
        [self.view setX:-kScreen_Width];
    } completion:^(BOOL finished) {
        STRONG_SELF;
        [self.view removeFromSuperview];
        [self removeFromParentViewController];
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

- (BOOL)shouldAutorotate {
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    //viewController所支持的全部旋转方向
    return UIInterfaceOrientationMaskPortrait;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    //viewController初始显示的方向
    return UIInterfaceOrientationPortrait;
}


@end
