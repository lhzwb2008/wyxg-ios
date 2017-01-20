//
//  CommentUserFrameModel.h
//  CreateSongs
//
//  Created by axg on 16/5/3.
//  Copyright © 2016年 AXG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CommentUserModel.h"
#import <UIKit/UIKit.h>

@interface CommentUserFrameModel : NSObject

@property (nonatomic, assign) CGRect bgFrame;

@property (nonatomic, assign) CGRect userHeadFrame;
@property (nonatomic, assign) CGRect userNameFrame;
@property (nonatomic, assign) CGRect userContentFrame;
@property (nonatomic, assign) CGRect timeLabelFrame;
@property (nonatomic, assign) CGRect upBtnFrame;

@property (nonatomic, assign) CGFloat cellHeight;

@property (nonatomic, strong) UserCommentsModel *commentModel;

@end
