//
//  RecommandTableViewCell.m
//  CreateSongs
//
//  Created by 爱写歌 on 16/7/14.
//  Copyright © 2016年 AXG. All rights reserved.
//

#import "RecommandTableViewCell.h"
#import "AXGHeader.h"
#import "RecommandCollectionViewCell.h"

static NSString *const identifier = @"identififier";

@implementation RecommandTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createCell];
    }
    return self;
}

- (void)createCell {
    
    self.backgroundColor = [UIColor whiteColor];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake(75 * WIDTH_NIT, 122 * WIDTH_NIT);
    flowLayout.sectionInset = UIEdgeInsetsMake(6.5 * WIDTH_NIT, 37 * WIDTH_NIT, CGFLOAT_MIN, 37 * WIDTH_NIT);
    flowLayout.minimumLineSpacing = 6.5 * WIDTH_NIT;
    flowLayout.minimumInteritemSpacing = 38 * WIDTH_NIT;
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:flowLayout];
    self.collectionView.backgroundColor = [UIColor clearColor];
    [self addSubview:self.collectionView];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.scrollEnabled = NO;
    [self.collectionView registerClass:[RecommandCollectionViewCell class] forCellWithReuseIdentifier:identifier];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.collectionView.frame = self.bounds;
}

- (void)setDataSource:(NSArray *)dataSource {
    if (!_dataSource) {
        _dataSource = dataSource;
    }
    
    [self.collectionView reloadData];
    
}

#pragma mark - UICollectionViewDataSource
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    RecommandCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    if (self.dataSource.count > indexPath.item) {
        cell.model = self.dataSource[indexPath.item];
        NSLog(@"获取item %ld", indexPath.item);
    }
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    if (self.dataSource) {
        return self.dataSource.count;
    }
    return 6;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"@@@@@");
    
    RecommandCollectionViewCell *cell = (RecommandCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    
    if (self.selectItemBlock) {
        self.selectItemBlock(indexPath.item, cell);
    }
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    RecommandCollectionViewCell* cell = (RecommandCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    //设置(Highlight)高亮下的颜色
    [cell.maskView setBackgroundColor:HexStringColor(@"#e5e5e5")];
}

- (void)collectionView:(UICollectionView *)collectionView didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    RecommandCollectionViewCell* cell = (RecommandCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];

    [cell.maskView setBackgroundColor:[UIColor clearColor]];
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
