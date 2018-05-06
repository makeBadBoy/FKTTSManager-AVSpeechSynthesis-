//
//  NSString+Easy.m
//  FKTTSManager
//
//  Created by fukang on 2018/5/5.
//  Copyright © 2018年 fukang. All rights reserved.
//

#import "NSString+Easy.h"

@implementation NSString (Easy)

- (NSString *)stringReplaceEmoji:(NSString *)string {
    
    __block NSString *resultString = string;
    
    __block BOOL returnValue = NO;
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length]) options:NSStringEnumerationByComposedCharacterSequences usingBlock:
     ^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
         
         const unichar hs = [substring characterAtIndex:0];
         // surrogate pair
         if (0xd800 <= hs && hs <= 0xdbff) {
             if (substring.length > 1) {
                 const unichar ls = [substring characterAtIndex:1];
                 const NSInteger uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                 if (0x1d000 <= uc && uc <= 0x1f77f) {
                     returnValue = YES;
                     
                     resultString = [resultString stringByReplacingOccurrencesOfString:substring withTheString:@""];
                 }
             }
         } else if (substring.length > 1) {
             const unichar ls = [substring characterAtIndex:1];
             if (ls == 0x20e3) {
                 
                 resultString = [resultString stringByReplacingOccurrencesOfString:substring withTheString:@""];
                 returnValue = YES;
             }
             
         } else {
             // non surrogate
             if (0x2100 <= hs && hs <= 0x27ff) {
                 resultString = [resultString stringByReplacingOccurrencesOfString:substring withTheString:@""];
                 returnValue = YES;
             } else if (0x2B05 <= hs && hs <= 0x2b07) {
                 resultString = [resultString stringByReplacingOccurrencesOfString:substring withTheString:@""];
                 returnValue = YES;
             } else if (0x2934 <= hs && hs <= 0x2935) {
                 resultString = [resultString stringByReplacingOccurrencesOfString:substring withTheString:@""];
                 returnValue = YES;
             } else if (0x3297 <= hs && hs <= 0x3299) {
                 resultString = [resultString stringByReplacingOccurrencesOfString:substring withTheString:@""];
                 returnValue = YES;
             } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
                 resultString = [resultString stringByReplacingOccurrencesOfString:substring withTheString:@""];
                 returnValue = YES;
             }
         }
     }];
    
    return resultString;
}


- (NSString *)stringByReplacingOccurrencesOfString:(NSString *)target withTheString:(NSString *)replacement
{
    NSString *string = nil;
    @try {
        string = [self stringByReplacingOccurrencesOfString:target withString:replacement];
    }
    @catch (NSException *exception) {
        //        MPLog(@"%@", exception.reason);
        string = self;
    }
    @finally {
        return string;
    }
}


+ (NSString *)theArrayConversionToString:(NSArray*)array {
    
    NSString *str = [NSString string];
    
    if (array.count > 0) {
        for (NSInteger i = 0; i < array.count; i ++) {
            if (i != array.count - 1) {
                str = [str stringByAppendingString:[NSString stringWithFormat:@"%@,",array[i]]];
            } else {
                str = [str stringByAppendingString:[NSString stringWithFormat:@"%@",array[i]]];
            }
        }
    }
    
    return str;
    
}

+ (NSString*)formatToLinefeedWith:(NSString *)string insertPosition:(NSInteger)index {
    
    NSMutableString *mutableStr = [string mutableCopy];
    if (index < string.length) {
        for (NSInteger i = mutableStr.length - index; i > 0; i -= index) {
            [mutableStr insertString:@"\n" atIndex:i];
        }
    }
    return [mutableStr copy];
}


@end
