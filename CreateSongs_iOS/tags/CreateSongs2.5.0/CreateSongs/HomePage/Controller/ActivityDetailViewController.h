//
//  ActivityDetailViewController.h
//  CreateSongs
//
//  Created by 爱写歌 on 16/8/1.
//  Copyright © 2016年 AXG. All rights reserved.
//

#import "BaseViewController.h"

@interface ActivityDetailViewController : BaseViewController

@property (nonatomic, assign) BOOL needRefresh;

@property (nonatomic, copy) NSString *activityName;

@property (nonatomic, strong) UIImage *image;

@property (nonatomic, copy) NSString *activitiId;

@property (nonatomic, assign) NSInteger startIndex;

@property (nonatomic, assign) NSInteger length;

@end
