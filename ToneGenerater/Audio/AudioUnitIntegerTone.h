//
//  AudioListFloatTone.h
//  ToneAudio
//
//  Created by y-yanase on 2016/04/20.
//  Copyright © 2016年 y-yanase. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AudioConfig.h"

@interface AudioUnitIntegerTone : NSObject

@property (nonatomic) float         toneFrequancy;
@property (nonatomic) float         toneVolume;
@property (nonatomic) OutPutSwitch  toneOutPut;

- (void)stop;

@end
