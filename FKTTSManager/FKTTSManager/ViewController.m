//
//  ViewController.m
//  FKTTSManager
//
//  Created by fukang on 2018/4/7.
//  Copyright © 2018年 fukang. All rights reserved.
//

#import "ViewController.h"
#import "IQKeyboardManager.h"
#import "FKTTSManager.h"
#import "BDSSpeechManager.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UISlider *speedSlider;

@property (weak, nonatomic) IBOutlet UITextView *readTextV;

@property (weak, nonatomic) IBOutlet UILabel *speedL;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [[IQKeyboardManager sharedManager] setEnable:YES];
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:YES];
    
    [self configureTextView];
}

#pragma mark - TextView

- (void)configureTextView {
    
    self.readTextV.text = @"郑和七下西洋，彰显的是明朝的国威，是向自己的左邻右舍展示肌肉💪。永乐年间的大明帝国，可谓是世界上最强大的帝国，强大的舰队驰骋于大西洋上，但不表现侵略，挑衅之意。面对爪哇军队错杀大明士官恶性事件，强大的郑和舰队荡平爪哇可谓是轻而易举，但大明表现出来的是宽容，容忍，但前提是确认过事件是一件误会，并且爪哇国王也表示歉意。弱而忍是一种理智，强而仁就不仅仅是一种理智，更是一种智慧。郑和七下西洋，并没有用大炮火枪敲开一个又一个国门，那是因为大明深知有些地方山高皇帝远，打下容易，管理难，与其花兵力，粮草征服，还不如以德服人，让周边小国心甘情愿俯首称臣，年年上贡。郑和七下西洋，广施仁义，并不代表大明是厌战的仁义之师，而是综合利弊，使利益最大化的战略。";
}


#pragma mark - SliderValueChange

- (IBAction)speedSliderValueChange:(id)sender {
    
    self.speedL.text = [NSString stringWithFormat:@"语速 %.0f",self.speedSlider.value * 10];
    NSString *speed = [NSString stringWithFormat:@"%.0f",self.speedSlider.value * 10];
    [[NSUserDefaults standardUserDefaults] setValue:speed forKey:@"SpeechSpeed"];
}

#pragma mark - Action

- (IBAction)startRead:(id)sender {
    
    [[BDSSpeechManager shareManager] configureReadStr:self.readTextV.text];
}

- (IBAction)pauseRead:(id)sender {
    
    [[BDSSpeechManager shareManager] pauseSpeak];
}


- (IBAction)continueRead:(id)sender {
    
    [[BDSSpeechManager shareManager] continueSpeak];
}


- (IBAction)stopRead:(id)sender {
    
    [[BDSSpeechManager shareManager] stopSpeak];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
