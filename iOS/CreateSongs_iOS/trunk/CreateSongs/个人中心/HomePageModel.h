//
//  HomePageModel.h
//  CreateSongs
//
//  Created by axg on 16/4/25.
//  Copyright © 2016年 AXG. All rights reserved.
//

#import "JSONModel.h"

@protocol HomePageUserMess <NSObject>
@end

@interface HomePageUserMess : JSONModel

/**
 *  应该就是song_id
 */
@property (nonatomic, copy) NSString *dataId;
/**
 *  用户id
 */
@property (nonatomic, copy) NSString *user_id;
/**
 *  用户名
 */
@property (nonatomic, copy) NSString *user_name;
///**
// *  用户手机号
// */
//@property (nonatomic, copy) NSString *user_phone;
/**
 *  歌曲名字(加密后的)
 */
@property (nonatomic, copy) NSString *code;
/**
 *  点赞数
 */
@property (nonatomic, copy) NSString *up_count;
/**
 *
 */
@property (nonatomic, copy) NSString *is_recommended;
/**
 *  创建日期
 */
@property (nonatomic, copy) NSString *create_time;
/**
 *  修改日期
 */
@property (nonatomic, copy) NSString *modify_time;
/**
 *  播放数
 */
@property (nonatomic, copy) NSString *play_count;
/**
 *  被举报数
 */
@property (nonatomic, copy) NSString *cheat_count;
/**
 *  是否公开
 */
@property (nonatomic, copy) NSString *isPublic;
/**
 *  歌曲名
 */
@property (nonatomic, copy) NSString *title;
/**
 *  设备信息
 */
@property (nonatomic, copy) NSString *device;
/**
 *  原始歌名
 */
@property (nonatomic, copy) NSString *original_title;


@end

@interface HomePageModel : JSONModel
/**
 *  歌曲信息
 */
@property (nonatomic, strong) NSMutableArray<HomePageUserMess> *songs;
/**
 *  请求结果状态
 */
@property (nonatomic, copy) NSString *status;

@end
