//
//  BottomScaleBtn.h
//  CreateSongs
//
//  Created by axg on 16/8/3.
//  Copyright © 2016年 AXG. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BottomScaleDelegate;

@interface BottomScaleBtn : UIButton

@property (nonatomic, assign) CGPoint startPoint;
@property (nonatomic, assign) CGPoint endPoint;
@property (nonatomic, assign) CGPoint nearPoint;
@property (nonatomic, assign) CGPoint farPoint;
@property (nonatomic, assign) id<BottomScaleDelegate> delegate;

@end

@protocol BottomScaleDelegate <NSObject>

- (void)quadCurveMenuItemTouchesBegan:(BottomScaleBtn *)item;

- (void)quadCurveMenuItemTouchesEnd:(BottomScaleBtn *)item;



@end