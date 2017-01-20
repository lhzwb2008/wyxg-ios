//
//  AXGStartView.h
//  CreateSongs
//
//  Created by axg on 16/9/1.
//  Copyright © 2016年 AXG. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AXGStartView : UIView

+ (instancetype)startView;

- (void)startAnimationWithCompletionBlock:(void(^)(AXGStartView *easeStartView))completionHandler;

@end
