//
//  VoiceSettingController.h
//  CreateSongs
//
//  Created by axg on 16/8/22.
//  Copyright © 2016年 AXG. All rights reserved.
//

#import "BaseViewController.h"

@interface VoiceSettingController : BaseViewController

@property (nonatomic, copy) NSString *shareUrl;
@property (nonatomic, copy) NSString *mp3Url;
@property (nonatomic, copy) NSString *recoderPath;
@property (nonatomic, copy) NSString *banzouPath;
@property (nonatomic, strong) NSArray *lrcDataSource;
@property (nonatomic, copy) NSString *songName;

@property (nonatomic, copy) NSString *code;

@end
