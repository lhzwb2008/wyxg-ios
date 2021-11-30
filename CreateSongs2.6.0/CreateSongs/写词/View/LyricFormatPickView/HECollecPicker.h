//
//  HECollecPicker.h
//  HEcollectionPIckview
//
//  Created by axg on 16/6/30.
//  Copyright © 2016年 AXG. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SelctedeFormatBlock)(NSInteger index);

typedef void(^AppearSelectFormat)(NSInteger index);

@interface HECollecPicker : UIView<UICollectionViewDataSource,UICollectionViewDelegate> {
    NSThread *checkShownThread;
    
    CAGradientLayer *gradientLayer1;
}


@property (nonatomic, strong) CAGradientLayer *gradientLayer;
@property (nonatomic, strong) NSArray *dataArray;

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, assign) NSInteger currentShowIndex;

@property (nonatomic, assign) BOOL shouldChangeIndex;

@property (nonatomic, copy) SelctedeFormatBlock selectedFormatBlock;

@property (nonatomic, copy) AppearSelectFormat appearSelectFormat;

@end
