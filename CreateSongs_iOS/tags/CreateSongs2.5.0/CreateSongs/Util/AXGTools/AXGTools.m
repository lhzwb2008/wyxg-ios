//
//  AXGTools.m
//  CreateSongs
//
//  Created by 爱写歌 on 16/7/13.
//  Copyright © 2016年 AXG. All rights reserved.
//

#import "AXGTools.h"
#import <sys/utsname.h>

@implementation AXGTools

+ (NumberType)getNumType:(NSString *)str {
    if ([self isValidateEmail:str]) {
        return isMail;
    } else if ([self isValidateMobile:str]) {
        return isTel;
    } else {
        return wrong;
    }
}

/*邮箱验证 MODIFIED BY HELENSONG*/
+ (BOOL)isValidateEmail:(NSString *)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

/*手机号码验证 MODIFIED BY HELENSONG*/
+ (BOOL) isValidateMobile:(NSString *)mobile
{
    //手机号以13， 15，18开头，八个 \d 数字字符
    NSString *phoneRegex = @"^((13[0-9])|(15[^4,\\D])|(18[0,0-9]))\\d{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    //    NSLog(@"phoneTest is %@",phoneTest);
    return [phoneTest evaluateWithObject:mobile];
}

+ (NSString *)deviceName {
    struct utsname systemInfo;
    uname(&systemInfo);
    
    NSString *sysInfo = [NSString stringWithCString:systemInfo.machine
                                           encoding:NSUTF8StringEncoding];
    NSDictionary *phoneType = PhoneType;
    NSString *phoneName = phoneType[sysInfo];
    
    return phoneName;
}

+ (CGFloat)getTextHeight:(NSString *)content font:(UIFont *)font width:(CGFloat)width {
    CGSize textSize = [content boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size;
    return textSize.height;
}

+ (CGFloat)getTextWidth:(NSString *)content font:(UIFont *)font {
    NSDictionary *attributes = @{NSFontAttributeName:font,};
    CGSize textSize = [content boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:NSStringDrawingTruncatesLastVisibleLine attributes:attributes context:nil].size;
    return textSize.width;
}

+ (NSString *)md5HexDigest:(NSString*)input {
    
    const char* str = [input UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(str, (CC_LONG)strlen(str), result);
    NSMutableString *ret = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i = 0; i<CC_MD5_DIGEST_LENGTH; i++) {
        [ret appendFormat:@"%02x",result[i]];
    }
    return ret;
}

//将图片缩放到指定尺寸
+ (UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize {
    UIGraphicsBeginImageContext(newSize);
    
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return newImage;
}

+ (NSString *)intervalSinceNow: (NSString *) theDate {
    
    NSString *copyDate = theDate;
    
    NSDateFormatter *date=[[NSDateFormatter alloc] init];
    
    [date setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
    
    [date setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDate *d=[date dateFromString:theDate];
    
    NSTimeInterval late=[d timeIntervalSince1970]*1.0;
    
    NSDate* dat = [NSDate date];
    
    NSString *currentDateStr = [date stringFromDate:[NSDate date]];
    
    NSTimeInterval now=[dat timeIntervalSince1970]*1.0;
    
    NSString *timeString=@"";
    
    NSTimeInterval cha=now-late;
    
    /************************判断是否是昨天*************************/
    int ci;
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    currentDateStr = [[currentDateStr componentsSeparatedByString:@" "] objectAtIndex:0];
    theDate = [[theDate componentsSeparatedByString:@" "] objectAtIndex:0];
    [df setDateFormat:@"yyyy-MM-dd"];
    NSDate *dt1 = [[NSDate alloc] init];
    NSDate *dt2 = [[NSDate alloc] init];
    dt1 = [df dateFromString:currentDateStr];
    dt2 = [df dateFromString:theDate];
    [NSDate  timeIntervalSinceReferenceDate];
    NSComparisonResult result = [dt1 compare:dt2];
    switch (result)
    {
            //today比otherDay大
        case NSOrderedDescending: {
            NSTimeInterval dayTime = 24*60*60;
            // 将today往前减少一天的时间，判断是否和昨天的时间是否相等，如果相等则表示
            // otherDay为昨天
            NSDate * newDate = [dt1 dateByAddingTimeInterval:-dayTime];
            result = [dt2 compare:newDate];
            if (result == NSOrderedSame) {
                // 表示日期为昨天
                ci = -1;
                timeString = @"昨天";
            } else {
                // 表示日期为昨天以前的时间
                ci = 1;
                timeString = [copyDate substringWithRange:NSMakeRange(5, 5)];
            }
        }
            break;
            //date02=date01,代表日期是今天
        case NSOrderedSame: {
            ci=0;
            timeString = [copyDate substringWithRange:NSMakeRange(11, 5)];
        };
            break;
        default:
            // 默认显示所有的具体的日期时间
            ci = 1;
            timeString = copyDate;
            break;
    }
    
    
//    if (cha/3600<1) {
//        
//        if (cha < 0) {
//            timeString=@"刚刚";
//        } else {
//            timeString = [NSString stringWithFormat:@"%f", cha/60];
//            
//            timeString = [timeString substringToIndex:timeString.length-7];
//            
//            timeString=[NSString stringWithFormat:@"%@分钟前", timeString];
//        }
//    }
//    if (cha/3600>1&&cha/86400<1) {
//        
//        timeString = [NSString stringWithFormat:@"%f", cha/3600];
//        
//        timeString = [timeString substringToIndex:timeString.length-7];
//        
//        timeString=[NSString stringWithFormat:@"%@小时前", timeString];
//        
//    }
//    if (cha/86400>1) {
//        
//        timeString = [NSString stringWithFormat:@"%f", cha/86400];
//        
//        timeString = [timeString substringToIndex:timeString.length-7];
//        
//        timeString=[NSString stringWithFormat:@"%@天前", timeString];
//    }
    
    return timeString;
}


@end
