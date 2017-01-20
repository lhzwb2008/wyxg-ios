//
//  NSString+Emojize.m
//  Field Recorder
//
//  Created by Jonathan Beilin on 11/5/12.
//  Copyright (c) 2014 DIY. All rights reserved.
//

#import "NSString+Emojize.h"
#import "emojis.h"

@implementation NSString (Emojize)

- (NSString *)emojizedString
{
    return [NSString emojizedStringWithString:self];
}

- (NSString *)preEmojizedString {
    return [NSString stringContainsEmoji:self];
}

- (NSString *)removeEmojiString {
    return [NSString stringRemoveEmoji:self];
}

+ (NSString *)emojizedStringWithString:(NSString *)text
{
    static dispatch_once_t onceToken;
    static NSRegularExpression *regex = nil;
    dispatch_once(&onceToken, ^{
        regex = [[NSRegularExpression alloc] initWithPattern:@"(:[a-z0-9-+_]+:)" options:NSRegularExpressionCaseInsensitive error:NULL];
    });
    
    __block NSString *resultText = text;
    NSRange matchingRange = NSMakeRange(0, [resultText length]);
    [regex enumerateMatchesInString:resultText options:NSMatchingReportCompletion range:matchingRange usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
         if (result && ([result resultType] == NSTextCheckingTypeRegularExpression) && !(flags & NSMatchingInternalError)) {
             NSRange range = result.range;
             if (range.location != NSNotFound) {
                 NSString *code = [text substringWithRange:range];
                 NSString *unicode = self.emojiAliases[code];
                 if (unicode) {
                     resultText = [resultText stringByReplacingOccurrencesOfString:code withString:unicode];
                 }
             }
         }
     }];
    
    return resultText;
}

+ (NSString *)stringContainsEmoji:(NSString *)string
{
    __block NSString *noEmoji = string;
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length]) options:NSStringEnumerationByComposedCharacterSequences usingBlock:
     ^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
         const unichar hs = [substring characterAtIndex:0];
         // surrogate pair
         if (0xd800 <= hs && hs <= 0xdbff) {
             if (substring.length > 1) {
                 const unichar ls = [substring characterAtIndex:1];
                 const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                 if (0x1d000 <= uc && uc <= 0x1f77f) {
                     
//                     noEmoji = [noEmoji stringByReplacingOccurrencesOfString:substring withString:@""];
                     NSString *preCode = self.preEmojiAliases[substring];
                     
                     if (preCode.length != 0) {
                         noEmoji = [noEmoji stringByReplacingOccurrencesOfString:substring withString:preCode];
                     } else {
                         noEmoji = [noEmoji stringByReplacingOccurrencesOfString:substring withString:@""];
                     }
                     
                     
                 }
             }
         } else if (substring.length > 1) {
             const unichar ls = [substring characterAtIndex:1];
             if (ls == 0x20e3) {
//                 noEmoji = [noEmoji stringByReplacingOccurrencesOfString:substring withString:@""];
                 NSString *preCode = self.preEmojiAliases[substring];
                 noEmoji = [noEmoji stringByReplacingOccurrencesOfString:substring withString:preCode];
             }
             
         } else {
             // 貌似是颜文字区
             // non surrogate
             if (0x2100 <= hs && hs <= 0x27ff) {

//                 NSString *preCode = self.preEmojiAliases[substring];
//                 
//                 NSLog(@"%@    %@     %@", noEmoji, preCode, substring);
//                 
//                 noEmoji = [noEmoji stringByReplacingOccurrencesOfString:substring withString:preCode];
             } else if (0x2B05 <= hs && hs <= 0x2b07) {
//                 noEmoji = [noEmoji stringByReplacingOccurrencesOfString:substring withString:@""];
                 NSString *preCode = self.preEmojiAliases[substring];
                 noEmoji = [noEmoji stringByReplacingOccurrencesOfString:substring withString:preCode];
             } else if (0x2934 <= hs && hs <= 0x2935) {
//                 noEmoji = [noEmoji stringByReplacingOccurrencesOfString:substring withString:@""];
                 NSString *preCode = self.preEmojiAliases[substring];
                 noEmoji = [noEmoji stringByReplacingOccurrencesOfString:substring withString:preCode];
             } else if (0x3297 <= hs && hs <= 0x3299) {
//                 noEmoji = [noEmoji stringByReplacingOccurrencesOfString:substring withString:@""];
                 NSString *preCode = self.preEmojiAliases[substring];
                 noEmoji = [noEmoji stringByReplacingOccurrencesOfString:substring withString:preCode];
             } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
//                 noEmoji = [noEmoji stringByReplacingOccurrencesOfString:substring withString:@""];
                 NSString *preCode = self.preEmojiAliases[substring];
                 noEmoji = [noEmoji stringByReplacingOccurrencesOfString:substring withString:preCode];
             }
         }
     }];
    string = noEmoji;
    return string;
}

+ (NSString *)stringRemoveEmoji:(NSString *)string
{
    __block NSString *noEmoji = string;
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length]) options:NSStringEnumerationByComposedCharacterSequences usingBlock:
     ^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
         const unichar hs = [substring characterAtIndex:0];
         // surrogate pair
         if (0xd800 <= hs && hs <= 0xdbff) {
             if (substring.length > 1) {
                 const unichar ls = [substring characterAtIndex:1];
                 const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                 if (0x1d000 <= uc && uc <= 0x1f77f) {
                     
                                          noEmoji = [noEmoji stringByReplacingOccurrencesOfString:substring withString:@""];
//                     NSString *preCode = self.preEmojiAliases[substring];
//                     noEmoji = [noEmoji stringByReplacingOccurrencesOfString:substring withString:preCode];
                 }
             }
         } else if (substring.length > 1) {
             const unichar ls = [substring characterAtIndex:1];
             if (ls == 0x20e3) {
                                  noEmoji = [noEmoji stringByReplacingOccurrencesOfString:substring withString:@""];
//                 NSString *preCode = self.preEmojiAliases[substring];
//                 noEmoji = [noEmoji stringByReplacingOccurrencesOfString:substring withString:preCode];
             }
             
         } else {
             // non surrogate
             if (0x2100 <= hs && hs <= 0x27ff) {
                                  noEmoji = [noEmoji stringByReplacingOccurrencesOfString:substring withString:@""];
//                 NSString *preCode = self.preEmojiAliases[substring];
//                 noEmoji = [noEmoji stringByReplacingOccurrencesOfString:substring withString:preCode];
             } else if (0x2B05 <= hs && hs <= 0x2b07) {
                                  noEmoji = [noEmoji stringByReplacingOccurrencesOfString:substring withString:@""];
//                 NSString *preCode = self.preEmojiAliases[substring];
//                 noEmoji = [noEmoji stringByReplacingOccurrencesOfString:substring withString:preCode];
             } else if (0x2934 <= hs && hs <= 0x2935) {
                                  noEmoji = [noEmoji stringByReplacingOccurrencesOfString:substring withString:@""];
//                 NSString *preCode = self.preEmojiAliases[substring];
//                 noEmoji = [noEmoji stringByReplacingOccurrencesOfString:substring withString:preCode];
             } else if (0x3297 <= hs && hs <= 0x3299) {
                                  noEmoji = [noEmoji stringByReplacingOccurrencesOfString:substring withString:@""];
//                 NSString *preCode = self.preEmojiAliases[substring];
//                 noEmoji = [noEmoji stringByReplacingOccurrencesOfString:substring withString:preCode];
             } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
                                  noEmoji = [noEmoji stringByReplacingOccurrencesOfString:substring withString:@""];
//                 NSString *preCode = self.preEmojiAliases[substring];
//                 noEmoji = [noEmoji stringByReplacingOccurrencesOfString:substring withString:preCode];
             }
         }
     }];
    string = noEmoji;
    return string;
}

+ (NSDictionary *)emojiAliases {
    static NSDictionary *_emojiAliases;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _emojiAliases = EMOJI_HASH;
    });
    return _emojiAliases;
}

+ (NSMutableDictionary *)preEmojiAliases {
    static NSMutableDictionary *_preEmojiAliases;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _preEmojiAliases = [[NSMutableDictionary alloc] initWithCapacity:0];
        NSDictionary *dic = EMOJI_HASH;
        for (NSString *key in dic.allKeys) {
            [_preEmojiAliases setObject:key forKey:dic[key]];
        }
    });
    return _preEmojiAliases;
}

@end
