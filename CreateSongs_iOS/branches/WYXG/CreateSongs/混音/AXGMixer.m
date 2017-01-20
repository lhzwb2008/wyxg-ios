//
//  AXGMixer.m
//  CreateSongs
//
//  Created by axg on 16/8/1.
//  Copyright © 2016年 AXG. All rights reserved.
//

#import "AXGMixer.h"
#import "BJIConverter.h"
#import "PCMMixer.h"
#import "AppDelegate.h"
#import "PCMCuter.h"
#import "AXGHeader.h"

@implementation AXGMixer

- (void)mixerMP3Files:(NSArray *)mp3Names withVolumes:(NSArray *)volumes success:(void(^)(NSString *path))success error:(void(^)(NSError *error))result {
    
    NSArray *mp3s = mp3Names;
    NSArray *cafs = [self getCAFs:mp3s];
    [BJIConverter convertFiles:mp3s toFiles:cafs];
    NSArray *files = cafs;
    NSArray *times = [self getTimes];
    NSString *mixURL = [self getMixURL];
    
    if (volumes.count > 0) {
        AppDelegate *app = [[UIApplication sharedApplication] delegate];
        app.personVolume = [volumes[0] floatValue];
        app.banzouVolume = [volumes[1] floatValue];
    }
    
    [PCMMixer mixFiles:files atTimes:times toMixfile:mixURL];

    success(mixURL);
}

- (void)getCutMP3File:(NSArray *)mp3Names withVolumes:(NSArray *)volumes success:(void (^)(NSString *))success error:(void (^)(NSError *))result {
    NSArray *mp3s = mp3Names;
    NSArray *cafs = [self getCAFs:mp3s];
    [BJIConverter convertFiles:mp3s toFiles:cafs];
    NSArray *files = cafs;
    NSArray *times = [self getTimes];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *mixURL = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"MixBanzou.caf"];
    
    if (volumes.count > 0) {
        AppDelegate *app = [[UIApplication sharedApplication] delegate];
        app.personVolume = [volumes[0] floatValue];
        app.banzouVolume = [volumes[1] floatValue];
    }
    [PCMCuter cutFiles:files atTimes:times toMixfile:mixURL];
    success(mixURL);
}

- (NSArray *)getMp3Path:(NSArray *)mp3Names {
    NSMutableArray *mp3Array = [[NSMutableArray alloc] initWithCapacity:mp3Names.count];
    [mp3Names enumerateObjectsUsingBlock:^(NSString *songName, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *path = [[NSBundle mainBundle] pathForResource:songName ofType:@"mp3"];
        [mp3Array addObject:path];
    }];
    return mp3Array;
}


- (NSArray*)getMP3s {
    //  Find all mp3's in bundle
    NSString *bundleRoot = [[NSBundle mainBundle] bundlePath];
    NSFileManager *fm = [NSFileManager defaultManager];
    NSArray *dirContents = [fm contentsOfDirectoryAtPath:bundleRoot error:nil];
    NSPredicate *fltr = [NSPredicate predicateWithFormat:@"self ENDSWITH '.mp3'"];
    NSArray *mp3s = [dirContents filteredArrayUsingPredicate:fltr];
    
    //  Convert mp3's to their full paths
    NSMutableArray *fullmp3s = [[NSMutableArray alloc] initWithCapacity:[mp3s count]];
    [mp3s enumerateObjectsUsingBlock:^(NSString *file, NSUInteger idx, BOOL *stop) {
        [fullmp3s addObject:[bundleRoot stringByAppendingPathComponent:file]];
    }];
    return fullmp3s;
}

- (NSArray*)getCAFs:(NSArray*)mp3s {
    //  Find 'Documents' directory
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docPath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    
    //  Create AIFFs from mp3's
    NSMutableArray *cafs = [[NSMutableArray alloc] initWithCapacity:[mp3s count]];
    [mp3s enumerateObjectsUsingBlock:^(NSString *file, NSUInteger idx, BOOL *stop) {
        [cafs addObject:[docPath stringByAppendingPathComponent:[[file lastPathComponent] stringByReplacingOccurrencesOfString:@".mp3" withString:@".caf"]]];
    }];
    return cafs;
}

- (NSString*)getMixURL {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return [[paths objectAtIndex:0] stringByAppendingPathComponent:@"Mix.caf"];
}
- (NSArray *)getTimes {
    //  First item must be at time 0. All other sounds must be relative to this first sound.
    return [NSArray arrayWithObjects:[NSNumber numberWithInt:0],[NSNumber numberWithInt:0],[NSNumber numberWithInt:0],[NSNumber numberWithInt:0], nil];
}


@end
