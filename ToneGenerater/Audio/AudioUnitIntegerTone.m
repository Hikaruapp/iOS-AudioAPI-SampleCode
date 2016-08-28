//
//  AudioListFloatTone.m
//  ToneAudio
//
//  Created by y-yanase on 2016/04/20.
//  Copyright © 2016年 y-yanase. All rights reserved.
//

#import <AudioToolbox/AudioToolbox.h>
#import "AudioUnitIntegerTone.h"

static const double     AUDIO_SAMPLING_RATE  = 44100.0;
static const double     AUDIO_TONE_F_DEFAULT = 3000.0;
static const double     AUDIO_VOLUME_DEFAULT = 16384.0;

@interface AudioUnitIntegerTone ()
@property (nonatomic) AudioUnit outputUnit;

@property (nonatomic) NSUInteger toneCycle;
@end

@implementation AudioUnitIntegerTone

static OSStatus OutputCallback(void *inRefCon,
                               AudioUnitRenderActionFlags *ioActionFlags,
                               const AudioTimeStamp *inTimeStamp,
                               UInt32 inBusNumber,
                               UInt32 inNumberFrames,
                               AudioBufferList *ioData)
{
    AudioUnitIntegerTone *sm = (__bridge AudioUnitIntegerTone *)inRefCon;
    return [sm renderFrames:inNumberFrames ioData:ioData];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _toneVolume     = AUDIO_VOLUME_DEFAULT;
        _toneFrequancy  = AUDIO_TONE_F_DEFAULT;
        _toneOutPut     = kToneOFF;
        _toneCycle      = 0;
        
        [self createAudioTools];
    }
    return self;
}

- (void)createAudioTools {
    
    AudioComponent component;
    AudioComponentDescription desc;
    desc.componentType = kAudioUnitType_Output;
    desc.componentSubType = kAudioUnitSubType_RemoteIO;
    desc.componentManufacturer = kAudioUnitManufacturer_Apple;
    desc.componentFlags = 0;
    desc.componentFlagsMask = 0;
    
    component = AudioComponentFindNext(NULL, &desc);
    AudioComponentInstanceNew(component, &_outputUnit);
    AudioUnitInitialize(_outputUnit);
    AURenderCallbackStruct callback;
    callback.inputProc = OutputCallback;
    callback.inputProcRefCon = (__bridge void * _Nullable)(self);
    
    AudioUnitSetProperty(_outputUnit,
                         kAudioUnitProperty_SetRenderCallback,
                         kAudioUnitScope_Global,
                         0,
                         &callback,
                         sizeof(AURenderCallbackStruct));
    
    AudioStreamBasicDescription outputFormat;
    UInt32 size = sizeof(AudioStreamBasicDescription);
    
    outputFormat.mSampleRate        = AUDIO_SAMPLING_RATE;
    outputFormat.mFormatID          = kAudioFormatLinearPCM;
    outputFormat.mFormatFlags       = kAudioFormatFlagIsPacked | kLinearPCMFormatFlagIsSignedInteger;
    outputFormat.mBitsPerChannel    = 16;
    outputFormat.mChannelsPerFrame  = 2;
    outputFormat.mFramesPerPacket   = 1;
    outputFormat.mBytesPerFrame     = outputFormat.mBitsPerChannel / 8 * outputFormat.mChannelsPerFrame;
    outputFormat.mBytesPerPacket    = outputFormat.mBytesPerFrame * outputFormat.mFramesPerPacket;
    
    AudioUnitSetProperty(_outputUnit, kAudioUnitProperty_StreamFormat, kAudioUnitScope_Input, 0, &outputFormat, size);
    AudioOutputUnitStart(_outputUnit);
    
}

- (void)stop
{
    AudioOutputUnitStop(self.outputUnit);
    AudioUnitUninitialize(self.outputUnit);
    AudioComponentInstanceDispose(self.outputUnit);
    self.outputUnit = NULL;
}

- (void)dealloc
{
    [self stop];
}

- (OSStatus) renderFrames: (UInt32) numFrames ioData: (AudioBufferList *) ioData {
    
    // tone 信号のベースを作る
    float phasePerSample = 2.0 * M_PI * ( self.toneFrequancy / AUDIO_SAMPLING_RATE );
    
    for (NSInteger i = 0; i < ioData->mNumberBuffers; i++) {
        
        UInt32 channels = ioData->mBuffers[i].mNumberChannels;
        int16_t *ptr = (int16_t *)ioData->mBuffers[i].mData;
        for (NSInteger j = 0; j < numFrames; j+=channels) {

            // output Left
            float toneLeft = 0;
            if (self.toneOutPut & kToneLeft) {
                toneLeft = sin( phasePerSample * self.toneCycle ) * self.toneVolume;
            }
            
            // output Right
            float toneRight = 0;
            if (self.toneOutPut & kToneRight) {
                toneRight = sin( phasePerSample * self.toneCycle ) * self.toneVolume;
            }

            ptr[j * channels + 0] = (int16_t)toneLeft;
            ptr[j * channels + 1] = (int16_t)toneRight;
            
            self.toneCycle += channels;
        }
    }
    
    // over flow
    if ( self.toneCycle  > AUDIO_SAMPLING_RATE ) {
        self.toneCycle -= AUDIO_SAMPLING_RATE;
    }
    
    return noErr;
}

@end
