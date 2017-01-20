//
//  PersonSoundTableViewCell.h
//  CreateSongs
//
//  Created by 爱写歌 on 16/7/21.
//  Copyright © 2016年 AXG. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PersonSoundCollectionViewCell;

typedef void(^PersonSoundSelectBlock)(PersonSoundCollectionViewCell *cell);

@interface PersonSoundTableViewCell : UITableViewCell<UICollectionViewDelegate, UICollectionViewDataSource, UIScrollViewDelegate>

@property (nonatomic, strong) NSArray *dataSource;

@property (nonatomic, strong) NSMutableArray *collectionViewDataSource;

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, assign) NSInteger flag;

@property (nonatomic, copy) PersonSoundSelectBlock personSoundSelectBlock;

@end
