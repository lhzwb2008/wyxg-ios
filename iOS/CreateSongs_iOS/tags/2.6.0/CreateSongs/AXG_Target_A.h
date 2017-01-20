//
//  AXG_Target_A.h
//  CreateSongs
//
//  Created by axg on 16/9/6.
//  Copyright © 2016年 AXG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface AXG_Target_A : NSObject

- (id)Action_showAlert:(NSDictionary *)params;

- (UIViewController *)Action_webController:(NSDictionary *)params;

- (UIViewController *)Action_nativeController:(NSDictionary *)params;

- (UIView *)Action_share:(NSDictionary *)params;

@end
