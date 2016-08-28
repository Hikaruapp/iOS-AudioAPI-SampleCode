//
//  AudioQueFloatTone.m
//  ToneAudio
//
//  Created by y-yanase on 2016/04/21.
//  Copyright © 2016年 y-yanase. All rights reserved.
//

#import <AudioToolbox/AudioToolbox.h>
#import "AudioQueFloatTone.h"

static const NSInteger AUDIO_BUFFER_SIZE = 1012;
static const double     AUDIO_SAMPLING_RATE  = 48000.0;
static const double     AUDIO_TONE_F_DEFAULT = 3000.0;
static const double     AUDIO_VOLUME_DEFAULT = 0.5;

@interface AudioQueFloatTone ()
@property (nonatomic) AudioQueueRef                 audioQueue;
@property (nonatomic) AudioStreamBasicDescription   audioDataFormat;

@property (nonatomic) NSUInteger toneCycle;
@end

@implementation AudioQueFloatTone

// コールバック関数
static void AQOutputCallback(void *userData,
                             AudioQueueRef audioQueueRef,
                             AudioQueueBufferRef audioQueueBufferRef) {
    
    AudioQueFloatTone *addBuffer = (__bridge AudioQueFloatTone*)userData;
    [addBuffer audioQueueOutputWithQueue:audioQueueRef queueBuffer:audioQueueBufferRef];
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

- (void)dealloc {
    self.audioQueue = nil;
}

- (void)createAudioTools {
    
    // audio Format
    _audioDataFormat.mSampleRate = AUDIO_SAMPLING_RATE;
    _audioDataFormat.mFormatID = kAudioFormatLinearPCM;
    _audioDataFormat.mFormatFlags = kLinearPCMFormatFlagIsFloat | kAudioFormatFlagIsPacked;
    _audioDataFormat.mBitsPerChannel    = 32;
    _audioDataFormat.mChannelsPerFrame  = 2;
    _audioDataFormat.mFramesPerPacket   = 1;
    _audioDataFormat.mBytesPerFrame     = _audioDataFormat.mBitsPerChannel / 8 * _audioDataFormat.mChannelsPerFrame;    //[8]
    _audioDataFormat.mBytesPerPacket    = _audioDataFormat.mBytesPerFrame * _audioDataFormat.mFramesPerPacket;          //[8]
    _audioDataFormat.mReserved          = 0;
    
    //
    // 再生用のオーディオキューオブジェクトを作成する
    AudioQueueNewOutput(&_audioDataFormat,      // AudioStreamBasicDescription
                        AQOutputCallback,       // AudioQueueOutputCallback
                        (__bridge void *)self,  // コールバックの第一引数に渡される
                        nil,
                        nil,
                        0,
                        &_audioQueue);
    
    // bufferを３個作成。
    UInt32 bufferSize = AUDIO_BUFFER_SIZE * _audioDataFormat.mBytesPerFrame;
    
    for (NSInteger bufferBank = 0; bufferBank < 3; bufferBank++) {
        AudioQueueBufferRef   audioBuffers;
        AudioQueueAllocateBuffer(_audioQueue, bufferSize, &audioBuffers);
        [self audioQueueOutputWithQueue:self.audioQueue queueBuffer:audioBuffers];
    }
    
    
    // 再生開始
    AudioQueueStart(_audioQueue, nil);
    
}

- (void) audioQueueOutputWithQueue:(AudioQueueRef)audioQueueRef
                       queueBuffer:(AudioQueueBufferRef)audioQueueBufferRef {
    
    // 正弦波用のデータ作成
    float phasePerSample = 2.0 * M_PI * ( self.toneFrequancy / AUDIO_SAMPLING_RATE );
    
    audioQueueBufferRef->mAudioDataByteSize = self.audioDataFormat.mBytesPerFrame * AUDIO_BUFFER_SIZE;
    float *sampleBuffer = (float *)audioQueueBufferRef->mAudioData;

    // バファーサイズ分音のデータを書き込む
    for (int i = 0; i < AUDIO_BUFFER_SIZE; i++) {
        
        // output Left
        float toneLeft = 0;
        if (self.toneOutPut & kToneLeft) {
            toneLeft = (sin( phasePerSample * self.toneCycle ) * self.toneVolume )* INT16_MAX / 32768.f;;
        }
        
        // output Right
        float toneRight = 0;
        if (self.toneOutPut & kToneRight) {
            toneRight = (sin( phasePerSample * self.toneCycle ) * self.toneVolume )* INT16_MAX / 32768.f;;
        }
        
        
        // write tone data
        *sampleBuffer = toneLeft;
        sampleBuffer+=1;
        *sampleBuffer = toneRight;
        sampleBuffer+=1;
        
        self.toneCycle += 1;
    }
    
    AudioQueueEnqueueBuffer(audioQueueRef, audioQueueBufferRef, 0, NULL);
    
    // over flow
    if ( self.toneCycle  > AUDIO_SAMPLING_RATE ) {
        self.toneCycle -= AUDIO_SAMPLING_RATE;
    }
    
}

- (void)stop {
    AudioQueueStop(self.audioQueue, true);
}

@end
