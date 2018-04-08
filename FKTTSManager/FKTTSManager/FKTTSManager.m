//
//  FKTTSManager.m
//  ManagePlus
//
//  Created by fukang on 2018/1/15.
//  Copyright © 2018年 JH. All rights reserved.
//

#import "FKTTSManager.h"
#import <AVFoundation/AVSpeechSynthesis.h>
#import <AVFoundation/AVFoundation.h>

@interface FKTTSManager ()
<AVSpeechSynthesizerDelegate>

@property (nonatomic , strong) AVSpeechSynthesizer *avSpeaker;

@property (nonatomic , assign) float speedValue;

@end

@implementation FKTTSManager

+ (instancetype)shareManager {
    static FKTTSManager *ttsManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        ttsManager = [[super alloc] init];
    });
    return ttsManager;
}

- (AVSpeechSynthesizer*)avSpeaker {
    if (!_avSpeaker) {
        _avSpeaker = [[AVSpeechSynthesizer alloc] init];
        _avSpeaker.delegate = self;
    }
    return _avSpeaker;
}

- (void)configureAVAudioSession {
    
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    [[AVAudioSession sharedInstance] setActive:YES error:nil];
}

- (void)configureReadStr:(NSString*)readStr {
    
    [self stopSpeak];
    
    [self configureAVAudioSession];

    AVSpeechUtterance *utterance = [[AVSpeechUtterance alloc] initWithString:readStr];
    //设置语速,语速介于AVSpeechUtteranceMaximumSpeechRate和AVSpeechUtteranceMinimumSpeechRate之间
    //AVSpeechUtteranceMaximumSpeechRate
    //AVSpeechUtteranceMinimumSpeechRate
    //AVSpeechUtteranceDefaultSpeechRate
    
    utterance.rate = self.speedValue;
    
    //设置音高,[0.5 - 2] 默认 = 1
    //AVSpeechUtteranceMaximumSpeechRate
    //AVSpeechUtteranceMinimumSpeechRate
    //AVSpeechUtteranceDefaultSpeechRate
    utterance.pitchMultiplier = 0.9;
    
    
    //设置音量,[0-1] 默认 = 1
    utterance.volume = 0.8;
    
    //读一段前的停顿时间
    utterance.preUtteranceDelay = 0.1;
    
    //读完一段后的停顿时间
    utterance.postUtteranceDelay = 0.1;
    
    //设置声音,是AVSpeechSynthesisVoice对象
    //AVSpeechSynthesisVoice定义了一系列的声音, 主要是不同的语言和地区.
    //voiceWithLanguage: 根据制定的语言, 获得一个声音.
    //speechVoices: 获得当前设备支持的声音
    //currentLanguageCode: 获得当前声音的语言字符串, 比如”ZH-cn”
    //language: 获得当前的语言
    //通过特定的语言获得声音
    
    AVSpeechSynthesisVoice *voice = [AVSpeechSynthesisVoice voiceWithLanguage:@"zh-CN"];
    //通过voicce标示获得声音
    //AVSpeechSynthesisVoice *voice = [AVSpeechSynthesisVoice voiceWithIdentifier:AVSpeechSynthesisVoiceIdentifierAlex];
    utterance.voice = voice;
    
    [self.avSpeaker speakUtterance:utterance];
}

/**根据偏好设置调整语速*/
- (void)configureSpeed:(float)speedValue {
    
    self.speedValue = speedValue;
}


- (void)pauseSpeak {
    
    //暂停朗读
    //AVSpeechBoundaryImmediate 立即停止
    //AVSpeechBoundaryWord    当前词结束后停止
    [_avSpeaker pauseSpeakingAtBoundary:AVSpeechBoundaryImmediate];
}


- (void)continueSpeak {
    
    [_avSpeaker continueSpeaking];
}

- (void)stopSpeak {
    
    //AVSpeechBoundaryImmediate 立即停止
    //AVSpeechBoundaryWord    当前词结束后停止
    [_avSpeaker stopSpeakingAtBoundary:AVSpeechBoundaryImmediate];
}

#pragma mark - AVSpeechSynthesizerDelegate
/**已经开始朗读*/
- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer didStartSpeechUtterance:(AVSpeechUtterance *)utterance {
//正在朗读
}

/**已经说完了*/
- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer didFinishSpeechUtterance:(AVSpeechUtterance *)utterance {
//朗读结束
}

/**暂停朗读*/
- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer didPauseSpeechUtterance:(AVSpeechUtterance *)utterance {
//暂停朗读
}

/**继续朗读*/
- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer didContinueSpeechUtterance:(AVSpeechUtterance *)utterance {
//正在朗读
}

/**取消朗读*/
- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer didCancelSpeechUtterance:(AVSpeechUtterance *)utterance {
    [self stopSpeak];
}

/**即将朗读某一段*/
- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer willSpeakRangeOfSpeechString:(NSRange)characterRange utterance:(AVSpeechUtterance *)utterance {
    
}

@end
