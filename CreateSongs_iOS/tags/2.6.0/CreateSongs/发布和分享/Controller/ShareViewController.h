//
//  ShareViewController.h
//  CreateSongs
//
//  Created by 爱写歌 on 16/7/23.
//  Copyright © 2016年 AXG. All rights reserved.
//

#import "BaseViewController.h"

@interface ShareViewController : BaseViewController

@property (nonatomic, copy) NSString *songTitle;
@property (nonatomic, copy) NSString *mp3Url;
@property (nonatomic, copy) NSString *webUrl;
@property (nonatomic, copy) NSString *lyricStr;
@property (nonatomic, strong) UIImageView *shareImage;
@property (nonatomic, copy) NSString *lrcUrl;
@property (nonatomic, strong) UIImage *image;

@property (nonatomic, assign) BOOL isAgree;

@property (nonatomic, strong) NSString *songWriter;

@end
