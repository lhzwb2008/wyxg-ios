//
//  TradeManager.h
//  CreateSongs
//
//  Created by axg on 16/8/16.
//  Copyright © 2016年 AXG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WXOrder.h"

@interface TradeManager : NSObject

+ (void)payByAlipayWithTitle:(NSString*)title
                     orderId:(NSString*)orderId
                    totalFee:(NSString*)fee
              resultCallback:(void(^)(NSDictionary* result))callback;

+ (void)payByWechatWithTitle:(NSString*)title
                     orderId:(NSString*)orderId
                    totalFee:(NSString*)fee;

+ (void)payByWEchatWithOrder:(WXOrder *)wxOrder;

@end
