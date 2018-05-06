//
//  NSString+Easy.h
//  FKTTSManager
//
//  Created by fukang on 2018/5/5.
//  Copyright © 2018年 fukang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Easy)

/**
 过滤字符串中的emoji表情
 
 @param string 字符串
 */
- (NSString *)stringReplaceEmoji:(NSString *)string;


- (NSString *)stringByReplacingOccurrencesOfString:(NSString *)target withTheString:(NSString *)replacement;

/*
 将数组中的元素以,号隔开，字符串形式返回
 */
+ (NSString *)theArrayConversionToString:(NSArray *)array;

/**
 格式化字符串 每隔指定字符数擦入一个换行符
 
 @param string abcdef
 @param index 4
 @return abcd\nef
 */
+ (NSString*)formatToLinefeedWith:(NSString *)string insertPosition:(NSInteger)index;

@end
