//
//  RecommandTableViewCell.h
//  CreateSongs
//
//  Created by 爱写歌 on 16/7/14.
//  Copyright © 2016年 AXG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RecommandCollectionViewCell.h"

typedef void(^SelectItemBlock)(NSInteger index, RecommandCollectionViewCell *cell);

@interface RecommandTableViewCell : UITableViewCell<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) NSMutableArray *viewArray;

@property (nonatomic, strong) NSArray *dataSource;

@property (nonatomic, copy) SelectItemBlock selectItemBlock;

@end
