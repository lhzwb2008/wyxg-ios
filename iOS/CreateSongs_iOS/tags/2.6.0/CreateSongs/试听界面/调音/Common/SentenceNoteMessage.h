//
//  SentenceNoteMessage.h
//  SentenceMidiChange
//
//  Created by axg on 16/5/7.
//  Copyright © 2016年 axg. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  每一个音符的信息
 */

@interface SentenceNoteMessage : NSObject

@property (nonatomic, assign) UInt32 beforeSentenceTime;

@property (nonatomic, assign) UInt32 notePitch;

@property (nonatomic, assign) UInt32 noteDeltime;

@property (nonatomic, assign) UInt32 deltaTime;

@property (nonatomic, strong) NSData *noteData;

@end
