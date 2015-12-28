//
//  VudioTool.h
//  RecordingTool
//
//  Created by 张锦辉 on 15/11/24.
//  Copyright © 2015年 张锦辉. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>

@class AudioTool;

@protocol AudioToolDelegate <NSObject>

@optional
//所有的处理都在这三个里面实现
/**
 *开始录音录音时所做操作
 */
-(void)whenStartRecord:(AudioTool *)audioTool withRecordPath:(NSString *)audio_path;


/**
 *录音过程中对录音的处理,它的一些需要处理的对象
 */
-(void)whenRecording:(AudioTool *)audioTool withRecordMessage:(NSDictionary *)audio_attribute;


/**
 *录音结束后的处理（一般是UI方面的处理）
 */
-(void) whenEndRecord:(AudioTool *)audioTool withRecordPathArray:(NSArray *)audio_pathArr;

@optional
/**
 *播放器的处理，获取录制播放当前时间
 */

-(void)whenPlaying:(AudioTool *)audioTool withPlayTimer:(float)playTime;



@end


@interface AudioTool : NSObject <AVAudioRecorderDelegate>

@property (nonatomic, assign) id <AudioToolDelegate>delegate;
@property(nonatomic,strong) AVAudioRecorder *audioRecorder;//录音
@property(nonatomic,strong) AVAudioPlayer *audioPlayer;//播放

@property (nonatomic ,copy)NSString *audio_path;
@property (nonatomic,strong) NSTimer *timer;//录音声波监控（注意这里暂时不对播放进行监控）
@property (nonatomic,strong) NSTimer *timer2;
@property float playTimeNum;


+(AudioTool *)shared;

/**
 *录音所有文件列表
 */
-(NSArray *)audioArr;
/**
 *开始录音
 */
-(void)startRecord;
/**
 *暂停录音
 */
-(void)pauseRecord;

/**
 *恢复录音
 */
-(void)resumeRecord;

/**
 *停止录音
 */
-(void)stopRecordIsRemoveVudioNow:(BOOL)isremoverVudio;

/**
 *删除文件
 */
-(void)removeRecordAudios:(int)index;

/**
 *开始播放
 */
-(void)startPlayVudio:(int)index;

/**
 *暂停播放
 */
-(void)pausePlay;

/**
 *停止播放
 */
-(void)stopPlay;

/**
 *是否靠近耳朵
 */
-(void)earNearIphone;


@end
