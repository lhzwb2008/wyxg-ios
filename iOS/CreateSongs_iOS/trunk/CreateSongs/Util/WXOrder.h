//
//  WXOrder.h
//  CreateSongs
//
//  Created by axg on 16/8/16.
//  Copyright © 2016年 AXG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface WXOrder : NSObject

@property (nonatomic, copy) NSString *partnerId;
@property (nonatomic, copy) NSString *prepayId;
@property (nonatomic, copy) NSString *nonceStr;
@property (nonatomic, assign) UInt32 timeStamp;
@property (nonatomic, copy) NSString *package;
@property (nonatomic, copy) NSString *sign;

@end
