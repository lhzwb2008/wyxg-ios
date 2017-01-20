//
//  PersonSoundTableViewCell.m
//  CreateSongs
//
//  Created by 爱写歌 on 16/7/21.
//  Copyright © 2016年 AXG. All rights reserved.
//

#import "PersonSoundTableViewCell.h"
#import "CollectionViewFlowLayout.h"
#import "PersonSoundCollectionViewCell.h"
#import "AXGHeader.h"

static NSString *const identifier = @"identifier";

@implementation PersonSoundTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createCell];
    }
    return self;
}

- (void)createCell {
    self.backgroundColor = HexStringColor(@"#eeeeee");
    
    self.flag = 1;
    
    self.collectionViewDataSource = [[NSMutableArray alloc] initWithCapacity:0];
    
    CollectionViewFlowLayout *flowLayout = [[CollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake(118 * WIDTH_NIT, 155 * WIDTH_NIT);
//    flowLayout.itemSize = CGSizeMake(85 * WIDTH_NIT, 155 * WIDTH_NIT);
//    flowLayout.sectionInset = UIEdgeInsetsMake(6.5, 37, CGFLOAT_MIN, 37);
    flowLayout.sectionInset = UIEdgeInsetsMake(CGFLOAT_MIN, 30 * WIDTH_NIT, CGFLOAT_MIN, 30 * WIDTH_NIT);
    flowLayout.minimumLineSpacing = CGFLOAT_MIN;
    flowLayout.minimumInteritemSpacing = 60 * WIDTH_NIT;
//    flowLayout.minimumInteritemSpacing = - 60 * WIDTH_NIT;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 6 * WIDTH_NIT, self.width, 155 * WIDTH_NIT) collectionViewLayout:flowLayout];
    [self addSubview:self.collectionView];
    self.collectionView.backgroundColor = HexStringColor(@"#eeeeee");
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView registerClass:[PersonSoundCollectionViewCell class] forCellWithReuseIdentifier:identifier];
    self.collectionView.showsHorizontalScrollIndicator = NO;
    
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(timeAction:) userInfo:nil repeats:YES];
    [timer setFireDate:[NSDate distantPast]];
    
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
//    [[NSRunLoop currentRunLoop] run];
    
}

// 时间方法
- (void)timeAction:(NSTimer *)timer {
    
    if (self.collectionView.contentOffset.x >= self.collectionView.contentSize.width - 118 * WIDTH_NIT * 4) {
        
        self.flag = -1;
        
    } else if (self.collectionView.contentOffset.x <= 0) {
        
        self.flag = 1;
        
    }
    
    
    [self.collectionView setContentOffset:CGPointMake(self.collectionView.contentOffset.x + 118 * WIDTH_NIT * self.flag, self.collectionView.contentOffset.y) animated:YES];

}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.collectionView.frame = CGRectMake(0, 6 * WIDTH_NIT, self.width, 155 * WIDTH_NIT);
    
    [self.collectionView setContentOffset:CGPointMake(118 * WIDTH_NIT * 100, self.collectionView.contentOffset.y)];
    
}

- (void)setDataSource:(NSArray *)dataSource {
//    _dataSource = dataSource;
    
    [self.collectionViewDataSource removeAllObjects];
    
    for (int j = 0; j < 50; j++) {
        for (NSInteger i = 0; i < dataSource.count; i++) {
            [self.collectionViewDataSource addObject:dataSource[i]];
        }
    }
    
    _dataSource = self.collectionViewDataSource;
    
    [self.collectionView reloadData];
    
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (self.dataSource) {
        return self.dataSource.count;
    }
    return 3;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PersonSoundCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    if (self.dataSource.count > indexPath.item) {
        cell.model = self.dataSource[indexPath.item];
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    NSLog(@"%ld", indexPath.item);
    
    PersonSoundCollectionViewCell *cell = (PersonSoundCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    
    if (self.personSoundSelectBlock) {
        self.personSoundSelectBlock(cell);
    }
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
