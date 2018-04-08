//
//  FKTTSManager.h
//  ManagePlus
//
//  Created by fukang on 2018/1/15.
//  Copyright © 2018年 JH. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface FKTTSManager : NSObject

+ (instancetype)shareManager;

/**根据偏好设置调整语速*/
- (void)configureSpeed:(float)speedValue;

/**朗读某一段*/
- (void)configureReadStr:(NSString*)readStr;

- (void)pauseSpeak;

- (void)continueSpeak ;

- (void)stopSpeak;

@end
