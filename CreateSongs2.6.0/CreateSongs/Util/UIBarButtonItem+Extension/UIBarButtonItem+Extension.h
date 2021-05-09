//
//  UIBarButtonItem+Extension.h
//
//  Created by apple on 14-7-3.
//  Copyright (c) 2016年 . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+Common.h"

@interface UIBarButtonItem (Extension)
+ (UIBarButtonItem *)itemWithImageName:(NSString *)imageName target:(id)target action:(SEL)action;
@end
