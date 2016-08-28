//
//  ViewController.m
//  ToneGenerater
//
//  Created by Yanase Yuji on 2016/08/28.
//  Copyright © 2016年 hikaruApp. All rights reserved.
//

#import "ViewController.h"

#import "AudioQueFloatTone.h"
#import "AudioQueIntegerTone.h"

#import "AudioUnitFloatTOne.h"
#import "AudioUnitIntegerTone.h"

typedef NS_ENUM(NSInteger, buttonStatus) {
    kButtonLeft,
    kButtonRight,
    kButtonLeftAndRight,
};

@interface ViewController ()

// AudioQueue
@property (nonatomic) AudioQueFloatTone     *audioQFloat;
@property (nonatomic) AudioQueIntegerTone   *audioQInteger;

- (IBAction)buttonAudioQueueFloat:(id)sender;
- (IBAction)buttonAudioQueueFloatOff:(id)sender;

- (IBAction)buttonAudioQueueInteger:(id)sender;
- (IBAction)buttonAudioQueueIntegerOff:(id)sender;

// AudioList
@property (nonatomic) AudioUnitFloatTone    *audioUFloat;
@property (nonatomic) AudioUnitIntegerTone  *audioUInteger;

- (IBAction)buttonAudioUnitFloat:(id)sender;
- (IBAction)buttonAudioUnitFloatOff:(id)sender;

- (IBAction)buttonAudioUnitInteger:(id)sender;
- (IBAction)buttonAudioUnitIntegerOff:(id)sender;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    // audio auto start
    self.audioQFloat    = [AudioQueFloatTone   new];
    self.audioQInteger  = [AudioQueIntegerTone new];
    
    self.audioUFloat    = [AudioUnitFloatTone    new];
    self.audioUInteger  = [AudioUnitIntegerTone  new];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - AudioQueue Float
- (IBAction)buttonAudioQueueFloat:(id)sender {

    UIButton *btn = sender;
    
    switch (btn.tag) {
        case 1:
            self.audioQFloat.toneOutPut = kToneLeft;
            break;
            
        case 2:
            self.audioQFloat.toneOutPut = kToneRight;
            break;
            
        case 3:
            self.audioQFloat.toneOutPut = kToneLeftRight;
            break;
            
        default:
            break;
    }
}
- (IBAction)buttonAudioQueueFloatOff:(id)sender {
    self.audioQFloat.toneOutPut = kToneOFF;
}

#pragma mark - AudioQueue Integer
- (IBAction)buttonAudioQueueInteger:(id)sender {
    UIButton *btn = sender;
    
    switch (btn.tag) {
        case 1:
            self.audioQInteger.toneOutPut = kToneLeft;
            break;
            
        case 2:
            self.audioQInteger.toneOutPut = kToneRight;
            break;
            
        case 3:
            self.audioQInteger.toneOutPut = kToneLeftRight;
            break;
            
        default:
            break;
    }
}

- (IBAction)buttonAudioQueueIntegerOff:(id)sender {
    self.audioQInteger.toneOutPut = kToneOFF;
}



#pragma mark - AudioUnit Float
- (IBAction)buttonAudioUnitFloat:(id)sender {
    UIButton *btn = sender;
    
    switch (btn.tag) {
        case 1:
            self.audioUFloat.toneOutPut = kToneLeft;
            break;
            
        case 2:
            self.audioUFloat.toneOutPut = kToneRight;
            break;
            
        case 3:
            self.audioUFloat.toneOutPut = kToneLeftRight;
            break;
            
        default:
            break;
    }
}

- (IBAction)buttonAudioUnitFloatOff:(id)sender {
    self.audioUFloat.toneOutPut = kToneOFF;
}

#pragma mark - AudioUnit Integer
- (IBAction)buttonAudioUnitInteger:(id)sender {
    UIButton *btn = sender;
    
    switch (btn.tag) {
        case 1:
            self.audioUInteger.toneOutPut = kToneLeft;
            break;
            
        case 2:
            self.audioUInteger.toneOutPut = kToneRight;
            break;
            
        case 3:
            self.audioUInteger.toneOutPut = kToneLeftRight;
            break;
            
        default:
            break;
    }
}

- (IBAction)buttonAudioUnitIntegerOff:(id)sender {
    self.audioUInteger.toneOutPut = kToneOFF;
}

@end
