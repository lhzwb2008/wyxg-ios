//
//  SharePopView.h
//  CreateSongs
//
//  Created by 爱写歌 on 16/7/25.
//  Copyright © 2016年 AXG. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ShareBlock)(NSInteger type);

@interface SharePopView : UIView

@property (nonatomic, strong) UIView *shareView;
@property (nonatomic, strong) UIView *shareMaskView;

@property (nonatomic, strong) UIButton *weChatShare;
@property (nonatomic, strong) UIButton *friendShare;
@property (nonatomic, strong) UIButton *QQShare;
@property (nonatomic, strong) UIButton *QZoneShare;
@property (nonatomic, strong) UIButton *weiboShare;

@property (nonatomic, strong) UILabel *weChatLabel;
@property (nonatomic, strong) UILabel *friendLabel;
@property (nonatomic, strong) UILabel *QQLabel;
@property (nonatomic, strong) UILabel *QZoneLabel;
@property (nonatomic, strong) UILabel *weiboLabel;

@property (nonatomic, strong) UILabel *shareLable;
@property (nonatomic, strong) UIButton *closeButton;

@property (nonatomic, copy) ShareBlock shareBlock;

+ (void)popShareViewOnView:(UIView *)view;

+ (instancetype)defaultPopView;

@end
