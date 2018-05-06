//
//  BDSSpeechManager.m
//  ManagePlus
//
//  Created by fukang on 2018/3/13.
//  Copyright © 2018年 JH. All rights reserved.
//

#import "BDSSpeechManager.h"
#import "FKTTSManager.h"
#import "NSString+Easy.h"
#import <AVFoundation/AVFoundation.h>

//#error 请在官网新建app，配置bundleId，并在此填写相关参数
NSString * APP_ID = @"11197694";
NSString * API_KEY = @"GUPYYgtTRdEFBVXxbGIAc8Vu";
NSString * SECRET_KEY = @"teFvcyZL3AtHG6p6bfxFq8x4b5087HSY";

//音色
NSString * Chinese_And_English_Speech_Female = @"Chinese_And_English_Speech_Female";
NSString * Chinese_And_English_Speech_DYY = @"Chinese_And_English_Speech_DYY";
NSString * Chinese_And_English_Speech_Male = @"Chinese_And_English_Speech_Male";
NSString * Chinese_And_English_Speech_Male_yyjw = @"Chinese_And_English_Speech_Male-yyjw";

@interface BDSSpeechManager ()
<BDSSpeechSynthesizerDelegate>

@property (nonatomic , strong) NSMutableArray *readStrArrM;

@end

@implementation BDSSpeechManager

+ (instancetype)shareManager {
    static BDSSpeechManager *ttsManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        ttsManager = [[super alloc] init];
    });
    return ttsManager;
}

- (NSMutableArray*)readStrArrM {
    
    if (!_readStrArrM) {
        _readStrArrM = [NSMutableArray array];
    }
    return _readStrArrM;
}

- (void)configureBaiDuSDk {
    
    [BDSSpeechSynthesizer setLogLevel:BDS_PUBLIC_LOG_VERBOSE];
    [[BDSSpeechSynthesizer sharedInstance] setSynthesizerDelegate:self];
    [self configureOnlineTTS];
    [self configureOfflineTTS];
}

- (void)configureOnlineTTS {
    
    [[BDSSpeechSynthesizer sharedInstance] setApiKey:[self configureAPI_KEY] withSecretKey:[self configureSECRET_KEY]];
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    [[AVAudioSession sharedInstance] setActive:YES error:nil];

}

- (void)configureOfflineTTS {
    
    // 设置离线引擎
    NSString *ChineseSpeechData = [[NSBundle mainBundle] pathForResource:[self configureOffLineSpeaker] ofType:@"dat"];
    NSString *ChineseTextData = [[NSBundle mainBundle] pathForResource:@"Chinese_And_English_Text" ofType:@"dat"];
    NSString *LicenseData = [[NSBundle mainBundle] pathForResource:@"bdtts_license" ofType:@"dat"];
    
    BDTTSError *err = [[BDSSpeechSynthesizer sharedInstance] startTTSEngine:ChineseTextData                                    speechDataPath:ChineseSpeechData
                                                            licenseFilePath:LicenseData withAppCode:APP_ID];
//    if (err) {
//        MPLog(@"BDTTSError ---  %@" , err);
//    }
}


- (void)configureReadStr:(NSString*)readStr {
    [self configureBaiDuSDk];
    [self.readStrArrM removeAllObjects];
    if (readStr.length > 300) {
        [self playLongStr:readStr];
    }
    else {
        [self playReadStr:readStr];
    }
}

/**播放文本长度大于300的文本格式(正常完整的播放最大支持340个字)*/
- (void)playLongStr:(NSString*)longStr {
    
    longStr = [longStr stringReplaceEmoji:longStr];
    longStr = [longStr stringByReplacingOccurrencesOfString:@"\n" withTheString:@""];
    longStr = [NSString formatToLinefeedWith:longStr insertPosition:300];
    NSArray *readStrArr = [[longStr componentsSeparatedByString:@"\n"] copy];
    for (NSString *str in readStrArr) {
        if (str.length != 0) {
            [self.readStrArrM addObject:str];
        }
    }
    [self playReadStr:[self.readStrArrM firstObject]];
}

- (void)playReadStr:(NSString *)readStr {
    
    NSError *err = nil;
    [[BDSSpeechSynthesizer sharedInstance] cancel];
    
    //选择播音员
    [self configureBaiDuSpeaker];
    //设置播放速度
    [self configureBaiDuSpeed];
    
    if ([[BDSSpeechSynthesizer sharedInstance] speakSentence:readStr withError:&err] == -1) {
        //播放失败时走原声播放
        [self avSpeechManagerPlay];
    }
    
}


/**配置声音*/
- (void)configureBaiDuSpeaker {
    
    /**
     0 标准女声
     1 普通男声 1
     2 普通男声 2
     3 情感男声
     4 情感女声
     */
    NSString *speakerType = @"0";
    [[BDSSpeechSynthesizer sharedInstance] setSynthParam:speakerType forKey:BDS_SYNTHESIZER_PARAM_SPEAKER];
}

/**配置播放速度*/
- (void)configureBaiDuSpeed {
    
    //[NSNumber 0...9]
    NSString *speedValue = [[NSUserDefaults standardUserDefaults] objectForKey:@"SpeechSpeed"];
    NSNumber *speed = [NSNumber numberWithInteger:[speedValue integerValue]];
    [[BDSSpeechSynthesizer sharedInstance] setSynthParam:speed forKey:BDS_SYNTHESIZER_PARAM_SPEED];
}

/**mp3音质  压缩的16K*/
- (void)configureBaiDuEncode {
    
    [[BDSSpeechSynthesizer sharedInstance] setSynthParam:
     [NSNumber numberWithInt: BDS_SYNTHESIZER_AUDIO_ENCODE_MP3_16K]
                                                  forKey:BDS_SYNTHESIZER_PARAM_AUDIO_ENCODING ];
}


/**暂停播放*/
- (void)pauseSpeak {
    
    [[BDSSpeechSynthesizer sharedInstance] pause];
}


- (void)continueSpeak {
    
    [[BDSSpeechSynthesizer sharedInstance] resume];
}

- (void)stopSpeak {
    [[FKTTSManager shareManager] stopSpeak];
    [[BDSSpeechSynthesizer sharedInstance] cancel];
}

#pragma mark - BDSSpeechSynthesizerDelegate

- (void)synthesizerErrorOccurred:(NSError *)error speaking:(NSInteger)SpeakSentence synthesizing:(NSInteger)SynthesizeSentence {
    
    NSLog(@"%@",error.localizedDescription);
    [self avSpeechManagerPlay];
}

/**开始播放*/
- (void)synthesizerStartWorkingSentence:(NSInteger)SynthesizeSentence {
    
    NSLog(@"开始加载");
}

/**播放结束*/
- (void)synthesizerFinishWorkingSentence:(NSInteger)SynthesizeSentence {
    
    NSLog(@"加载完成");
}

/**开始播放*/
- (void)synthesizerSpeechStartSentence:(NSInteger)SpeakSentence{
    //NSLog(@"开始播放a ");
}

/**结束播放*/
- (void)synthesizerSpeechEndSentence:(NSInteger)SpeakSentence {
    
    //NSLog(@"播放结束a ");
    if (self.readStrArrM.count > 0) {
        [self.readStrArrM removeObjectAtIndex:0];
        if (self.readStrArrM.count > 0) {
            [self playReadStr:[self.readStrArrM firstObject]];
        }
        else {
            [self stopSpeak];
        }
    }
    else {
        [self stopSpeak];
    }
}

/**暂停播放*/
- (void)synthesizerdidPause {
    //NSLog(@"暂停播放b ");
}

/**继续播放*/
- (void)synthesizerResumed {
    //NSLog(@"继续播放b ");
}

/**取消播放*/
- (void)synthesizerCanceled {
    NSLog(@"取消播放b ");
}


#pragma mark - AVSpeechManager

- (void)avSpeechManagerPlay {

    [[BDSSpeechSynthesizer sharedInstance] cancel];
    NSString *readStr = [NSString theArrayConversionToString:self.readStrArrM];
    [[FKTTSManager shareManager] configureReadStr:readStr];
}

#pragma mark  - Private

- (NSString*)configureAPP_ID {
    return APP_ID;
}


- (NSString*)configureAPI_KEY {
    return API_KEY;
}


- (NSString*)configureSECRET_KEY {
    return SECRET_KEY;
}

- (NSString*)configureOffLineSpeaker {
    
    /**
     0 标准女声
     1 普通男声 1
     2 普通男声 2
     3 情感男声
     4 情感女声
     */
    NSString *speakerType = @"";
    if ([speakerType isEqualToString:@"0"]) {
        return Chinese_And_English_Speech_Female;
    }
    else if ([speakerType isEqualToString:@"1"]) {
        return Chinese_And_English_Speech_Male;
    }
    else if ([speakerType isEqualToString:@"2"]) {
        return Chinese_And_English_Speech_Male;
    }
    else if ([speakerType isEqualToString:@"3"]) {
        return Chinese_And_English_Speech_Male_yyjw;
    }
    else if ([speakerType isEqualToString:@"4"]) {
        return Chinese_And_English_Speech_DYY;
    }
    return Chinese_And_English_Speech_Female;
}

@end
