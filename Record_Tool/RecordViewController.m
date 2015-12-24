//
//  RecordViewController.m
//  Record_Tool
//
//  Created by 张锦辉 on 15/12/21.
//  Copyright © 2015年 张锦辉. All rights reserved.
//

#import "RecordViewController.h"
#import "RecordListViewController.h"
#define mainStoryBoard [UIStoryboard storyboardWithName:@"Main" bundle:nil]

@interface RecordViewController ()
{
     NoiseAnalyzer *analyzer;
    AudioTool *audioTool;
}
@property (weak, nonatomic) IBOutlet UIButton *RecordBtn;
@property (weak, nonatomic) IBOutlet UIButton *StopRecordBtn;
@property (weak, nonatomic) IBOutlet UIButton *PlayBtn;

@property (weak, nonatomic) IBOutlet UILabel *powerLabel;
@property (weak, nonatomic) IBOutlet UIProgressView *PowerProgress;
@property (weak, nonatomic) IBOutlet UILabel *my_powerLabel;
@property (weak, nonatomic) IBOutlet UIProgressView *my_PowerProgress;

@end

@implementation RecordViewController

-(void)setLayarOfSubView:(UIButton *)btn {
    btn.layer.cornerRadius = 5;
    btn.layer.borderColor = [UIColor blueColor].CGColor;
    btn.layer.borderWidth = 1;
}

-(void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];
    audioTool = [AudioTool shared];
    audioTool.delegate = self;
    analyzer= [[NoiseAnalyzer alloc] init];
}

- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self setLayarOfSubView:_RecordBtn];
    [self setLayarOfSubView:_StopRecordBtn];
    [self setLayarOfSubView:_PlayBtn];
    
    
    [_PlayBtn setTitle:@"Play" forState:UIControlStateNormal];
    [_PlayBtn setTitle:@"Unplay" forState:UIControlStateSelected];
    [_PlayBtn setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
    [_PlayBtn addTarget:self action:@selector(playSelected:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    rightBtn.frame = CGRectMake(0, 0, 60, 30);
    [rightBtn setTitle:@"Next->" forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(RightClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
}

-(void)playSelected:(UIButton *)play {

    play.selected = !play.selected;
    if (play.selected == YES) {
        [audioTool startPlayVudio:0];
    }else {
        [audioTool stopPlay];
    }

}




- (IBAction)RecordClick:(id)sender {
    
    [audioTool startRecord];
}

- (IBAction)StopRecordClick:(id)sender {
    [audioTool stopRecordIsRemoveVudioNow:NO];
}



#pragma mark -- VudioToolDelegate代理

-(void)whenStartRecord:(AudioTool *)audioTool withRecordPath:(NSString *)audio_path {
    
    [analyzer startAudioAnalysis:audio_path];
}

-(void)whenRecording:(AudioTool *)audioTool withRecordMessage:(NSDictionary *)audio_attribute {
    
    [analyzer audioAnalyze];
    
    float powerProgress = ([audio_attribute[@"power"] floatValue] + 160)/160.0;
    self.powerLabel.text = [NSString stringWithFormat:@"power: %f",[audio_attribute[@"power"] floatValue]];
    self.PowerProgress.progress = powerProgress;
    
    float myPowerProgress = analyzer.audioPower/120.0;
    self.my_powerLabel.text = [NSString stringWithFormat:@"myPower: %f",analyzer.audioPower];
    self.my_PowerProgress.progress = myPowerProgress;
    
}

-(void)whenEndRecord:(AudioTool *)vudioTool withRecordPathArray:(NSArray *)audio_pathArr {
    [analyzer stopAudioAnalysis];
}

-(void)RightClick {
    RecordListViewController *vc = [mainStoryBoard instantiateViewControllerWithIdentifier:@"RecordListView"];
    [self.navigationController pushViewController:vc animated:YES];
   
    [self setNew];
}


-(void)setNew {

    audioTool = nil;
    analyzer = nil;
    self.my_powerLabel.text = @"my_power";
    self.powerLabel.text = @"power: ";
    self.PowerProgress.progress = .5;
    self.my_PowerProgress.progress = .5;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
