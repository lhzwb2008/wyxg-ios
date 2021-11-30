//
//  UIImage+Extensiton.h
//  A01-QQ聊天列表
//
//  Created by Apple on 14/12/21.
//  Copyright (c) 2014年 itcast. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Extensiton)
+ (instancetype)resizeImage:(NSString *)imgName;

- (UIImage*)transformWidth:(CGFloat)width height:(CGFloat)height;

// 切割圆形图片（正方形图片）
- (UIImage *)circleImage;

+(UIColor *)colorAtPoint:(CGPoint)point;

@end
