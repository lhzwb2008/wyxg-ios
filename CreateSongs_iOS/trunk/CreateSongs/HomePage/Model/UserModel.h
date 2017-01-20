//
//  UserModel.h
//  CreateSongs
//
//  Created by axg on 16/4/25.
//  Copyright © 2016年 AXG. All rights reserved.
//

#import "JSONModel.h"

@interface UserModel : JSONModel

/**
 *  qq号
 */
@property (nonatomic, copy) NSString *qq;
/**
 *  微信号
 */
@property (nonatomic, copy) NSString *wechat;
/**
 *  微博号
 */
@property (nonatomic, copy) NSString *weibo;
/**
 *  生日
 */
@property (nonatomic, copy) NSString *birthday;
/**
 *  个性签名
 */
@property (nonatomic, copy) NSString *signature;
/**
 *  所在地
 */
@property (nonatomic, copy) NSString *location;
/**
 *  学校或公司
 */
@property (nonatomic, copy) NSString *school_company;
/**
 *  用户创建日期
 */
@property (nonatomic, copy) NSString *creaet_time;
/**
 *  用户性别
 */
@property (nonatomic, copy) NSString *gender;
/**
 *  用户id
 */
@property (nonatomic, copy) NSString *userModelId;
/**
 *  修改日期
 */
@property (nonatomic, copy) NSString *modify_time;
/**
 *  用户名
 */
@property (nonatomic, copy) NSString *name;
/**
 *  密码
 */
@property (nonatomic, copy) NSString *password;
/**
 *  手机号
 */
@property (nonatomic, copy) NSString *phone;
/**
 *  
 */
@property (nonatomic, copy) NSString *status;

@end
