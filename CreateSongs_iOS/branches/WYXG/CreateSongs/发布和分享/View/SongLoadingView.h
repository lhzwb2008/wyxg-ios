//
//  SongLoadingView.h
//  CreateSongs
//
//  Created by 爱写歌 on 16/7/27.
//  Copyright © 2016年 AXG. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GifView;

@interface SongLoadingView : UIView

@property (nonatomic, strong) GifView *gifView;

@property (nonatomic, strong) UIView *progressView;

@property (nonatomic, strong) NSArray *tipsArray;

@property (nonatomic, strong) UILabel *tipsLabel;

- (void)initAction;

- (void)stopAnimate;

@end
