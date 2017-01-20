//
//  ForumCommentFrameModel.h
//  CreateSongs
//
//  Created by axg on 16/7/27.
//  Copyright © 2016年 AXG. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>
#import "ForumCommentsModel.h"

@interface ForumCommentFrameModel : NSObject

@property (nonatomic, assign) CGRect bgFrame;

@property (nonatomic, assign) CGRect userHeadFrame;
@property (nonatomic, assign) CGRect userNameFrame;
@property (nonatomic, assign) CGRect userContentFrame;
@property (nonatomic, assign) CGRect timeLabelFrame;

@property (nonatomic, assign) CGFloat cellHeight;

@property (nonatomic, strong) ForumCommentsModel *commentsModel;

@end
