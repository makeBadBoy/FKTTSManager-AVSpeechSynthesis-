//
//  BDSSpeechManager.h
//  ManagePlus
//
//  Created by fukang on 2018/3/13.
//  Copyright © 2018年 JH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BDSSpeechSynthesizer.h"

@interface BDSSpeechManager : NSObject

+ (instancetype)shareManager;

/**配置百度ai*/
- (void)configureBaiDuSDk;

/**朗读谋一段*/
- (void)configureReadStr:(NSString*)readStr;

- (void)pauseSpeak;

- (void)continueSpeak;

- (void)stopSpeak;

@end
