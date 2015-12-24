//
//  NoiseAnalyzer.h
//  Noise Analyzer Header
//
//  Created by Yi Ge on 15/12/01.
//  Copyright  2015 IBM Research-China. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>


@interface NoiseAnalyzer : NSObject
@property  FILE *fp;
@property long startPos;
@property (nonatomic,strong) NSData *audioData;
@property float audioPower;  //DB

/**
 * Start audio analysis
 */
-(void)startAudioAnalysis: (NSString *)file_path;

/**
 * Analyze audio data
 */
-(void)audioAnalyze;

/**
 * Stop audio analysis
 */
-(void)stopAudioAnalysis;

@end
