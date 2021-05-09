//
//  HECollecPicker.m
//  HEcollectionPIckview
//
//  Created by axg on 16/6/30.
//  Copyright © 2016年 AXG. All rights reserved.
//

#import "HECollecPicker.h"
#import "HEFoodPickCell.h"
#import "HEFoodLayout.h"
#import "FormatPitchHeader.h"
#import "UIColor+expanded.h"
#import "UIView+Common.h"
#import "UIView+UIViewAdditions.h"


@implementation HECollecPicker

- (instancetype)initWithFrame:(CGRect)frame{

    if (self =[super initWithFrame:frame]) {
        
        self.dataArray = @[@"空白", @"吐槽", @"祝福", @"文艺", @"表白"];
        
        [self view1];
    }

    return self;
}

- (void)view1 {
   
    CGRect rect = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height-0.5);
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:rect collectionViewLayout:[[HEFoodLayout alloc] init]];
    collectionView.dataSource = self;
    collectionView.delegate = self;
    [collectionView registerNib:[UINib nibWithNibName:@"HEFoodPickCell" bundle:nil] forCellWithReuseIdentifier:@"cell"];
    collectionView.showsHorizontalScrollIndicator = NO;
    collectionView.showsVerticalScrollIndicator = NO;
    [self addSubview:collectionView];
    self.collectionView = collectionView;
    self.collectionView.backgroundColor =[UIColor whiteColor];
    
    
    UILabel *line = [UILabel new];
    line.backgroundColor = [UIColor colorWithHexString:@"#cccccc"];
    line.frame = CGRectMake(0, collectionView.bottom, self.bounds.size.width, 0.5);
    [self addSubview:line ];
    
    
//    UIImageView *shadowView = [UIImageView new];
//    shadowView.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
////    shadowView.userInteractionEnabled = NO;
//    shadowView.backgroundColor = [UIColor clearColor];
//    shadowView.clipsToBounds = YES;
//    [self addSubview:shadowView];
    
//    UIColor *midleColor = [UIColor colorWithRed:0.327 green:0.903 blue:0.642 alpha:1.000];
//    UIColor *otherColor = [UIColor clearColor];
    
//    self.gradientLayer = [CAGradientLayer layer];
//    self.gradientLayer.frame = shadowView.bounds;
//    self.gradientLayer.startPoint = CGPointMake(0, 0);
//    self.gradientLayer.endPoint = CGPointMake(1, 0);
//    self.gradientLayer.colors = @[(__bridge id)[UIColor colorWithRed:0.285 green:0.579 blue:0.889 alpha:1.000].CGColor,
//                                  (__bridge id)[UIColor clearColor].CGColor];
//    self.gradientLayer.locations = @[@(0.0f), @(1.0f)];
//
//    [shadowView.layer addSublayer:self.gradientLayer];
    
    
//    gradientLayer1 = [CAGradientLayer layer];
//    gradientLayer1.frame = CGRectMake(self.bounds.size.width/2, 0, self.bounds.size.width/2, self.bounds.size.height);
//    gradientLayer1.startPoint = CGPointMake(0, 0);
//    gradientLayer1.endPoint = CGPointMake(1, 0);
//    gradientLayer1.colors = @[(__bridge id)otherColor.CGColor,
//                             (__bridge id)midleColor.CGColor];
//    gradientLayer1.locations = @[@(0.0f), @(1.0f)];
//    
//    [shadowView.layer addSublayer:gradientLayer1];
    
    // 随机歌词
    self.currentShowIndex = 0;
    
    if (self.currentShowIndex > 4) {
        self.currentShowIndex = 4;
    }
//
    checkShownThread = [[NSThread alloc] initWithTarget:self selector:@selector(checkIfViewIsShowing) object:nil];
    [checkShownThread start];
}


- (void)checkIfViewIsShowing {
    while (1) {
        if (self.collectionView.window != nil) {
            break;
        }
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:self.currentShowIndex inSection:500] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
        
        if (self.appearSelectFormat) {
            self.appearSelectFormat(self.currentShowIndex);
        }
    });
    
    [checkShownThread cancel];
    checkShownThread = nil;
}


#pragma mark - <UICollectionViewDataSource>
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 999;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HEFoodPickCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.cellLabel.text = self.dataArray[indexPath.row] ;
//    cell.cellLabel.adjustsFontSizeToFitWidth = YES;
    cell.cellLabel.font = [UIFont systemFontOfSize:13];
    cell.backgroundColor = [UIColor clearColor];
    cell.cellLabel.textColor =[UIColor colorWithHexString:@"#333333"];

    UIView *selectedView = [UIView new];
    selectedView.frame = cell.contentView.bounds;
    selectedView.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];

    if (self.selectedFormatBlock) {
        self.selectedFormatBlock(indexPath.row);
    }
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {

}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
//    NSLog(@"滑动");
    
//    NSLog(@"%f",scrollView.contentOffset.x);
    
    NSInteger YH  = scrollView.contentOffset.x + P_CELL_WIDTH;
    
    NSInteger index = YH / ((NSInteger)P_CELL_WIDTH);
    
    
    HEFoodPickCell *cell = (HEFoodPickCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:index + 2 inSection:0]];
//    NSLog(@"------%ld--%ld--%ld", (long)YH, (NSInteger)P_CELL_WIDTH, YH / ((NSInteger)P_CELL_WIDTH));
    
//    HEFoodPickCell *cell1 = (HEFoodPickCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:scrollView.contentOffset.x/P_CELL_WIDTH+1+2 inSection:0]];
//    HEFoodPickCell *cell2 = (HEFoodPickCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:scrollView.contentOffset.x/P_CELL_WIDTH-1+2 inSection:0]];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
//    [self moveCollection:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    self.shouldChangeIndex = NO;
    [self moveCollection:scrollView];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
//    [self moveCollection:scrollView ];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    self.shouldChangeIndex = YES;
}

- (void)moveCollection:(UIScrollView *)scrollView {
    
}


- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
}


@end
