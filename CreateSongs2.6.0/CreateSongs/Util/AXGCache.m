//
//  AXGCache.m
//  CreateSongs
//
//  Created by axg on 16/7/30.
//  Copyright © 2016年 AXG. All rights reserved.
//

#import "AXGCache.h"

static NSTimeInterval cacheTime =  (double)1800;

@implementation AXGCache

+ (void) resetCache {
    [[NSFileManager defaultManager] removeItemAtPath:[AXGCache cacheDirectory] error:nil];
}

+ (NSString *) cacheDirectory {
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cacheDirectory = [paths objectAtIndex:0];
    cacheDirectory = [cacheDirectory stringByAppendingPathComponent:@"AXGCaches"];
    //    NSLog(@"%@", cacheDirectory);
    return cacheDirectory;
}

+ (NSData*) objectForKey:(NSString*)key {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *filename = [self.cacheDirectory stringByAppendingPathComponent:key];
    
    if ([fileManager fileExistsAtPath:filename])
    {
        NSDate *modificationDate = [[fileManager attributesOfItemAtPath:filename error:nil] objectForKey:NSFileModificationDate];
        if ([modificationDate timeIntervalSinceNow] > cacheTime) {
            [fileManager removeItemAtPath:filename error:nil];
        } else {
            NSData *data = [NSData dataWithContentsOfFile:filename];
            return data;
        }
    }
    return nil;
}

+ (void) setObject:(NSData*)data forKey:(NSString*)key {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *filename = [self.cacheDirectory stringByAppendingPathComponent:key];
    //    NSLog(@"%@", self.cacheDirectory );
    BOOL isDir = YES;
    if (![fileManager fileExistsAtPath:self.cacheDirectory isDirectory:&isDir]) {
        [fileManager createDirectoryAtPath:self.cacheDirectory withIntermediateDirectories:NO attributes:nil error:nil];
    }
    
    NSError *error;
    @try {
        [data writeToFile:filename options:NSDataWritingAtomic error:&error];
    }
    @catch (NSException * e) {
        //TODO: error handling maybe
    }
}
// if < 1/1024.0  --> KB   else --> MB
+ (float)fileSizeAtPath:(NSString *)path{
    NSFileManager *fileManager=[NSFileManager defaultManager];
    if([fileManager fileExistsAtPath:path]){
        long long size=[fileManager attributesOfItemAtPath:path error:nil].fileSize;
        return size/1024.0/1024.0;
    }
    return 0;
}
@end