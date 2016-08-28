//
//  AudioQueFloatTone.h
//  ToneAudio
//
//  Created by y-yanase on 2016/04/21.
//  Copyright © 2016年 y-yanase. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AudioConfig.h"

@interface AudioQueFloatTone : NSObject

@property (nonatomic) float         toneFrequancy;
@property (nonatomic) float         toneVolume;
@property (nonatomic) OutPutSwitch  toneOutPut;

- (void)stop;

@end
