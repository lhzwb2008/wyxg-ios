//
//  FlowersBgView.m
//  CreateSongs
//
//  Created by axg on 16/8/24.
//  Copyright © 2016年 AXG. All rights reserved.
//

#import "FlowersBgView.h"

@implementation FlowersBgView

- (NSMutableArray *)cacheEmitterLayers {
    if (_cacheEmitterLayers == nil) {
        _cacheEmitterLayers = [NSMutableArray array];
    }
    return _cacheEmitterLayers;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        NSMutableArray *imagesArray = [NSMutableArray array];
        for (NSInteger i = 2; i < 15; i++) {
            NSString *name = [NSString stringWithFormat:@"图层-%ld", i];
            UIImage *image = [UIImage imageNamed:name];
            if (image) {
                [imagesArray addObject:image];
            }
        }
        [self shootFrom:CGPointMake(frame.size.width-100, frame.size.height / 2 - 5) Level:10 Cells:imagesArray];
    }
    return self;
}

//- (void)willRemoveSubview:(UIView *)subview {
//    [super willRemoveSubview:subview];
//    self.emitterLayer.birthRate = 0;
//    [self.emitterLayer removeFromSuperlayer];
//    [self.cacheEmitterLayers removeObject:self.emitterLayer];
//}

- (void)shootFrom:(CGPoint)position Level:(int)level Cells:(NSArray <UIImage *>*)imagesArray; {
    
    CGPoint emiterPosition = position;
    // 配置发射器
    self.emitterLayer = [CAEmitterLayer layer];
    self.emitterLayer.emitterPosition = emiterPosition;
    //发射源的尺寸大小
    self.emitterLayer.emitterSize     = CGSizeMake(10, 20);
    //发射模式
    self.emitterLayer.emitterMode     = kCAEmitterLayerOutline;
    //发射源的形状
    self.emitterLayer.emitterShape    = kCAEmitterLayerLine;
    self.emitterLayer.renderMode      = kCAEmitterLayerOldestLast;
    
    [self.layer addSublayer:self.emitterLayer];
    
    NSMutableArray *cellArray = [NSMutableArray array];
    
    NSInteger i = 0;
    for (UIImage *contentImage in imagesArray) {
        CAEmitterCell *snowflake          = [CAEmitterCell emitterCell];
        snowflake.name                    = [NSString stringWithFormat:@"sprite%ld", i++];
        //粒子参数的速度乘数因子
        snowflake.birthRate               = level;
        snowflake.lifetime                = 1;
        //粒子速度
        snowflake.velocity                = 10;
        //粒子的速度范围
        snowflake.velocityRange           = 50;
        //粒子y方向的加速度分量
        snowflake.xAcceleration           = 100;
        //snowflake.xAcceleration = 200;
        //周围发射角度
        snowflake.emissionRange           = 0.5*M_PI;
        //    snowflake.emissionLatitude = 200;
        snowflake.emissionLongitude       = 0.5*M_PI;//
        //子旋转角度范围
        snowflake.spinRange               = M_PI;
        
        snowflake.alphaRange = 0.9;
        snowflake.alphaSpeed = 0.1;
        
        snowflake.contents                = (id)[contentImage CGImage];
        snowflake.contentsScale = 0.9;
        snowflake.scale                   = 0.1;
        snowflake.scaleSpeed              = 0.1;
        
        [cellArray addObject:snowflake];
    }
    
    self.emitterLayer.emitterCells  = cellArray;
    [self.cacheEmitterLayers addObject:self.emitterLayer];
    
    //    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    //        if (_isCleared)return ;
    //        self.emitterLayer.birthRate = 0;
    //        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    //            if (_isCleared)return ;
    //            [emitterLayer removeFromSuperlayer];
    //            [self.cacheEmitterLayers removeObject:emitterLayer];
    //        });
    //    });
}

@end
