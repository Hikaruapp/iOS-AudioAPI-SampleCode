//
//  AudioQueListTone.h
//  ToneAudio
//
//  Created by y-yanase on 2016/04/19.
//  Copyright © 2016年 y-yanase. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AudioConfig.h"

@interface AudioUnitFloatTone : NSObject

@property (nonatomic) float         toneFrequancy;
@property (nonatomic) float         toneVolume;
@property (nonatomic) OutPutSwitch  toneOutPut;

-(void)stop;

@end
