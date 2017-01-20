//
//  GifView.h
//  CreateSongs
//
//  Created by Hope on 16/2/26.
//  Copyright © 2016年 Hope. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <imageio/imageio.h>
@interface GifView : UIView{
    CGImageSourceRef gif; // 保存gif动画
    NSDictionary *gifProperties; // 保存gif动画属性
    size_t index; // gif动画播放开始的帧序号
    size_t count; // gif动画的总帧数
    NSTimer *timer; // 播放gif动画所使用的timer
}

- (id)initWithFrame:(CGRect)frame filePath:(NSString *)_filePath;
- (id)initWithFrame:(CGRect)frame data:(NSData *)_data;
- (void)loadData:(NSData *)_data;
- (id)initWithFrame:(CGRect)frame;
- (void)stopGif;
- (void)replay;
@end
