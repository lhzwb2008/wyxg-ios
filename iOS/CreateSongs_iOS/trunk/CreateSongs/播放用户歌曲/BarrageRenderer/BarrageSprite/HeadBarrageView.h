//
//  HeadBarrageView.h
//  CreateSongs
//
//  Created by axg on 16/8/15.
//  Copyright © 2016年 AXG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AXGHeader.h"
#import "HJCornerRadius.h"
#import "UIImageView+CornerRadius.h"

@interface HeadBarrageView : UIView

@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *text;
@property (nonatomic, copy) NSString *upCount;
@property (nonatomic, copy) NSString *headUrl;

@property (nonatomic, strong) UILabel *bgView;
@property (nonatomic, strong) UIImageView *headImageView;
@property (nonatomic, strong) UILabel *textLabel;
@property (nonatomic, strong) UILabel *userNameLabel;
@property (nonatomic, strong) UILabel *upCountLabel;

@end
