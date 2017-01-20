//
//  ShareManager.h
//  CreateSongs
//
//  Created by axg on 16/9/7.
//  Copyright © 2016年 AXG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    WECHAT_SHARE,
    FREND_SHARE,
    QQZONE_SHARE,
    QQ_SHARE,
    WEIBO_SHARE,
    COPY_SHARE
} AXGShrareType;

@interface ShareManager : NSObject

/**
 shareParams[@"shareTitle"];
 shareParams[@"shareMp3Url"];
 shareParams[@"shareWebUrl"];
 shareParams[@"shareSongWriter"];
 shareParams[@"shareImage"];
 */

+ (void)AXGShare:(AXGShrareType)shareType params:(NSDictionary *)shareParams;

@end
