//
//  VudioTool.m
//  RecordingTool
//
//  Created by 张锦辉 on 15/11/24.
//  Copyright © 2015年 张锦辉. All rights reserved.
//

#import "AudioTool.h"

@implementation AudioTool

+ (AudioTool *)shared
{
    static AudioTool *class;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        class = [AudioTool new];
    });
    return class;
}

- (id)init
{
    if ((self = [super init]))
    {
        self.delegate = nil;
        self.playTimeNum = 0.0;
    }
    return self;
}

#pragma mark - 私有方法
/**
 *  设置录音音频会话
 */
-(void)setRecordSession{
    AVAudioSession *audioSession=[AVAudioSession sharedInstance];
    //设置为播放和录音状态，以便可以在录制完之后播放录音
    [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    [audioSession setActive:YES error:nil];
}


/**
 * 录音名称
 @return 录音名称（时间）
 */
-(NSString *)vudioName {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"MMddHHmmss"];
    NSDate *datenow = [NSDate date];//现在时间,你可以输出来看下是什么格式
    NSString *nowtimeStr = [formatter stringFromDate:datenow];
    NSString *vudioName = [NSString stringWithFormat:@"%@.wav",nowtimeStr];
    return vudioName;
}

/**
 *  取得录音文件保存路径
 *
 *  @return 录音文件路径
 */
-(NSURL *)getSavePath:(NSString *)vudioName{
    NSString *urlStr=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    urlStr=[urlStr stringByAppendingPathComponent:vudioName];
    NSURL *url=[NSURL fileURLWithPath:urlStr];
    NSLog(@"路径:%@",url);
    return url;
}

/**
 *  取得录音文件设置
 *
 *  @return 录音设置
 */

-(NSDictionary *)getAudioSetting{
    NSMutableDictionary *dicM=[NSMutableDictionary dictionary];
    //设置录音格式
    [dicM setObject:@(kAudioFormatLinearPCM) forKey:AVFormatIDKey];
    //设置录音采样率，8000是电话采样率，对于一般录音已经够了
    [dicM setObject:@(11025) forKey:AVSampleRateKey];
    //设置通道,这里采用单声道
    [dicM setObject:@(1) forKey:AVNumberOfChannelsKey];
    //每个采样点位数,分为8、16、24、32
    [dicM setObject:@(16) forKey:AVLinearPCMBitDepthKey];
    //是否使用浮点数采样
    [dicM setObject:@(NO) forKey:AVLinearPCMIsFloatKey];
    //....其他设置等
    [dicM setValue:@(AVAudioQualityMax) forKey:AVEncoderAudioQualityKey];
    return dicM;
}

/**
 *采样文件
 *@return 采样列表
 */
-(NSArray *)audioArr {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory,NSUserDomainMask, YES);
    //return [fileManager directoryContentsAtPath:[paths objectAtIndex:0]];
    return [fileManager contentsOfDirectoryAtPath:[paths objectAtIndex:0] error:nil];
    
}

/**
 *  录音声波监控定制器
 *  @return 定时器
 */
-(NSTimer *)timer{
    if (!_timer) {
        _timer=[NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(audioPowerChange) userInfo:nil repeats:YES];
    }
    return _timer;
}

-(NSTimer *)timer2 {

    if (!_timer2) {
        _timer2 = [NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(playPowerChange) userInfo:nil repeats:YES];
    }
    
    return _timer2;
}

/**
 *  录音声波状态设置
 */
-(void)audioPowerChange{
    [self.audioRecorder updateMeters];//更新测量值
    float power= [self.audioRecorder averagePowerForChannel:0];//取得第一个通道的音频，注意音频强度范围时-160到0
    
    //录制过程中处理的对象
    NSDictionary *dict = @{@"power":[NSString stringWithFormat:@"%f",power]};
    [self.delegate whenRecording:self withRecordMessage:dict];
    
}

-(void)playPowerChange {
    _playTimeNum += 0.1;
    
    if ([[NSString stringWithFormat:@"%.1f",_playTimeNum] isEqualToString:[NSString stringWithFormat:@"%.1f",_audioPlayer.duration]]) {
        self.timer2.fireDate = [NSDate distantFuture];
        _playTimeNum = 0.0;
    }
    
    [self.delegate whenPlaying:self withPlayTimer:_playTimeNum];
}

/**
 *  获得录音机对象
 *
 *  @return 录音机对象
 */
-(AVAudioRecorder *)audioRecorder{
    if (!_audioRecorder) {
        [self setRecordSession];
        //创建录音文件保存路径
        NSURL *url=[self getSavePath:[self vudioName]];
        //创建录音格式设置
        NSDictionary *setting=[self getAudioSetting];
        //创建录音机
        NSError *error=nil;
        _audioRecorder=[[AVAudioRecorder alloc]initWithURL:url settings:setting error:&error];
        _audioRecorder.delegate=self;
        _audioRecorder.meteringEnabled=YES;//如果要监控声波则必须设置为YES
        if (error) {
            NSLog(@"创建录音机对象时发生错误，错误信息：%@",error.localizedDescription);
            return nil;
        }
    }
    return _audioRecorder;
}


#pragma mark - 录音接口
-(void)startRecord {
    if (![self.audioRecorder isRecording]) {
        [self.audioRecorder record];//首次使用应用时如果调用record方法会询问用户是否允许使用麦克风
        self.timer.fireDate=[NSDate distantPast];
        NSLog(@"开始录制");
        
        NSString *path = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:[self audioArr][[self audioArr].count -1]];//这样设置，按逆序删除
    
        //开始录音的时候得到当前录音的路径
        [self.delegate whenStartRecord:self withRecordPath:path];
    }
}

-(void)pauseRecord {
    if ([self.audioRecorder isRecording]) {
        [self.audioRecorder pause];
        self.timer.fireDate=[NSDate distantFuture];
        NSLog(@"暂停录制");
    }
}


-(void)resumeRecord {
    [self startRecord];
}


-(void)stopRecordIsRemoveVudioNow:(BOOL)isremoverVudio{
    [_audioRecorder stop];
    _audioRecorder = nil;
    self.timer.fireDate = [NSDate distantFuture];//关闭定时器
    NSLog(@"停止录制");
    //如果设置为YES那么就删除本次录音
    if (isremoverVudio == YES) {
        [_audioRecorder deleteRecording];
    }
}


-(void)removeRecordAudios:(int)index{
    NSString *path = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:[self audioArr][[self audioArr].count - 1 - index]];//这样设置，按逆序删除
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager removeItemAtPath:path error:nil];
}


-(void)startPlayVudio:(int)index {
    AVAudioSession *audioSession=[AVAudioSession sharedInstance];
    //设置为播放和录音状态，以便可以在录制完之后播放录音
    [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
    [audioSession setActive:YES error:nil];
    NSURL *url=[self getSavePath:[self audioArr][[self audioArr].count - 1 - index]];
    NSError *error=nil;
    _audioPlayer=[[AVAudioPlayer alloc]initWithContentsOfURL:url error:&error];
    _audioPlayer.numberOfLoops=0;
    [_audioPlayer prepareToPlay];
    if (error) {
        NSLog(@"创建播放器过程中发生错误，错误信息：%@",error.localizedDescription);
    }

            if (!_audioPlayer.isPlaying) {
            
                [_audioPlayer play];
                self.timer2.fireDate = [NSDate distantPast];
                
               
            }
}

-(void)pausePlay {
    if (_audioPlayer.isPlaying) {
        [_audioPlayer pause];
    }
}

-(void)stopPlay {
    
    if (_audioPlayer.isPlaying) {
        NSLog(@"停止播放");
        [_audioPlayer stop];
        _audioPlayer = nil;
        
        self.timer2.fireDate = [NSDate distantFuture];
        //self.playTimeNum = 0.0;
    }
}

#pragma mark - 录音机代理方法
/**
 *  录音完成，录音完成后播放录音
 *
 *  @param recorder 录音机对象
 *  @param flag     是否成功
 */
-(void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag{
    //录制完成之后
    [self.delegate whenEndRecord:self withRecordPathArray:[self audioArr]];
}


#pragma mark - 耳朵接近扬声器
-(void)earNearIphone {
    UIDevice *device = [UIDevice currentDevice ];
    device.proximityMonitoringEnabled=YES; // 允许临近检测

    if (device.proximityMonitoringEnabled == YES) {
        // 临近消息触发
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                selector:@selector(proximityChanged:)
                                                name:UIDeviceProximityStateDidChangeNotification object:device];

    }
}

-(void)proximityChanged:(NSNotification *)notification {
    //如果此时手机靠近面部放在耳朵旁，那么声音将通过听筒输出，并将屏幕变暗
    if ([[UIDevice currentDevice] proximityState] == YES){
        NSLog(@"接近耳朵");
        //设置从听筒不放,状态设置成播放和录音
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    }
    else{
        NSLog(@"不接近耳朵");
        //设置扬声器播放
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    }

}

@end