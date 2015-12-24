//
//  NoiseAnalyzer.m
//  Noise Analyzer Implementation 
//
//  Created by Yi Ge on 15/12/02.
//  Copyright  2015 IBM Research-China. All rights reserved.
//

#import "NoiseAnalyzer.h"
//#include <math.h>

@implementation NoiseAnalyzer

#pragma mark - NoiseAnalyzer methods
/**
 * Start audio analysis
 */
-(void)startAudioAnalysis: (NSString *)file_path{
    
    _audioData = [[NSData alloc] init];
    _startPos = 0;
    _audioPower = 0.1;
    _fp = fopen([file_path cStringUsingEncoding:NSASCIIStringEncoding], "rb");
    
    NSLog(@"开始录音了，这是一个路径");
}

/**
 * Analyze audio data
 */
-(void)audioAnalyze{
    

    if (_fp == nil) {
        NSLog(@": null file pointer %@",_fp);
        return;
    }
    
    fseek(_fp, 0, SEEK_END);
    long endPos = ftell(_fp);
    long length = endPos - _startPos;
    char buff[65536] = {0};
    
    fseek(_fp, _startPos, SEEK_SET);
    fread(buff, 1, 2048, _fp);
    _startPos = endPos;
    _audioData = [NSData dataWithBytes:buff length:length];
    short *_recordingData = (short *)_audioData.bytes;
    unsigned long pcmLen = _audioData.length;
    
    double v = 0;
    for (int i = 0; i<pcmLen; i++) {
       v +=  _recordingData[i] * _recordingData[i];
    }
    
    if (pcmLen != 0) {
        
        float mean = v / pcmLen;
        _audioPower  = 10 * log10(mean);
    }
}

/**
 * Stop audio analysis
 */
-(void)stopAudioAnalysis{

    if (_fp != nil) {
        fclose(_fp);
    }
    _fp = nil;
    _audioData = nil;
    NSLog(@"%ld",_startPos);
    NSLog(@"停止录音所要干的事");
}


#pragma mark - Protocol VudioToolDelegate


@end