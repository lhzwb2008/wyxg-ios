//
//  ActivityModel.h
//  CreateSongs
//
//  Created by 爱写歌 on 16/7/5.
//  Copyright © 2016年 AXG. All rights reserved.
//

#import "JSONModel.h"

@interface ActivityModel : JSONModel

/**
 *  活动id
 */
@property (nonatomic, copy) NSString *dataId;

/**
 *  活动名
 */
@property (nonatomic, copy) NSString *name;

/**
 *  活动描述
 */
@property (nonatomic, copy) NSString *content;

/**
 *  活动图片
 */
@property (nonatomic, copy) NSString *img;

/**
 *  修改时间
 */
@property (nonatomic, copy) NSString *modify_time;

/**
 *  创建时间
 */
@property (nonatomic, copy) NSString *create_time;

/**
 *  是否上线 1上线，0未上线 这里是字符串，不是nsnumber
 */
@property (nonatomic, copy) NSString *status;

@end
