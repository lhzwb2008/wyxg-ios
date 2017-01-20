//
//  AXGMusicPlayer.m
//  CreateSongs
//
//  Created by 爱写歌 on 16/3/7.
//  Copyright © 2016年 AXG. All rights reserved.
//

#import "AXGMusicPlayer.h"

@implementation AXGMusicPlayer

//// 便利构造器创建播放器
//+ (AXGMusicPlayer *)shareMusicPlayer {
//    static AXGMusicPlayer *player = nil;
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        player = [[AXGMusicPlayer alloc] init];
//    });
//    return player;
//}

- (void)playWithUrl:(NSString *)url {
    

        self.item = [[AVPlayerItem alloc] initWithURL:[NSURL URLWithString:url]];
        
        [self replaceCurrentItemWithPlayerItem:self.item];
        [self play];
}

- (void)playWithPathUrl:(NSString *)pathUrl {
    self.item = [[AVPlayerItem alloc] initWithURL:[NSURL fileURLWithPath:pathUrl]];
    [self replaceCurrentItemWithPlayerItem:self.item];
    [self play];
}

@end
