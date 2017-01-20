//
//  PersonCollectionDelegate.h
//  CreateSongs
//
//  Created by 爱写歌 on 16/5/5.
//  Copyright © 2016年 AXG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HomePageCollectionViewCell.h"

typedef enum : NSUInteger {
    workPage,
    likePage,
} PageType;

typedef enum : NSUInteger {
    personCenter,
    otherCenter,
} PageCenter;

typedef void(^CollectionSelectBlock)(NSInteger index, HomePageCollectionViewCell *cell);

typedef void(^CollectionContentOffsetBlock)(CGFloat contentOffsetY);

typedef void(^CollectionSelectTypeBlock)(NSInteger index);

typedef void(^CollectionModifyUserInfoBlock)();

typedef void(^CollectionFocusBlock)();

typedef void(^CollectionMoreButtonBlock)(NSString *code, NSString *title);

typedef void(^ShowHeadImageBlock)();

typedef void(^CollectionBeginDrag)();

typedef void(^CollectionEndDrag)();

typedef void(^SixinButtonBlock)();

@interface PersonCollectionDelegate : NSObject<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate>

@property (nonatomic, assign) PageType pageType;

@property (nonatomic, assign) PageCenter pageCenter;

@property (nonatomic, copy) NSString *indentifier;

@property (nonatomic, copy) NSString *headIndentifier;

@property (nonatomic, copy) NSString *footIndentifier;

@property (nonatomic, strong) NSArray *dataSource;

@property (nonatomic, strong) UIImageView *headImage;

@property (nonatomic, strong) UILabel *nickName;

@property (nonatomic, strong) UILabel *worksCount;

@property (nonatomic, strong) UILabel *worksLabel;

@property (nonatomic, strong) UILabel *likeCount;

@property (nonatomic, strong) UILabel *likeLabel;

@property (nonatomic, strong) UILabel *focusCount;

@property (nonatomic, strong) UILabel *focusLabel;

@property (nonatomic, strong) UILabel *followCount;

@property (nonatomic, strong) UILabel *followLabel;

@property (nonatomic, copy) NSString *likeNum;

@property (nonatomic, copy) NSString *workNum;

@property (nonatomic, copy) NSString *focusNum;

@property (nonatomic, copy) NSString *followNum;

@property (nonatomic, copy) NSString *nick;

@property (nonatomic, strong) UIImage *imageHead;

@property (nonatomic, strong) UIButton *focusButton;

@property (nonatomic, assign) BOOL hasFocused;

@property (nonatomic, assign) BOOL isPersonCenter;

@property (nonatomic, copy) SixinButtonBlock sixinButtonBlock;

@property (nonatomic, copy) CollectionSelectBlock collectionSelectBlock;

@property (nonatomic, copy) CollectionContentOffsetBlock collectionContentOffsetBlock;

@property (nonatomic, copy) CollectionSelectTypeBlock collectionSelectTypeBlock;

@property (nonatomic, copy) CollectionModifyUserInfoBlock collectionModifyUserInfoBlock;

@property (nonatomic, copy) CollectionFocusBlock collectionFocusBlock;

@property (nonatomic, copy) CollectionMoreButtonBlock collectionMoreButtonBlock;

@property (nonatomic, copy) ShowHeadImageBlock showHeadImageBlock;

@property (nonatomic, copy) CollectionBeginDrag collectionBeginDrag;
@property (nonatomic, copy) CollectionEndDrag collectionEndDrag;

@property (nonatomic, assign) CGFloat head_height;

@end
