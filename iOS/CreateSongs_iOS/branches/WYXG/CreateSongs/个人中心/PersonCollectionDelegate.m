//
//  PersonCollectionDelegate.m
//  CreateSongs
//
//  Created by 爱写歌 on 16/5/5.
//  Copyright © 2016年 AXG. All rights reserved.
//

#import "PersonCollectionDelegate.h"
#import "AXGHeader.h"
#import "WorkCollectionViewCell.h"


@implementation PersonCollectionDelegate

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - UICollectionViewDataSource

- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    WorkCollectionViewCell* cell = (WorkCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    //设置(Highlight)高亮下的颜色
    [cell.maskView setBackgroundColor:HexStringColor(@"#e5e5e5")];
}

- (void)collectionView:(UICollectionView *)collectionView didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    WorkCollectionViewCell* cell = (WorkCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    
    [cell.maskView setBackgroundColor:[UIColor clearColor]];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    //http://service.woyaoxiege.com/core/home/data/getZuixin?start=0&end=5
    WorkCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:self.indentifier forIndexPath:indexPath];
    cell.indexPath = indexPath;

    
    if (self.pageType == workPage && self.pageCenter == personCenter) {
        cell.moreButton.hidden = NO;
        cell.moreImage.hidden = NO;
        
        cell.headImage.hidden = YES;
        cell.userName.hidden = YES;
//        cell.isMyPersonCenter = YES;
        cell.moreActionBlock = ^(NSString *code, NSString *title) {
            [self moreButtonActionWithCode:code title:title];
        };
    }
    
    if (self.dataSource.count > indexPath.item) {
        cell.dataModel = self.dataSource[indexPath.item];
    }
    
    //    cell.dataModel = self.dataSource[indexPath.row];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat cellWidth = (SCREEN_W-(40*2+35*2)*WIDTH_NIT)/3;
    CGSize titleSize = [@"作品" getWidth:@"作品" andFont:JIACU_FONT(12)];
    return CGSizeMake(cellWidth, cellWidth+12*HEIGHT_NIT+titleSize.height);
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSource.count;
}

//纵间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 25*WIDTH_NIT;
}
// 横向间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 40 * WIDTH_NIT;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(35*WIDTH_NIT, 35*WIDTH_NIT, 25*WIDTH_NIT, 35*WIDTH_NIT);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        
        UICollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:self.headIndentifier forIndexPath:indexPath];

        view.backgroundColor = [UIColor clearColor];
        
        UIButton *headButton = [UIButton new];
        headButton.frame = CGRectMake(0, (200-40) * HEIGHT_NIT, 80 * HEIGHT_NIT, 80 * HEIGHT_NIT);
        headButton.center = CGPointMake(SCREEN_W / 2, headButton.centerY);
        headButton.backgroundColor = [UIColor clearColor];
        [view addSubview:headButton];
        [headButton addTarget:self action:@selector(showHeadImageAction:) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *focusButton = [UIButton new];
        focusButton.frame = CGRectMake(headButton.left - 20 * WIDTH_NIT, self.head_height*HEIGHT_NIT-(18+10+15+12+10+30+25)*HEIGHT_NIT, headButton.width + 40 * WIDTH_NIT, 30 * HEIGHT_NIT);
        focusButton.backgroundColor = [UIColor clearColor];
        [view addSubview:focusButton];
        [focusButton addTarget:self action:@selector(focusButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        
        CGPoint center = focusButton.center;
        focusButton.frame = CGRectMake(0, 0, 85 * WIDTH_NIT, 30 * WIDTH_NIT);
        focusButton.center = CGPointMake(center.x - 12.5 * WIDTH_NIT - 42.5 * WIDTH_NIT, center.y + 12.5 * WIDTH_NIT);
        
        UIButton *sixinButton = [UIButton buttonWithType:UIButtonTypeCustom];
        sixinButton.frame = CGRectMake(focusButton.right + 25 * WIDTH_NIT, focusButton.top, focusButton.width, focusButton.height);
        [view addSubview:sixinButton];
        [sixinButton addTarget:self action:@selector(sixinButtonAction:) forControlEvents:UIControlEventTouchUpInside];
//        focusButton.backgroundColor = [UIColor redColor];
//        sixinButton.backgroundColor = [UIColor greenColor];
        
        if (self.isPersonCenter) {
            [focusButton addTarget:self action:@selector(modifyUserInfoAction:) forControlEvents:UIControlEventTouchUpInside];
        } else {
            [focusButton addTarget:self action:@selector(focusButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        }
        
        for (int i = 0; i < 4; i++) {
            UIButton *button = [UIButton new];
            
//            if (self.isPersonCenter) {
//                button.frame = CGRectMake(0 + SCREEN_W / 4 * i, 200 * HEIGHT_NIT + 120 * HEIGHT_NIT, SCREEN_W / 4, 40 * HEIGHT_NIT);
//            } else {
//                button.frame = CGRectMake(0 + SCREEN_W / 4 * i, 200 * HEIGHT_NIT + 120 * HEIGHT_NIT + 25, SCREEN_W / 4, 40 * HEIGHT_NIT);
//            }
            
            CGFloat hotBtnHeight = (18+20+20)*HEIGHT_NIT;
            
            button.frame = CGRectMake(0 + SCREEN_W / 4 * i, self.head_height*HEIGHT_NIT-hotBtnHeight, SCREEN_W / 4, hotBtnHeight);
            
            [view addSubview:button];
            button.tag = 100 + i;
            button.backgroundColor = [UIColor clearColor];
            [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        }

        return view;
        
    } else if ([kind isEqualToString:UICollectionElementKindSectionFooter]) {
        
        UICollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:self.footIndentifier forIndexPath:indexPath];
        
        return view;
        
    }
    return nil;
}

// 选择作品和喜欢
- (void)buttonAction:(UIButton *)sender {
    
    if (self.collectionSelectTypeBlock) {
        self.collectionSelectTypeBlock(sender.tag - 100);
    }
}

// 私信方法
- (void)sixinButtonAction:(UIButton *)sender {
    
    if (self.sixinButtonBlock) {
        self.sixinButtonBlock();
    }
    
}

// 关注block
- (void)focusButtonAction:(UIButton *)sender {
    if (self.collectionFocusBlock) {
        self.collectionFocusBlock();
    }
}

// 显示头像大图方法
- (void)showHeadImageAction:(UIButton *)sender {
    if (self.showHeadImageBlock) {
        self.showHeadImageBlock();
    }
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    
//    if (self.isPersonCenter) {
//        return CGSizeMake(SCREEN_W, 200 * HEIGHT_NIT + 120 * HEIGHT_NIT + 40 * HEIGHT_NIT + 10 * HEIGHT_NIT);
//    }
    //self.head_height
    return CGSizeMake(SCREEN_W, self.head_height*HEIGHT_NIT);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    return CGSizeZero;
}


// 跳转到播放用户歌曲界面
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    HomePageCollectionViewCell *cell = (HomePageCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    if (self.collectionSelectBlock) {
        self.collectionSelectBlock(indexPath.row, cell);
    }
}

//将图片缩放到指定尺寸
-(UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize {
    UIGraphicsBeginImageContext(newSize);
    
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return newImage;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (self.collectionContentOffsetBlock) {
        self.collectionContentOffsetBlock(scrollView.contentOffset.y);
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (self.collectionEndDrag) {
        self.collectionEndDrag();
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
    if (self.collectionBeginDrag) {
        self.collectionBeginDrag();
    }
}

// 点击头像修改用户信息
- (void)modifyUserInfoAction:(UIButton *)sender {
    if (self.collectionModifyUserInfoBlock) {
        self.collectionModifyUserInfoBlock();
    }
}

// 更多按钮方法
- (void)moreButtonActionWithCode:(NSString *)code title:(NSString *)title {
    if (self.collectionMoreButtonBlock) {
        self.collectionMoreButtonBlock(code, title);
    }
}

@end
