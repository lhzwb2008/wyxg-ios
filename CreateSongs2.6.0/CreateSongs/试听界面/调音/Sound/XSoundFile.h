//
//  Created by Lugia on 15/3/13.
//  Copyright (c) 2015年 Freedom. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XFunction.h"
#import "XOpenALPlayer.h"

@interface XSoundFile : NSObject
@property (nonatomic) NSString* soundName;
@property (nonatomic) NSString* fileName;
@property (nonatomic) NSString* fileExt;
@property (nonatomic) int fileIndex;
@property (nonatomic) int playCount;
/**
 *  第一个音高的 sourceID
 */
@property (nonatomic) ALuint sourceId;
/**
 *  第二个音高的 sourceID
 */
@property (nonatomic) ALuint sourceId1;

@property (nonatomic) ALuint bufferId;
@property (nonatomic) void *data;
@property (nonatomic) ALenum format;
@property (nonatomic) ALsizei size;
@property (nonatomic) ALsizei freq;

-(id)initWithName:(NSString*)soundName
         fileName:(NSString*)fileName
          fileExt:(NSString*)fileExt
        fileIndex:(int)fileIndex;
-(void)xDispose;
@end
