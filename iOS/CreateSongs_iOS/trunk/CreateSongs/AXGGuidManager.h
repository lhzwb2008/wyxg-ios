//
//  AXGGuidManager.h
//  CreateSongs
//
//  Created by axg on 16/9/18.
//  Copyright © 2016年 AXG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface AXGGuidManager : NSObject

@property (nonatomic, strong) UIView *homeGuidView;
@property (nonatomic, strong) UIView *draftsGuidView;
@property (nonatomic, strong) UIView *tyGuidView;

+ (instancetype)sharedAXGGuidManager;

+ (void)showHomeGuidUnderView:(UIView *)view;

+ (void)showDraftsGuidUnderView:(UIView *)view;

+ (void)showTYGuidUnderView:(UIView *)view;

+ (void)beginAnimageForNote;

@end
