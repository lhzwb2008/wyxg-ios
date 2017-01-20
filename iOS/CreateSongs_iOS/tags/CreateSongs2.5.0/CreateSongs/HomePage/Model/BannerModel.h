//
//  BannerModel.h
//  CreateSongs
//
//  Created by 爱写歌 on 16/7/18.
//  Copyright © 2016年 AXG. All rights reserved.
//

#import "JSONModel.h"

@interface BannerModel : JSONModel

@property (nonatomic, copy) NSString *dataId;

@property (nonatomic, copy) NSString *img;

@property (nonatomic, copy) NSString *url;

@property (nonatomic, copy) NSString *create_time;

@property (nonatomic, copy) NSString *modify_time;

@end
