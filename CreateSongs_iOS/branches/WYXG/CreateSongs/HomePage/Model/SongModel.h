//
//  SongModel.h
//  CreateSongs
//
//  Created by 爱写歌 on 16/7/14.
//  Copyright © 2016年 AXG. All rights reserved.
//

#import "JSONModel.h"

@interface SongModel : JSONModel

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
 *  活动id
 */
@property (nonatomic, copy) NSString *activity_id;
/**
 *  标签
 */
@property (nonatomic, copy) NSString *tag;
/**
 *  是否演唱
 */
@property (nonatomic, copy) NSString *sing;
/**
 *  是否改曲
 */
@property (nonatomic, copy) NSString *gai;
/**
 *  是否是好歌词
 */
@property (nonatomic, copy) NSString *is_haogeci;
/**
 *  歌词 大部分时候是没有的，只有在优质歌词的接口里才有
 */
@property (nonatomic, copy) NSString *geci;
/**
 *  歌单id
 */
@property (nonatomic, copy) NSString *gedan_id;
/**
 *  原始歌名
 */
@property (nonatomic, copy) NSString *original_title;
/**
 *  作词id
 */
@property (nonatomic, copy) NSString *zuoci_id;
/**
 *  作曲id
 */
@property (nonatomic, copy) NSString *zuoqu_id;
/**
 *  演唱id
 */
@property (nonatomic, copy) NSString *yanchang_id;
/**
 *  是否是来自走音方式的歌曲  不是0则是
 */
@property (nonatomic, copy) NSString *template_id;

@end
