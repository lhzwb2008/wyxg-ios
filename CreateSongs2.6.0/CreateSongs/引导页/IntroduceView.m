//
//  IntroduceView.m
//  CreateSongs
//
//  Created by axg on 16/3/4.
//  Copyright © 2016年 axg. All rights reserved.
//

#import "IntroduceView.h"
#import "AXGHeader.h"
#import "Masonry.h"

@interface IntroduceView ()

@property (nonatomic, strong) UIScrollView *bgScrollView;
/**
 *  引导背景图
 */
@property (nonatomic, strong) NSMutableArray *bgImages;

@end

@implementation IntroduceView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubViews];
    }
    return self;
}

- (void)initSubViews {

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
    
    self.bgScrollView = [UIScrollView new];
    self.bgScrollView.frame = CGRectMake(0, 0, self.width, self.height);
    self.bgScrollView.contentSize = CGSizeMake(self.bounds.size.width * bgIMGNames.count, 0);
    self.bgScrollView.pagingEnabled = YES;
    self.bgScrollView.showsHorizontalScrollIndicator = NO;
    self.bgScrollView.showsVerticalScrollIndicator = NO;
    self.bgScrollView.bounces = NO;
    
    NSInteger i = 0;
    for (NSString *imageName in bgIMGNames) {
        UIImageView *imageView = [UIImageView new];
        imageView.frame = CGRectMake(self.width * i, 0, self.bgScrollView.width, self.bgScrollView.height);
        NSString *path = [[NSBundle mainBundle] pathForResource:imageName ofType:@"png"];
        UIImage *image = [[UIImage alloc] initWithContentsOfFile:path];
        imageView.image = image;
        [self.bgScrollView addSubview:imageView];
        
        if (i == bgIMGNames.count - 1) {
            imageView.userInteractionEnabled = YES;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(lastPicAction:)];
            [imageView addGestureRecognizer:tap];
        }
        
        i++;
    }
    [self addSubview:self.bgScrollView];
}

- (void)lastPicAction:(UITapGestureRecognizer *)tgr {
    if (self.lastIntroducPic) {
        self.lastIntroducPic();
    } else {
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"closeIntroduce" object:nil];
    }
}

@end
