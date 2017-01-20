//
//  PaySureController.h
//  CreateSongs
//
//  Created by axg on 16/8/16.
//  Copyright © 2016年 AXG. All rights reserved.
//

#import "BaseViewController.h"

@interface PaySureController : BaseViewController

@property (nonatomic, copy) NSString *user_id;
@property (nonatomic, copy) NSString *song_id;

@property (nonatomic, assign) NSInteger checkWXPayNum;

@end
