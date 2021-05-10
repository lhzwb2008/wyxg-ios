//
//  AXGHeader.h
//  CreateSongs
//
//  Created by 爱写歌 on 16/7/13.
//  Copyright © 2016年 AXG. All rights reserved.
//

#ifndef AXGHeader_h
#define AXGHeader_h

#pragma mark - /*****************需要引入的头文件*******************/
#import "UIView+UIViewAdditions.h"
#import "UIView+Common.h"
#import "XWAFNetworkTool.h"
#import "UIColor+expanded.h"
#import "UIResponder+FirstResponder.h"
#import "MBProgressHUD+MJ.h"
#import "YTKKeyValueStore.h"
#import "UIColor+expanded.h"
#import "NSString+Common.h"
#import "AXGTools.h"
#import "UIImageView+WebCache.h"

#pragma mark - /*****************参数设置*******************/

/**
 *  特粗字体
 */
#define TECU_FONT(font) [UIFont fontWithName:@"HelveticaNeue-CondensedBold" size:(font)]

/**
 *  加粗字体
 */
#define JIACU_FONT(font) [UIFont fontWithName:@"HelveticaNeue-Bold" size:(font)]
/**
 *  常规字体
 */
#define NORML_FONT(font) [UIFont fontWithName:@"HelveticaNeue" size:(font)]
/**
 *  中等字体
 */
#define ZHONGDENG_FONT(font) [UIFont fontWithName:@"HelveticaNeue-Medium" size:(font)]
/**
 *  数据库名称
 */
#define DB_NAME @"Drafts_DB_Name_2.1"
#define TIANCI_DB   @"tianci_DB_Name"
#define TABLE_NAME @"Drafts_Table_Name"
#define RECODER_DB  @"recoder_db_name"

// 402
#define PERSON_HEAD_HEIGHT  390
// 是否是测试模式
#define IS_TEST       @"is_test"
#define IS_TEST_YES   @"is_test_yes"
#define IS_TEST_NO    @"is_test_no"
#define JUDGE_TEST    [[[NSUserDefaults standardUserDefaults] objectForKey:IS_TEST] isEqualToString:IS_TEST_NO]

// 是否登录
#define IS_LOGIN @"isLogin"
#define IS_LOGIN_YES @"is_login_yes"
#define IS_LOGIN_NO @"is_login_no"

// 通知名称
#define REFRESH_DRAWER @"refresh_drawer"

// 登录地点
#define LOGIN_LOCATION @"login_location"
#define LOGIN_LOCATION_DRAWER @"login_location_drawer"
#define LOGIN_LOCATION_SHARE @"login_location_share"
#define LOGIN_LOCATION_RECORD @"login_location_record"
#define LOGIN_LOCATION_PERSON @"login_location_person"
#define LOGIN_LOCATION_USERSONG_SHARE @"login_location_usersong_share"
#define LOGIN_LOCATION_USERSONG_FOCUS @"login_location_usersong_focus"
#define LOGIN_LOCATION_USERSONG_COMMENT @"login_location_usersong_comment"
#define LOGIN_LOCATION_FORUM_COMMENT @"login_location_forum_comment"
#define LOGIN_LOCATION_FORUM_SEND_POST @"login_location_forum_send_post"
#define LOGIN_LOCATION_SETTING @"login_location_setting"
#define LOGIN_LOCATION_PERSON_CENTER @"login_location_person_center"

// 抽屉停留位置
#define DRAWER_LOCATION          @"drawer_location"
#define DRAWER_LOCATION_HOME     @"drawer_location_home"
#define DRAWER_LOCATION_PERSON   @"drawer_location_person"
#define DRAWER_LOCATION_DRAFTS   @"drawer_location_drafts"
#define DRAWER_LOCATION_SUGGEST  @"drawer_location_suggest"
#define DRAWER_LOCATION_ABOUT    @"drawer_location_about"
#define DRAWER_LOCATION_HEAD     @"drawer_location_head"
#define DRAWER_LOCATION_SETTING  @"drawer_location_setting";

#define INFO_USER_ID    @"currentUserID"
#define NULL_USER_ID    @"noUserID"
// 资料是否完善
#define INFO_COMPLETE @"info_complete"
#define INFO_COMPLETE_YES @"info_complete_yes"
#define INFO_COMPLETE_NO @"info_complete_no"

#define INFO_USER_NAME  @"infoUserName"
// 保存用户账号信息
#define USER_ACCOUNT @"user_accont"
#define EMPTY_SIGNATRUE @"这个家伙很懒，什么都没有留下"
#define SEND_COMMENT_AFTER_LOGIN    @"sendCommetnAfterLogin"
#define COMMENT_NOTI_INFO @"sendCommentNotiUserInfo"
/**
 *  意见反馈占位文本
 */
#define SUGEST_TXT      @"任何不爽，用力吐槽"
#define CONTECT_TXT     @"请输入您的手机号或邮箱"

/**
 *  请求成功 状态码 -1
 */
#define CODE_ERROR  @"没有更多了"

#define CONNET_ERROR    @"网络不给力"

#define DATA_DONE   @"没有更多了"

#define PAY_ERROR1   @"歌曲信息错误:001" // 进入花朵支付页面 歌曲或用户id错误
#define PAY_ERROR2   @"歌曲信息错误:002" // 支付完成查询支付结果 歌曲或用户id错误
/**
 *  邮箱发送用户配置
 */
#define EMAIL_UNAME     @"3356541270@qq.com"
#define EMAIL_PASSW     @"tvtnecxotpmzdaba"
#define EMAIL_HOST      @"smtp.qq.com"

#define EMAIL_SEND_TO   @"zhaopin@woyaoxiege.com"

#define EMAIL_FORMAT    @"%@\n\n---user info:%@\n\n---device info:\n Device:%@\n iOSVersion:%@\n AppVersion:%@"
/*****************支付相关*******************/
/**
 *  微信支付统一下单接口
 *
 *  @param price单位是分
 *
 *  @return
 */
#define WXPAY_ORDER @"https://service.woyaoxiege.com/core/home/pay/sendOrder?description=%@&price=%ld"

// gift_type 礼物种类 默认 1
// gift_type 0 -->  song_id = template_id   user_id = pay_user_id
#define WXPAY_CHECK_RESULT  @"https://service.woyaoxiege.com/core/home/pay/queryInsertOrder?user_id=%@&song_id=%@&out_trade_no=%@&gift_type=%d&pay_user_id=%@"

/************************************/
// 主题色
#define THEME_COLOR  HexStringColor(@"#879999")

#pragma mark - /*****************数据接口*******************/
// 用户协议
#define USER_PROTOCOL_URL @"https://www.woyaoxiege.com/home/index/UserAgreement"
// 活动
#define ACTIVITY_URL @"https://www.woyaoxiege.com/home/index/banner"
// 主页歌曲
#define HOME_LYRIC     JUDGE_TEST?@"https://service.woyaoxiege.com/music/lrc/%@.lrc":@"https://123.59.134.79/music/lrc/%@.lrc"
#define HOME_SOUND     JUDGE_TEST?@"https://service.woyaoxiege.com/music/mp3/%@.mp3":@"https://123.59.134.79/music/mp3/%@.mp3"
#define HOME_SHARE     JUDGE_TEST?@"http://www.woyaoxiege.com/home/index/play/%@":@"http://123.59.134.79/home/index/play/%@"
// get_midi_file
#define GET_MIDI_FILE   JUDGE_TEST?@"https://service.woyaoxiege.com/music/mid/%@.mid":@"https://123.59.134.79/music/mid/%@.mid"
// 作曲API
#define CREATE_URL_ALL   JUDGE_TEST?@"https://service.woyaoxiege.com/core/home/index/call?title=%@&content=%@&":@"https://123.59.134.79/core/home/index/call?title=%@&content=%@&"
#define CREATE_URL       JUDGE_TEST?@"https://service.woyaoxiege.com/core/home/index/call?title=%@&content=%@,%@,%@,%@&":@"https://123.59.134.79/core/home/index/call?title=%@&content=%@,%@,%@,%@&"
#define CREATE_Eight     JUDGE_TEST?@"https://service.woyaoxiege.com/core/home/index/call?title=%@&content=%@,%@,%@,%@,%@,%@,%@,%@&":@"https://123.59.134.79/core/home/index/call?title=%@&content=%@,%@,%@,%@,%@,%@,%@,%@&"
#define PARAMETER        @"source=%ld&genre=%ld&emotion=%ld&rate=%.1f"
// call_mid
#define TY_CALL_MID      JUDGE_TEST?@"https://service.woyaoxiege.com/core/home/index/call_mid":@"https://123.59.134.79/core/home/index/call_mid"
// ty_get_midi
#define TY_GET_MID            JUDGE_TEST?@"https://service.woyaoxiege.com/core/home/index/get_mid":@"https://123.59.134.79/core/home/index/get_mid"
#define GET_SONG_BY_SOURCE    JUDGE_TEST?@"https://service.woyaoxiege.com/core/home/index/change_voice?content=%@&source=%ld&name=%@":@"https://123.59.134.79/core/home/index/change_voice?content=%@&source=%ld&name=%@"
// 添加用户URL  status == 0(添加成功) -1(提交格式有问题) -2/报错(服务器报错)
#define ADD_USER_URL      JUDGE_TEST?@"https://service.woyaoxiege.com/core/home/data/addUser?phone=%@&password=%@":@"https://123.59.134.79/core/home/data/addUser?phone=%@&password=%@"
// 更新用户信息 status == 0(更新成功过) -1(更新失败)
#define UPDATE_USER_URL   JUDGE_TEST?@"https://service.woyaoxiege.com/core/home/data/updateUser?phone=%@&name=%@&gender=%@&birthday=%@&signature=%@&weibo=%@&qq=%@&wechat=%@&location=%@&school_company=%@":@"https://123.59.134.79/core/home/data/updateUser?phone=%@&name=%@&gender=%@&birthday=%@&signature=%@&weibo=%@&qq=%@&wechat=%@&location=%@&school_company=%@"
// 查询用户URL  status == 0(返回成功) -1(用户不存在) -2(查询报错)
#define GET_USER_URL      JUDGE_TEST?@"https://service.woyaoxiege.com/core/home/data/getUser?phone=%@":@"https://123.59.134.79/core/home/data/getUser?phone=%@"
// 通过id查询用户URL
#define GET_USER_ID_URL   JUDGE_TEST?@"https://service.woyaoxiege.com/core/home/data/getUserById?id=%@":@"https://123.59.134.79/core/home/data/getUserById?id=%@"
// 上传用户头像
#define UPDATE_USER_HEAD JUDGE_TEST?@"https://service.woyaoxiege.com/core/home/data/uploadUserImg":@"https://123.59.134.79/core/home/data/uploadUserImg"
// 获取用户头像URL
#define GET_USER_HEAD JUDGE_TEST?@"https://service.woyaoxiege.com/music/userPng/%@.png":@"https://123.59.134.79/music/userPng/%@.png"
// 上传用户歌曲图片
#define UPLOAD_USER_IMG JUDGE_TEST?@"https://service.woyaoxiege.com/core/home/index/upload_img":@"https://123.59.134.79/core/home/index/upload_img"
// 获取最新
// start 开始location    length 长度length
#define GET_LASTEST JUDGE_TEST?@"https://service.woyaoxiege.com/core/home/data/getZuixin?start=%ld&length=%ld":@"https://123.59.134.79/core/home/data/getZuixin?start=%ld&length=%ld"
// 获取最新演唱
#define GET_LASTEST_SING JUDGE_TEST?@"https://service.woyaoxiege.com/core/home/data/getZuixinChang?start=%ld&length=%ld":@"https://123.59.134.79/core/home/data/getZuixinChang?start=%ld&length=%ld"
// 获取最新改曲
#define GET_LASTEST_GAI JUDGE_TEST?@"https://service.woyaoxiege.com/core/home/data/getZuixinGai?start=%ld&length=%ld":@"https://123.59.134.79/core/home/data/getZuixinGai?start=%ld&length=%ld"

// 获取推荐
// start 开始location    length 长度length
#define GET_RECOMMAND JUDGE_TEST?@"https://service.woyaoxiege.com/core/home/data/getTuijian?start=%ld&length=%ld":@"https://123.59.134.79/core/home/data/getTuijian?start=%ld&length=%ld"

// 获取人声推荐
#define GET_SING_SONG JUDGE_TEST?@"https://service.woyaoxiege.com/core/home/data/getSingTuijian?start=%ld&length=%ld":@"https://123.59.134.79/core/home/data/getSingTuijian?start=%ld&length=%ld"
/**
 *  获取banner
 */
#define GET_BANNER JUDGE_TEST?@"https://service.woyaoxiege.com/core/home/data/getbanners":@"https://123.59.134.79/core/home/data/getbanners"

#define TEMPLATE_BY_ID JUDGE_TEST?@"https://service.woyaoxiege.com/core/home/data/getTemplateById?id=%@":@"https://123.59.134.79/core/home/data/getTemplateById?id=%@"

//获取用户已购买歌曲
#define ZOUYIN_GET_BUYED_SONGS JUDGE_TEST?@"https://service.woyaoxiege.com/core/home/data/getTemplateBuyByUserId?user_id=%@":@"https://123.59.134.79/core/home/data/getTemplateBuyByUserId?user_id=%@"
//添加歌曲模板到用户已购买列表
#define ZOUYIN_ADD_BUYED_SONG JUDGE_TEST?@"https://service.woyaoxiege.com/core/home/data/addTemplateBuy?user_id=%@&template_id=%@":@"https://123.59.134.79/core/home/data/addTemplateBuy?user_id=%@&template_id=%@"

#define ZOUYIN_TEMPLATE JUDGE_TEST?@"https://service.woyaoxiege.com/core/home/data/getTemplate":@"https://123.59.134.79/core/home/data/getTemplate"
/**
 *  根据名字获取图片
 */
#define GET_SONG_IMG    JUDGE_TEST?@"https://service.woyaoxiege.com/music/png/%@.png":@"https://123.59.134.79/music/png/%@.png"
// 获取指定id用户歌曲
#define GET_USER_SONGS JUDGE_TEST?@"https://service.woyaoxiege.com/core/home/data/getSongsByUserId?user_id=%@":@"https://123.59.134.79/core/home/data/getSongsByUserId?user_id=%@"
// 上传社区
// user_id 用户id     code 上传歌曲名称(md5格式)
#define UPLOAD_COMMUNITY JUDGE_TEST?@"https://service.woyaoxiege.com/core/home/data/addSong?user_id=%@&code=%@&device=%@&public=%@&tag=%@&sing=%@&activity_id=%@&gai=%@&original_title=%@&zuoci_id=%@&zuoqu_id=%@&yanchang_id=%@&template_id=%@":@"https://123.59.134.79/core/home/data/addSong?user_id=%@&code=%@&device=%@&public=%@&tag=%@&sing=%@&activity_id=%@&gai=%@&original_title=%@&zuoci_id=%@&zuoqu_id=%@&yanchang_id=%@&template_id=%@"
// 删除歌曲
#define DEL_BY_CODE JUDGE_TEST?@"https://service.woyaoxiege.com/core/home/data/delByCode?code=%@":@"https://123.59.134.79/core/home/data/delByCode?code=%@"

// 删除歌曲
#define DEL_COMMENTS_BY_ID JUDGE_TEST?@"https://service.woyaoxiege.com/core/home/data/delComments?id=%@":@"https://123.59.134.79/core/home/data/delComments?id=%@"

/**
 *  删除用户，慎用，客户端里没有用到
 */
#define DEL_BY_PHONE JUDGE_TEST?@"https://service.woyaoxiege.com/core/home/data/delUserByPhone?phone=%@":@"https://123.59.134.79/core/home/data/delUserByPhone?phone=%@"
// 增加播放数
#define ADD_PLAYCOUNT JUDGE_TEST?@"https://service.woyaoxiege.com/core/home/data/addPlay?code=%@":@"https://123.59.134.79/core/home/data/addPlay?code=%@"
/**
 *  调用此接口获取song_id
 
 
 public function upComment()
 {
     $Comments = M("Comments");
     $id = I('get.id');
     if($Comments-> where("id='%s'",$id)->setInc('up_count')==false){
     $this->ajaxReturn(array('status'=>-1), 'JSON');
     }else{//更新成功
     $this->ajaxReturn(array('status'=>0), 'JSON');
 }
 }
  
 */
#define GET_SONG_MESS   JUDGE_TEST?@"https://service.woyaoxiege.com/core/home/data/getSongByCode?code=%@":@"https://123.59.134.79/core/home/data/getSongByCode?code=%@"
#define GET_SONG_BY_ID  JUDGE_TEST?@"https://service.woyaoxiege.com/core/home/data/getSongById?id=%@":@"https://123.59.134.79/core/home/data/getSongById?id=%@"
#define GET_COMMENTS    JUDGE_TEST?@"https://service.woyaoxiege.com/core/home/data/getCommentsBySongId?song_id=%@":@"https://123.59.134.79/core/home/data/getCommentsBySongId?song_id=%@"
#define ADD_COMMENTS    JUDGE_TEST?@"https://service.woyaoxiege.com/core/home/data/addComments?user_id=%@&song_id=%@&content=%@&parent=%@":@"https://123.59.134.79/core/home/data/addComments?user_id=%@&song_id=%@&content=%@&parent=%@"
#define UP_SONGS        JUDGE_TEST?@"https://service.woyaoxiege.com/core/home/data/upByCode?code=%@":@"https://123.59.134.79/core/home/data/upByCode?code=%@"

#define UP_COMMENTS      JUDGE_TEST?@"https://service.woyaoxiege.com/core/home/data/upComment?id=%@":@"https://123.59.134.79/core/home/data/upComment?id=%@"
/**
 *  举报
 */
#define CHEAT_SONGS     JUDGE_TEST?@"https://service.woyaoxiege.com/core/home/data/setCheatByCode?code=%@":@"https://123.59.134.79/core/home/data/setCheatByCode?code=%@"
/**
 *  获取关注的人列表
 */
#define GET_FOCUS     JUDGE_TEST?@"https://service.woyaoxiege.com/core/home/data/getFocusByfollowId?follow_id=%@":@"https://123.59.134.79/core/home/data/getFocusByfollowId?follow_id=%@"
/**
 *  获取粉丝列表
 */
#define GET_FOLLOW     JUDGE_TEST?@"https://service.woyaoxiege.com/core/home/data/getFocusByfocusId?focus_id=%@":@"https://123.59.134.79/core/home/data/getFocusByfocusId?focus_id=%@"
/**
 *  添加关注
 */
#define ADD_FOCUS     JUDGE_TEST?@"https://service.woyaoxiege.com/core/home/data/addFocus?focus_id=%@&follow_id=%@":@"https://123.59.134.79/core/home/data/addFocus?focus_id=%@&follow_id=%@"
/**
 *  取消关注
 */
#define DEL_FOCUS     JUDGE_TEST?@"https://service.woyaoxiege.com/core/home/data/delFocus?focus_id=%@&follow_id=%@":@"https://123.59.134.79/core/home/data/delFocus?focus_id=%@&follow_id=%@"
/**
 *  添加喜欢
 */
#define ADD_LIKE    JUDGE_TEST?@"https://service.woyaoxiege.com/core/home/data/addLike?user_id=%@&song_id=%@":@"https://123.59.134.79/core/home/data/addLike?user_id=%@&song_id=%@"
/**
 *  取消喜欢
 */
#define DEL_LIKE    JUDGE_TEST?@"https://service.woyaoxiege.com/core/home/data/delLike?user_id=%@&song_id=%@":@"https://123.59.134.79/core/home/data/delLike?user_id=%@&song_id=%@"
/**
 *  获取喜欢
 */
#define GET_LIKE    JUDGE_TEST?@"https://service.woyaoxiege.com/core/home/data/getLikeByuserId?user_id=%@":@"https://123.59.134.79/core/home/data/getLikeByuserId?user_id=%@"
/**
 *  添加站内信
 *
 *  receive_id  接收消息人, send_id  发送消息人, type  消息类型（0-点赞 1-评论 2-关注 3-回复 4-系统消息 5-礼物）,song_id  相关歌曲id, content  系统消息内容, song_title   歌曲名             除了receive_id都可以缺省
 */
#define ADD_MESSAGE  JUDGE_TEST?@"https://service.woyaoxiege.com/core/home/data/addMessage?receive_id=%@&send_id=%@&type=%@&song_id=%@&content=%@&song_title=%@":@"https://123.59.134.79/core/home/data/addMessage?receive_id=%@&send_id=%@&type=%@&song_id=%@&content=%@song_title=%@"
/**
 *  获取站内信
 */
#define GET_MESSAGE   JUDGE_TEST?@"https://service.woyaoxiege.com/core/home/data/getMessageByReceiveId?receive_id=%@":@"https://123.59.134.79/core/home/data/getMessageByReceiveId?receive_id=%@"
/**
 *  设置为已读
 */
#define SET_READ   JUDGE_TEST?@"https://service.woyaoxiege.com/core/home/data/setReadById?id=%@":@"https://123.59.134.79/core/home/data/setReadById?id=%@"
/**
 *  删除站内信
 */
#define DEl_MSG   JUDGE_TEST?@"https://service.woyaoxiege.com/core/home/data/delMessage?id=%@":@"https://123.59.134.79/core/home/data/delMessage?id=%@"
/**
 *  获取达人
 */
#define GET_RECOMMAND_USER   JUDGE_TEST?@"https://service.woyaoxiege.com/core/home/data/getRecommendUser":@"https://123.59.134.79/core/home/data/getRecommendUser"
/**
 *  获取所有活动
 */
#define GET_ACTIVITY   JUDGE_TEST?@"https://service.woyaoxiege.com/core/home/data/getAllActivities":@"https://123.59.134.79/core/home/data/getAllActivities"
/**
 *  获取活动歌曲
 */
#define GET_ACTIVITY_SONGS   JUDGE_TEST?@"https://service.woyaoxiege.com/core/home/data/getActivitySong?activity_id=%@":@"https://123.59.134.79/core/home/data/getActivitySong?activity_id=%@"

/**
 *  获取活动歌曲带参版
 */
#define GET_ACTIVITY_SONGS_PAR   JUDGE_TEST?@"https://service.woyaoxiege.com/core/home/data/getActivitySong?activity_id=%@&start=%ld&length=%ld":@"https://123.59.134.79/core/home/data/getActivitySong?activity_id=%@&start=%ld&length=%ld"

/**
 *  发帖   post请求   参数： user_id  content  is_top  可传图   传图成功 status == 0  不传图 status == -1
 */
#define ADD_POST                    JUDGE_TEST?@"https://service.woyaoxiege.com/core/home/data/addPost":@"https://123.59.134.79/core/home/data/addPost"
/**
 *  发帖子评论  parent可为空
 */
#define ADD_POST_COMMENT            JUDGE_TEST?@"https://service.woyaoxiege.com/core/home/data/addPostComments?user_id=%@&post_id=%@&content=%@&parent=%@":@"https://123.59.134.79/core/home/data/addPostComments?user_id=%@&post_id=%@&content=%@&parent=%@"
/**
 *  获取帖子
 */
#define GET_POST                    JUDGE_TEST?@"https://service.woyaoxiege.com/core/home/data/getPosts?start=%ld&length=%ld":@"https://123.59.134.79/core/home/data/getPosts?start=%ld&length=%ld"
/**
 *  获取帖子评论
 */
#define GET_POST_COMMENT            JUDGE_TEST?@"https://service.woyaoxiege.com/core/home/data/getPostComments?post_id=%@":@"https://123.59.134.79/core/home/data/getPostComments?post_id=%@"
/**
 *  微博获取个人信息
 */
#define GET_WEIBO_USER_INFO  @"https://api.weibo.com/2/users/show.json?access_token=%@&uid=%@"
/**
 *  微信获取token
 */
#define GET_TOKEN_FROM_WECHAT @"https://api.weixin.qq.com/sns/oauth2/access_token?appid=%@&secret=%@&code=%@&grant_type=authorization_code"
/**
 *  获取微信个人信息
 */
#define GET_WECHAT_INFO @"https://api.weixin.qq.com/sns/userinfo?access_token=%@&openid=%@"

#define GET_RANK_LIST   @"https://service.woyaoxiege.com/core/home/data/getZhoubang?start=%d&length=%d"

// 获取机器人
#define GET_ROBOT       JUDGE_TEST?@"https://service.woyaoxiege.com/core/home/data/getRobotUser?num=%ld":@"https://123.59.134.79/core/home/data/getRobotUser?num=%ld"

// 获取好歌词
#define GET_GOOD_LYRIC  JUDGE_TEST?@"https://service.woyaoxiege.com/core/home/data/getHaogeci":@"https://123.59.134.79/core/home/data/getHaogeci"

// 获取歌单
#define GET_GEDANS      JUDGE_TEST?@"https://service.woyaoxiege.com/core/home/data/getGedans":@"https://123.59.134.79/core/home/data/getGedans"

// 获取歌单歌曲
#define GET_GEDAN_SONGS JUDGE_TEST?@"https://service.woyaoxiege.com/core/home/data/getGedanSong?gedan_id=%@&start=%ld&length=%ld":@"https://123.59.134.79/core/home/data/getGedanSong?gedan_id=%@&start=%ld&length=%ld"

// 获取余额
#define GET_MONEY JUDGE_TEST?@"https://service.woyaoxiege.com/core/home/pay/getUserMoney?user_id=%@":@"https://123.59.134.79/core/home/pay/getUserMoney?user_id=%@"
//https://service.woyaoxiege.com/core/home/pay/getUserMoney?user_id=2422
// 搜索接口
#define Search_API JUDGE_TEST?@"https://service.woyaoxiege.com/core/home/data/search?name=%@":@"https://123.59.134.79/core/home/data/search?name=%@"

// 获取歌曲礼物
#define GET_SONG_GIFT JUDGE_TEST?@"https://service.woyaoxiege.com/core/home/data/getGiftBySongId?song_id=%@":@"https://123.59.134.79/core/home/data/getGiftBySongId?song_id=%@"

#pragma mark - /*******************URL跳转*******************/

// 播放歌曲 @{@"code":@"dsdasdasdasd"}
#define URL_PLAYSONG @"wyxg://www.woyaoxiege.com?action=playSong&param=%@"

// 内嵌h5 @{@"url":@"dsdsadasdas"}
#define URL_INNERH5 @"wyxg://www.woyaoxiege.com?action=innerH5&param=%@"

// 活动详情页 @{@"id":@"", @"img":@"", @"title":@""}
#define URL_ACTIVITYDETAIL @"wyxg://www.woyaoxiege.com?action=activityDetail&param=%@"

// 榜单
#define URL_RANKLIST @"wyxg://www.woyaoxiege.com?action=rankList"

// 其他人个人中心  @{@"userId":@""}
#define URL_OTHERCENTER @"wyxg://www.woyaoxiege.com?action=otherPersonalCenter&param=%@"

// 主页
#define URL_HOMEPAGE @"wyxg://www.woyaoxiege.com?action=homePage"

// 热门
#define URL_HOTSONGS @"wyxg://www.woyaoxiege.com?action=hotSongs"

// 个性推荐
#define URL_CHARACTER @"wyxg://www.woyaoxiege.com?action=character"

// 最美人声
#define URL_MANMADESONG @"wyxg://www.woyaoxiege.com?action=manMadeSong"

// 创作达人
#define URL_HOTWRITERS @"wyxg://www.woyaoxiege.com?action=hotWriters"

// 活动列表
#define URL_ALLACTIVITIES @"wyxg://www.woyaoxiege.com?action=allActivities"



//function playSong(){
//    window.location.href = "wyxg://www.woyaoxiege.com?action=playSong&param={'code':'02173e66251917ed8c83f539cc887e8c_1'}";
//}
//
//function innerH5() {
//    var encodeUri  = encodeURIComponent("http://www.woyaoxiege.com/home/activity/aoyun");
//    window.location.href ="wyxg://www.woyaoxiege.com?action=innerH5&param={'url':'"+encodeUri+"'}";
//}
//
//function activityDetail() {
//    var id = "100";
//    var img = "http://service.woyaoxiege.com/music/activityPng/100.png";
//    var title = "“初恋”主题歌词征集";
//    window.location.href = "wyxg://www.woyaoxiege.com?action=activityDetail&param={'id':'"+id+"','img':'"+img+"','title':'"+title+"'}";
//}
//
//function rankList() {
//    window.location.href='wyxg://www.woyaoxiege.com?action=rankList';
//}
//
//function otherPersonalCenter() {
//    window.location.href = "wyxg://www.woyaoxiege.com?action=otherPersonalCenter&param={'userId':'350'}";
//}
//
//function homePage() {
//    window.location.href = 'wyxg://www.woyaoxiege.com?action=homePage';
//}
//function hotSongs() {
//    window.location.href='wyxg://www.woyaoxiege.com?action=hotSongs';
//}
//
//function character() {
//    window.location.href='wyxg://www.woyaoxiege.com?action=character';
//}
//
//function manMadeSong() {
//    window.location.href='wyxg://www.woyaoxiege.com?action=manMadeSong';
//}
//
//function hotWriters() {
//    window.location.href='wyxg://www.woyaoxiege.com?action=hotWriters';
//}
//
//function allActivities() {
//    window.location.href='wyxg://www.woyaoxiege.com?action=allActivities';
//}


#pragma mark - /*****************常用宏定义*******************/
/**
 *  屏幕宽高
 */
#define SCREEN_W    [[UIScreen mainScreen] bounds].size.width
#define SCREEN_H    [[UIScreen mainScreen] bounds].size.height
#define WIDTH_NIT   [[UIScreen mainScreen] bounds].size.width / 375
#define HEIGHT_NIT  [[UIScreen mainScreen] bounds].size.height / 667
// RGB颜色
#define RGBColor(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]
// HexString颜色
#define HexStringColor(hex) [UIColor colorWithHexString:(hex)]
// 阴影
#define AXGShadow(View, Size, Radius, Color, Opacity)\
\
[View.layer setShadowColor:[Color CGColor]];\
[View.layer setShadowOffset:(Size)];\
[View.layer setShadowRadius:(Radius)];\
[View.layer setShadowOpacity:(Opacity)]

#define kDevice_Is_iPhoneX [UIView bottomIsFullScreen]
/**
 *  运行时间
 */
#define TICK   NSDate *startTime = [NSDate date]
#define TOCK   NSLog(@"Time: %f", -[startTime timeIntervalSinceNow])
/**
 *  获取当前设备
 */
#define kScaleFrom_iPhone6_Desgin(_X_) (_X_ * (kScreen_Width/375))
#define kScreen_Height [UIScreen mainScreen].bounds.size.height
#define kScreen_Width [UIScreen mainScreen].bounds.size.width

#define kKeyWindow [UIApplication sharedApplication].keyWindow
#define kScreen_Bounds [UIScreen mainScreen].bounds
#define kDevice_Is_iPhone4 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)
#define kDevice_Is_iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
#define kDevice_Is_iPhone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)
#define kDevice_Is_iPhone6Plus ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) : NO)
#define kDevice_Is_iPad ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(768, 1024), [[UIScreen mainScreen] currentMode].size) : NO)
#define kDevice_Is_iPad3 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1536, 2048), [[UIScreen mainScreen] currentMode].size) : NO)

#define DebugLog(s, ...) NSLog(@"%s(%d): %@", __FUNCTION__, __LINE__, [NSString stringWithFormat:(s), ##__VA_ARGS__])

/**
 *  weak strong self for retain cycle
 */
#define WEAK_SELF __weak typeof(self) weakSelf = self
#define STRONG_SELF __strong typeof(weakSelf) self = weakSelf
/**
 *  单例
 */
#define XLSingletonM(name) \
static id _instance = nil; \
+ (id)allocWithZone:(struct _NSZone *)zone \
{ \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
_instance = [super allocWithZone:zone]; \
}); \
return _instance; \
} \
+ (instancetype)shared##name \
{ \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
_instance = [[self alloc] init]; \
}); \
return _instance; \
} \
- (id)copyWithZone:(NSZone *)zone \
{ \
return _instance; \
}

// 弹出注册窗口
#define AXG_LOGIN(location) [[NSUserDefaults standardUserDefaults] setObject:location forKey:LOGIN_LOCATION]; \
UIWindow *window = [[[UIApplication sharedApplication] delegate] window]; \
LoginViewController *loginVC = [[LoginViewController alloc] init]; \
[window.rootViewController presentViewController:loginVC animated:YES completion:^{ \
}]

#pragma mark - /*****************功能开关*******************/


#define XUANQU_FROME_NET    1

/**
 *  新录音界面
 */
#define NEW_RECORD 0

/**
 *  是否有钱包
 */
#define ALLOW_WALLET 1

/**
 *  是否打开站内信
 */
#define ALLOW_MSG 1

/**
 *  新首页
 */
#define NEW_HOME 1

/**
 *  旧首页
 */
#define OLD_HOME !NEW_HOME

/**
 *  新写词
 */
#define NEW_XIECI 0

/**
 *  旧写词
 */
#define OLD_XIECI !NEW_XIECI

/**
 *  是否允许快捷登录
 */
#define FAST_LOGIN 1

/**
 *  新抽屉
 */
#define NEW_DRAWER 1

/**
 *  旧抽屉
 */
#define OLD_DRAWER !NEW_DRAWER

/**
 *  测试用注册
 */
#define TEST_REGIST 0

/**
 *  新站内信
 */
#define NEW_MSG 1

/**
 *  旧站内信
 */
#define OLD_MSG !NEW_MSG

/**
 *  新活动界面
 */
#define NEW_ACTI 1

/**
 *  旧活动界面
 */
#define OLD_ACTI !NEW_ACTI


#endif /* AXGHeader_h */
