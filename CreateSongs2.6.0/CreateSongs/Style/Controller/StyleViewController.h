//
//  StyleViewController.h
//  CreateSongs
//
//  Created by 爱写歌 on 16/7/19.
//  Copyright © 2016年 AXG. All rights reserved.
//

#import "BaseViewController.h"

@interface StyleViewController : BaseViewController

/**
 *  主唱
 */
@property (nonatomic, assign) NSInteger source;
/**
 *  伴奏
 */
@property (nonatomic, assign) NSInteger genere;
/**
 *  心情
 */
@property (nonatomic, assign) NSInteger emotion;
/**
 *  曲速
 */
@property (nonatomic, assign) CGFloat rate;
/**
 *  是否改曲
 */
@property (nonatomic, assign) BOOL isChangeSong;

@end
