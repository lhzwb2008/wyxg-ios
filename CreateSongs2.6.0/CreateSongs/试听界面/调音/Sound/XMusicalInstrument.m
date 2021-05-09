//
//  Created by Lugia on 15/3/13.
//  Copyright (c) 2015年 Freedom. All rights reserved.
//

#import "XMusicalInstrument.h"

@implementation XMusicalInstrument

-(id)init:(UInt32)type{
    if(self = [super init]){
        self.type = type;
        self.soundFiles = [NSMutableArray array];
    }
    return self;
}

-(void)addSoundFileByName:(NSString*)soundName
                 fileName:(NSString*)fileName
                  fileExt:(NSString*)fileExt
                fileIndex:(int)fileIndex
{
    XSoundFile* soundFile = [[XSoundFile alloc] initWithName:soundName
                                                    fileName:fileName
                                                     fileExt:fileExt
                                                   fileIndex:fileIndex];
//    if (fileIndex == 33) {
//        NSLog(@"%@", fileName);
//    }
    [self.soundFiles addObject:soundFile];
}

-(XSoundFile*)getSoundFileByIndex:(int)fileIndex{
    if (fileIndex > self.soundFiles.count - 1) {
        return [self.soundFiles lastObject];
    } else if (fileIndex < 0) {
        return [self.soundFiles firstObject];
    } else {
        return self.soundFiles[fileIndex];
    }
}

-(void)removeAllSoundFiles{

    for (XSoundFile *soundFile in self.soundFiles) {
        [soundFile xDispose];
    }
    [self.soundFiles removeAllObjects];
}

-(int)soundCount{
    return (int)self.soundFiles.count;
}
@end