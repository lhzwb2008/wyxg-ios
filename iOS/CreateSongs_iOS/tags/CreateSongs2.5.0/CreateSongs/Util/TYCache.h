//
//  TYCache.h
//  AXGTY
//
//  Created by axg on 16/3/29.
//  Copyright © 2016年 axg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TYCache : NSObject

+ (NSString*) cacheDirectory ;

+ (void) resetCache;

+ (void) setObject:(NSData*)data forKey:(NSString*)key;

+ (id) objectForKey:(NSString*)key;

@end
