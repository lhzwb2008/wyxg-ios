//
//  AXGMusicPlayer.h
//  CreateSongs
//
//  Created by 爱写歌 on 16/3/7.
//  Copyright © 2016年 AXG. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>

@interface AXGMusicPlayer : AVPlayer

//+ (AXGMusicPlayer *)shareMusicPlayer;

@property (nonatomic, strong) AVPlayerItem *item;

- (void)playWithUrl:(NSString *)url;
// 播放本地文件
- (void)playWithPathUrl:(NSString *)pathUrl;

@end
