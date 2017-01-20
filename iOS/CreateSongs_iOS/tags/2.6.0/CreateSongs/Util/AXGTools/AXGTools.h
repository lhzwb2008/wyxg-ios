//
//  AXGTools.h
//  CreateSongs
//
//  Created by 爱写歌 on 16/7/13.
//  Copyright © 2016年 AXG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CommonCrypto/CommonDigest.h>

#define CC_MD5_DIGEST_LENGTH 16

#define PhoneType @{                                                                    \
@"i386"      : @"32-bit Simulator"                                                      , \
@"x86_64"    : @"64-bit Simulator"                                                      , \
@"iPod1,1"   : @"iPod Touch"                                                            , \
@"iPod2,1"   : @"iPod Touch Second Generation"                                          , \
@"iPod3,1"   : @"iPod Touch Third Generation"                                           , \
@"iPod4,1"   : @"iPod Touch Fourth Generation"                                          , \
@"iPod7,1"   : @"iPod Touch 6th Generation"                                             , \
@"iPhone1,1" : @"iPhone"                                                                , \
@"iPhone1,2" : @"iPhone 3G"                                                             , \
@"iPhone2,1" : @"iPhone 3GS"                                                            , \
@"iPad1,1"   : @"iPad"                                                                  , \
@"iPad2,1"   : @"iPad 2"                                                                , \
@"iPad3,1"   : @"3rd Generation iPad"                                                   , \
@"iPhone3,1" : @"iPhone 4 (GSM)"                                                        , \
@"iPhone3,3" : @"iPhone 4 (CDMA/Verizon/Sprint)"                                        , \
@"iPhone4,1" : @"iPhone 4S"                                                             , \
@"iPhone5,1" : @"iPhone 5 (model A1428, AT&T/Canada)"                                   , \
@"iPhone5,2" : @"iPhone 5 (model A1429, everything else)"                               , \
@"iPad3,4"   : @"4th Generation iPad"                                                   , \
@"iPad2,5"   : @"iPad Mini"                                                             , \
@"iPhone5,3" : @"iPhone 5c (model A1456, A1532 | GSM)"                                  , \
@"iPhone5,4" : @"iPhone 5c (model A1507, A1516, A1526 (China), A1529 | Global)"         , \
@"iPhone6,1" : @"iPhone 5s (model A1433, A1533 | GSM)"                                  , \
@"iPhone6,2" : @"iPhone 5s (model A1457, A1518, A1528 (China), A1530 | Global)"         , \
@"iPad4,1"   : @"5th Generation iPad (iPad Air) - Wifi"                                 , \
@"iPad4,2"   : @"5th Generation iPad (iPad Air) - Cellular"                             , \
@"iPad4,4"   : @"2nd Generation iPad Mini - Wifi"                                       , \
@"iPad4,5"   : @"2nd Generation iPad Mini - Cellular"                                   , \
@"iPad4,7"   : @"3rd Generation iPad Mini - Wifi (model A1599)"                         , \
@"iPhone7,1" : @"iPhone 6 Plus"                                                         , \
@"iPhone7,2" : @"iPhone 6"                                                              , \
@"iPhone8,1" : @"iPhone 6S"                                                             , \
@"iPhone8,2" : @"iPhone 6S Plus"                                                        , \
@"iPhone8,4" : @"iPhone SE"                                                               \
}

typedef enum : NSUInteger {
    isMail,
    isTel,
    wrong,
} NumberType;

@interface AXGTools : NSObject

@property (nonatomic, assign) NumberType type;

/**
 *  判断是否是电话还是邮箱
 *
 *  @param str 字符串
 *
 *  @return 类型
 */
+ (NumberType)getNumType:(NSString *)str;

/**
 *  判断是否是邮箱
 *
 *  @param email 字符串
 *
 *  @return 是否是邮箱
 */
+ (BOOL)isValidateEmail:(NSString *)email;

/**
 *  判断是否是电话
 *
 *  @param email 字符串
 *
 *  @return 是否是电话
 */
+ (BOOL) isValidateMobile:(NSString *)mobile;

/**
 *  获取设备详细名称
 *
 *  @return 设备详细名称
 */
+ (NSString *)deviceName;

/**
 *  获取文字的自定义高度
 *
 *  @param content 文本内容
 *  @param font    文本字体
 *  @param width   文本宽度
 *
 *  @return 文本高度
 */
+ (CGFloat)getTextHeight:(NSString *)content font:(UIFont *)font width:(CGFloat)width;

/**
 *  获取文本宽度
 *
 *  @param content 文本内容
 *  @param font    文本字体
 *
 *  @return 文本宽度
 */
+ (CGFloat)getTextWidth:(NSString *)content font:(UIFont *)font;

/**
 *  MD5加密
 *
 *  @param input 输入字符串
 *
 *  @return MD5串
 */
+ (NSString *)md5HexDigest:(NSString*)input;

/**
 *  将图片缩放到指定尺寸
 *
 *  @param image   图片
 *  @param newSize 指定尺寸
 *
 *  @return 缩放后图片
 */
+ (UIImage *)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize;

/**
 *  时间转化成距离现在时间
 *
 *  @param theDate 时间字符串
 *
 *  @return 距离现在时间字符串
 */
+ (NSString *)intervalSinceNow: (NSString *) theDate;

@end




















