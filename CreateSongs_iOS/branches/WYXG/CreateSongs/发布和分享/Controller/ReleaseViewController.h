//
//  ReleaseViewController.h
//  CreateSongs
//
//  Created by 爱写歌 on 16/7/18.
//  Copyright © 2016年 AXG. All rights reserved.
//

#import "BaseViewController.h"

@interface ReleaseViewController : BaseViewController

@property (nonatomic, copy) NSString *songName;

@property (nonatomic, copy) NSString *singer;

@property (nonatomic, strong) UIImage *themeImage;

@property (nonatomic, strong) UIImageView *themeImageView;

@property (nonatomic, copy) NSString *webUrl;

@property (nonatomic, copy) NSString *mp3Url;

@end
