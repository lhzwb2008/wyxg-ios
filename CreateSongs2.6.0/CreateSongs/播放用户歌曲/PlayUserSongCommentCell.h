//
//  PlayUserSongCommentCell.h
//  CreateSongs
//
//  Created by axg on 16/5/3.
//  Copyright © 2016年 AXG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommentUserFrameModel.h"
#import "PlayUserUpBtn.h"

typedef void(^HeadClickBlock)(NSString *user_id);
typedef void(^CommentClickBlock)(NSString *userName, NSString *user_id, NSString *commentsId);

@interface PlayUserSongCommentCell : UITableViewCell

@property (nonatomic, strong) UIImageView *thumbView;

@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, copy) NSString *user_id;

@property (nonatomic, copy) NSString *userName;

@property (nonatomic, assign) BOOL isUped;

@property (nonatomic, assign) NSInteger upCount;

@property (nonatomic, strong) PlayUserUpBtn *upBtn;

@property (nonatomic, strong) UIButton *commentClickButton;

@property (nonatomic, strong) CommentUserFrameModel *userFrameModel;

@property (nonatomic, copy) HeadClickBlock headClickBlock;

@property (nonatomic, copy) CommentClickBlock commentClickBlock;

@property (nonatomic, copy) NSString *originName;

+ (instancetype)customCommentCell:(UITableView *)tableView;

@end
