//
//  UIImage+Extensiton.m
//  A01-QQ聊天列表
//
//  Created by Apple on 14/12/21.
//  Copyright (c) 2014年 itcast. All rights reserved.
//

#import "UIImage+Extensiton.h"

@implementation UIImage (Extensiton)
+ (instancetype)resizeImage:(NSString *)imgName
{
    UIImage *bgImage =  [UIImage imageNamed:imgName];
    //缩放图片
    bgImage = [bgImage stretchableImageWithLeftCapWidth:bgImage.size.width / 2 topCapHeight:bgImage.size.height / 2];
    return bgImage;
}
// --------------------------------------------------

// Resize an image

// --------------------------------------------------

- (UIImage*)transformWidth:(CGFloat)width height:(CGFloat)height {
    
    
    
    CGFloat destW = width;
    
    CGFloat destH = height;
    
    CGFloat sourceW = width;
    
    CGFloat sourceH = height;
    
    
    
    CGImageRef imageRef = self.CGImage;
    
    CGContextRef bitmap = CGBitmapContextCreate(NULL,
                                                
                                                destW,
                                                
                                                destH,
                                                
                                                CGImageGetBitsPerComponent(imageRef),
                                                
                                                4*destW, 
                                                
                                                CGImageGetColorSpace(imageRef),
                                                
                                                (kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst));
    
    
    
    CGContextDrawImage(bitmap, CGRectMake(0, 0, sourceW, sourceH), imageRef);
    
    
    
    CGImageRef ref = CGBitmapContextCreateImage(bitmap);
    
    UIImage *resultImage = [UIImage imageWithCGImage:ref];
    
    CGContextRelease(bitmap);
    
    CGImageRelease(ref);
    
    
    
    return resultImage;
}
- (UIImage *)circleImage {
    
    //1.开启图片图形上下文:注意设置透明度为非透明
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0.0);
    //2.开启图形上下文
    CGContextRef ref = UIGraphicsGetCurrentContext();
    //3.绘制圆形区域(此处根据宽度来设置)
    CGRect rect = CGRectMake(0, 0, self.size.width, self.size.width);
    CGContextAddEllipseInRect(ref, rect);
    //4.裁剪绘图区域
    CGContextClip(ref);
    
    //5.绘制图片
    [self drawInRect:rect];
    
    //6.获取图片
    UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
    //7.关闭图形上下文
    UIGraphicsEndImageContext();
    
    return image;
}
+(UIColor *)colorAtPoint:(CGPoint)point{
    UIWindow *screenWindow = [[UIApplication sharedApplication] keyWindow];
    UIGraphicsBeginImageContext(screenWindow.frame.size);//全屏截图，包括window
    
    [screenWindow.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    
    
    if (!CGRectContainsPoint(CGRectMake(0.0f, 0.0f, viewImage.size.width, viewImage.size.height), point)) {
        
        return nil;
        
    }
    
    
    NSInteger pointX = trunc(point.x);
    
    NSInteger pointY = trunc(point.y);
    
    CGImageRef cgImage = viewImage.CGImage;
    
    NSUInteger width = viewImage.size.width;
    
    NSUInteger height = viewImage.size.height;
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    int bytesPerPixel = 4;
    
    int bytesPerRow = bytesPerPixel * 1;
    
    NSUInteger bitsPerComponent = 8;
    
    unsigned char pixelData[4] = { 0, 0, 0, 0 };
    
    CGContextRef context = CGBitmapContextCreate(pixelData,
                                                 
                                                 1,
                                                 
                                                 1,
                                                 
                                                 bitsPerComponent,
                                                 
                                                 bytesPerRow,
                                                 
                                                 colorSpace,
                                                 
                                                 kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    
    CGColorSpaceRelease(colorSpace);
    
    CGContextSetBlendMode(context, kCGBlendModeCopy);
    
    
    // Draw the pixel we are interested in onto the bitmap context
    
    CGContextTranslateCTM(context, -pointX, pointY-(CGFloat)height);
    
    CGContextDrawImage(context, CGRectMake(0.0f, 0.0f, (CGFloat)width, (CGFloat)height), cgImage);
    
    CGContextRelease(context);
    
    // Convert color values [0..255] to floats [0.0..1.0]
    
    CGFloat red = (CGFloat)pixelData[0] / 255.0f;
    
    CGFloat green = (CGFloat)pixelData[1] / 255.0f;
    
    CGFloat blue = (CGFloat)pixelData[2] / 255.0f;
    
    CGFloat alpha = (CGFloat)pixelData[3] / 255.0f;
    
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

@end
