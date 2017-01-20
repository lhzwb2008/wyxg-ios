//
//  PersonTableDelegate.h
//  CreateSongs
//
//  Created by 爱写歌 on 16/5/5.
//  Copyright © 2016年 AXG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FocusTableViewCell.h"

typedef enum : NSUInteger {
    focusPage,
    followPage,
} TablePageType;

typedef void(^TableSelectBlock)(NSInteger index, FocusTableViewCell *cell);

typedef void(^TableContentOffsetBlock)(CGFloat contentOffsetY);

typedef void(^TableSelectTypeBlock)(NSInteger index);

typedef void(^TableModifyUserInfoBlock)();

typedef void(^TableFocusBlock)();

typedef void(^ShowHeadImageBlock)();

typedef void(^TableBeginDrag)();

typedef void(^TableEndDrag)();

typedef void(^SixinButtonBlock)();

@interface PersonTableDelegate : NSObject<UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate>

@property (nonatomic, copy) NSString *indentifier;

@property (nonatomic, strong) NSArray *dataSource;

@property (nonatomic, assign) TablePageType pageType;

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

@property (nonatomic, copy) TableSelectBlock tableSelectBlock;

@property (nonatomic, copy) TableSelectTypeBlock tableSelectTypeBlock;

@property (nonatomic, copy) TableContentOffsetBlock tableContentOffsetBlock;

@property (nonatomic, copy) TableModifyUserInfoBlock tableModifyUserInfoBlock;

@property (nonatomic, copy) TableFocusBlock tableFocusBlock;

@property (nonatomic, copy) ShowHeadImageBlock showHeadImageBlock;

@property (nonatomic, copy) TableBeginDrag tableBeginDrag;
@property (nonatomic, copy) TableEndDrag tableEndDrag;

@property (nonatomic, assign) CGFloat head_height;

@end
