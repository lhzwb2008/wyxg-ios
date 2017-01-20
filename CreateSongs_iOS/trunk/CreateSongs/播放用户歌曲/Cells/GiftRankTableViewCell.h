//
//  GiftRankTableViewCell.h
//  CreateSongs
//
//  Created by 爱写歌 on 16/8/26.
//  Copyright © 2016年 AXG. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SelectUserBlock)(NSString *userId);

typedef void(^MoreUserBlock)();

@interface GiftRankTableViewCell : UITableViewCell

@property (nonatomic, strong) UIImageView *emptyImage;

@property (nonatomic, strong) UIView *giftView;

@property (nonatomic, strong) UIImageView *giftHeadImage;

@property (nonatomic, strong) NSMutableArray *giftRankArray;

@property (nonatomic, strong) NSMutableArray *lableArray;

@property (nonatomic, strong) NSMutableArray *buttonArray;

@property (nonatomic, strong) NSArray *giftDataSource;

@property (nonatomic, strong) UIImageView *moreImage;

@property (nonatomic, strong) UIImageView *goldImage;

@property (nonatomic, strong) UIImageView *silverImage;

@property (nonatomic, strong) UIImageView *tongImage;

@property (nonatomic, strong) UILabel *totalGiftLabel;

@property (nonatomic, copy) SelectUserBlock selectUserBlock;

@property (nonatomic, copy) MoreUserBlock moreUserBlock;

@end
