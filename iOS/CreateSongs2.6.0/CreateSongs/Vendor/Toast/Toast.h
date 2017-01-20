//
//  Toast.h
//  CreateSongs
//
//  Created by Hope on 16/2/15.
//  Copyright © 2016年 Hope. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Toast : UIView
+(id)toastWithView:(UIView *)view
             title:(NSString *)title
         timestamp:(CGFloat)time;
- (void)show;
@end
