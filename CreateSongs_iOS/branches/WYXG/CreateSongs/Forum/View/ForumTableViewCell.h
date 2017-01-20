//
//  ForumTableViewCell.h
//  CreateSongs
//
//  Created by 爱写歌 on 16/7/6.
//  Copyright © 2016年 AXG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ForumModel.h"
#import "ForumAlbumView.h"

typedef enum : NSUInteger {
    ImageAndAlbumNone,
    ImageOnly,
    AlbumOnly,
    ImageAndAlbum,
} ContentType;

@interface ForumTableViewCell : UITableViewCell

@property (nonatomic, strong) UIImageView *headImage;

@property (nonatomic, strong) UIImageView *themeImage;

@property (nonatomic, strong) UILabel *nameLabel;

@property (nonatomic, strong) UILabel *contentLabel;

@property (nonatomic, strong) UILabel *timeLabel;

@property (nonatomic, strong) UIImageView *replyImage;

@property (nonatomic, strong) UILabel *replyNumber;

@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) UIImageView *genderImage;

@property (nonatomic, strong) UILabel *topLabel;

@property (nonatomic, strong) ForumAlbumView *albumView;

@property (nonatomic, strong) ForumModel *forumModel;

@property (nonatomic, assign) ContentType contentType;

@end
