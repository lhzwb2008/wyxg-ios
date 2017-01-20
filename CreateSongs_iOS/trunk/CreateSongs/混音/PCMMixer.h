//
//  PCMMixer.h
//
//  Created by Moses DeJong on 3/25/09.
//

#import <Foundation/Foundation.h>



@interface PCMMixer : NSObject


+ (OSStatus) mixFiles:(NSArray*)files atTimes:(NSArray*)times toMixfile:(NSString*)mixfile;

+ (OSStatus) removeMixFiles:(NSArray*)files atTimes:(NSArray*)times toMixfile:(NSString*)mixfile;


@end
