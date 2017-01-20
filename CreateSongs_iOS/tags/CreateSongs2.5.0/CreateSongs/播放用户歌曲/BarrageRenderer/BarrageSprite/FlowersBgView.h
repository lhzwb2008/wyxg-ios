//
//  FlowersBgView.h
//  CreateSongs
//
//  Created by axg on 16/8/24.
//  Copyright © 2016年 AXG. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FlowersBgView : UIView

@property (nonatomic, strong) NSMutableArray *cacheEmitterLayers;

@property (nonatomic, assign) BOOL isCleared;

@property (nonatomic, strong) CAEmitterLayer *emitterLayer;

@end
