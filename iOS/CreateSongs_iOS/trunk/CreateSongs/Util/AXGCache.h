//
//  AXGCache.h
//  CreateSongs
//
//  Created by axg on 16/7/30.
//  Copyright © 2016年 AXG. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AXGCache : NSObject

+ (NSString*) cacheDirectory ;

+ (void) resetCache;

+ (void) setObject:(NSData*)data forKey:(NSString*)key;

+ (id) objectForKey:(NSString*)key;

@end
