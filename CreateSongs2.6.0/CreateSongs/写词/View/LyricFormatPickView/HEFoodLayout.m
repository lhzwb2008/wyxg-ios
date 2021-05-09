//
//  HEFoodLayout.m
//  HEcollectionPIckview
//
//  Created by axg on 16/6/30.
//  Copyright © 2016年 AXG. All rights reserved.
//

#import "HEFoodLayout.h"
#import "FormatPitchHeader.h"
#import "AXGHeader.h"

@implementation HEFoodLayout


- (instancetype)init
{
    if (self = [super init]) {
        
        self.cellWidth = P_CELL_WIDTH;
        
        self.cellHeight = P_CELL_HEIGHT;
        
        self.itemSize = CGSizeMake(self.cellWidth , self.cellHeight);
        
        self.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    }
    return self;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return YES;
}

- (void)prepareLayout{
    [super prepareLayout];
    
    // 每个cell的尺寸
    self.itemSize = CGSizeMake(self.cellWidth, self.cellHeight);
    self.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    // 设置水平滚动
    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.minimumLineSpacing = 0;
}

/** 有效距离:当item的中间x距离屏幕的中间x在HMActiveDistance以内,才会开始放大, 其它情况都是缩小 */

/** 缩放因素: 值越大, item就会越大 */
static CGFloat const HEScaleFactor = 0.2;

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    // 计算可见的矩形框
    CGRect visiableRect;
    visiableRect.size = self.collectionView.frame.size;
    visiableRect.origin = self.collectionView.contentOffset;
    
    // 取得默认的cell的UICollectionViewLayoutAttributes
    NSArray *array = [super layoutAttributesForElementsInRect:rect];
    // 计算屏幕最中间的x
    CGFloat centerX = self.collectionView.contentOffset.x + self.collectionView.frame.size.width * 0.5;
    
    // 遍历所有的布局属性
    for (UICollectionViewLayoutAttributes *attrs in array) {
        // 如果不在屏幕上,直接跳过
        if (!CGRectIntersectsRect(visiableRect, attrs.frame)) continue;
        
        // 每一个item的中点x
        CGFloat itemCenterX = attrs.center.x;
        
        // 差距越小, 缩放比例越大
        // 根据跟屏幕最中间的距离计算缩放比例
        CGFloat scale = 1 + HEScaleFactor * (1 - (ABS(itemCenterX - centerX) / self.cellWidth));

        attrs.transform3D =CATransform3DMakeScale(scale*1.1, scale*1.1, scale*1.1);
        
        attrs.alpha = scale;
//        NSLog(@"=====f===%f",attrs.center.y);
//        NSLog(@"%ld", attrs.zIndex);
    }
    
    return array;
}
- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)   velocity {
    // NSLog(@"%@",NSStringFromCGPoint(proposedContentOffset));
    CGSize size = self.collectionView.frame.size;
    
    // 计算可见区域的面积
    CGRect rect = CGRectMake(proposedContentOffset.x, proposedContentOffset.y, size.width, size.height);
    NSArray *array = [super layoutAttributesForElementsInRect:rect];
    // 计算 CollectionView 中点值
    CGFloat centerX = proposedContentOffset.x + self.collectionView.frame.size.width * 0.5;
    // 标记 cell 的中点与 UICollectionView 中点最小的间距
    CGFloat minDetal = MAXFLOAT;
    for (UICollectionViewLayoutAttributes *attrs in array) {
        if (ABS(minDetal) > ABS(centerX - attrs.center.x)) {
            minDetal = attrs.center.x - centerX;
        }
    }
    return CGPointMake(proposedContentOffset.x + minDetal, proposedContentOffset.y);
}


@end
