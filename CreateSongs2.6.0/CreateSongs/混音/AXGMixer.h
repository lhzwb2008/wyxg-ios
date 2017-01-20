//
//  AXGMixer.h
//  CreateSongs
//
//  Created by axg on 16/8/1.
//  Copyright © 2016年 AXG. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AXGMixer : NSObject

/**
 *  开始混音
 *
 *  @param mp3s    MP3路径 2个 若增加个数需要修改代码
 *  @param success 成功回调
 *  @param result  失败回调
 */
- (void)mixerMP3Files:(NSArray *)mp3Names withVolumes:(NSArray *)volumes success:(void(^)(NSString *path))success error:(void(^)(NSError *error))result;

/**
 *  开始切割长度
 *
 *  @param mp3s    MP3路径 切割前边一个
 *  @param success 成功回调
 *  @param result  失败回调
 */
- (void)getCutMP3File:(NSArray *)mp3Names withVolumes:(NSArray *)volumes success:(void(^)(NSString *path))success error:(void(^)(NSError *error))result;

@end
