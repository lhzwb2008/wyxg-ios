//
//  PCMCuter.h
//  CreateSongs
//
//  Created by axg on 16/8/29.
//  Copyright © 2016年 AXG. All rights reserved.
//
#import <Foundation/Foundation.h>

@interface PCMCuter : NSObject

+ (OSStatus) cutFiles:(NSArray*)files atTimes:(NSArray*)times toMixfile:(NSString*)mixfile;

@end
