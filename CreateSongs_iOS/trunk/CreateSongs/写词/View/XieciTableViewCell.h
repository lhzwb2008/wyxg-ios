//
//  XieciTableViewCell.h
//  CreateSongs
//
//  Created by 爱写歌 on 16/4/27.
//  Copyright © 2016年 AXG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InputTextView.h"

typedef void(^AddBlock)();

typedef void(^SubBlock)();

@interface XieciTableViewCell : UITableViewCell

@property (nonatomic, strong) InputTextView *inputText;

@property (nonatomic, strong) UIImageView *subImage;

@property (nonatomic, strong) UIImageView *addImage;

@property (nonatomic, strong) UIButton *subButton;

@property (nonatomic, strong) UIButton *addButton;

@property (nonatomic, copy) AddBlock addBlock;

@property (nonatomic, copy) SubBlock subBlock;

@end
