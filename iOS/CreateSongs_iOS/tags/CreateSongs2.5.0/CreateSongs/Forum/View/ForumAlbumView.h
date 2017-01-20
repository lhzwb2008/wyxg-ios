//
//  ForumAlbumView.h
//  CreateSongs
//
//  Created by 爱写歌 on 16/9/8.
//  Copyright © 2016年 AXG. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^TouchAlbumBlock)();

@interface ForumAlbumView : UIView

@property (nonatomic, strong) UIImageView *themeImage;

@property (nonatomic, strong) UIImageView *maskImage;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UILabel *lyricLabel;

@property (nonatomic, strong) UILabel *songLabel;

@property (nonatomic, strong) UILabel *singerLabel;

@property (nonatomic, strong) UIButton *button;

@property (nonatomic, copy) NSString *code;

@property (nonatomic, copy) TouchAlbumBlock touchAlbumBlock;

- (void)resetFrame;

@end
