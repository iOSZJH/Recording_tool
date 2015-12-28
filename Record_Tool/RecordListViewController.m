//
//  RecordListViewController.m
//  Record_Tool
//
//  Created by 张锦辉 on 15/12/21.
//  Copyright © 2015年 张锦辉. All rights reserved.
//

#import "RecordListViewController.h"

#define WIDTH [UIScreen mainScreen].bounds.size.width
#define HEIGHT [UIScreen mainScreen].bounds.size.height

@interface RecordListViewController ()
{
    UITableView *audioTableView;
    AudioTool *audioTool;
   
}

@property (weak, nonatomic) IBOutlet UIButton *RecordBtn;
@property (weak, nonatomic) IBOutlet UIButton *PaauseBtn;
@property (weak, nonatomic) IBOutlet UIButton *ResumeBtn;
@property (weak, nonatomic) IBOutlet UIButton *StopBtn;

@end

@implementation RecordListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"Detail";
    [self setLayarOfSubView:_RecordBtn];
    [self setLayarOfSubView:_PaauseBtn];
    [self setLayarOfSubView:_ResumeBtn];
    [self setLayarOfSubView:_StopBtn];
    
    audioTool = [AudioTool shared];
    audioTool.delegate = self;
    

    [self makeTableView];
}


-(void)setLayarOfSubView:(UIButton *)btn {
    btn.layer.cornerRadius = 5;
    btn.layer.borderColor = [UIColor blueColor].CGColor;
    btn.layer.borderWidth = 1;
}


-(void)makeTableView {

    audioTableView = [[UITableView alloc] initWithFrame:CGRectMake(10, 64, WIDTH-20, _RecordBtn.frame.origin.y - 10 - 64) style:UITableViewStylePlain];
    audioTableView.dataSource = self;
    audioTableView.delegate = self;
    audioTableView.layer.borderWidth = 1;
    audioTableView.layer.borderColor = [UIColor blueColor].CGColor;
    [self.view addSubview:audioTableView];
}

- (IBAction)startRecad:(id)sender {
    
    [audioTool startRecord];
    
}

- (IBAction)pauseRecord:(id)sender {
    
    [audioTool pauseRecord];
}


- (IBAction)resumeRecord:(id)sender {
    
    [audioTool resumeRecord];
}

- (IBAction)stopRecord:(id)sender {
    
    [audioTool stopRecordIsRemoveVudioNow:NO];
}


#pragma mark -- VudioToolDelegate代理

-(void)whenStartRecord:(AudioTool *)audioTool withRecordPath:(NSString *)audio_path {
  
}

-(void)whenRecording:(AudioTool *)audioTool withRecordMessage:(NSDictionary *)audio_attribute {
    
 
}

-(void)whenEndRecord:(AudioTool *)vudioTool withRecordPathArray:(NSArray *)audio_pathArr {
    
    [self makeTableView];
   
}

-(void)whenPlaying:(AudioTool *)audioTool withPlayTimer:(float)playTime {

}

#pragma mark -- tableView的代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [audioTool audioArr].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    AudioTableViewCell* cell=[audioTableView dequeueReusableCellWithIdentifier:@"AudioTableViewCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"AudioTableViewCell" owner:self options:nil] lastObject];
    }
    
    cell.numLabel.text = [NSString stringWithFormat:@"录音 %ld",(long)indexPath.row];
    
    NSInteger num1 =[audioTool audioArr].count- 1 - indexPath.row;
    cell.audioRecordLabel.text = [audioTool audioArr][num1];
    
    [cell.stopPlayBtn addTarget:self action:@selector(stopPlayBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [[AudioTool shared] startPlayVudio:(int)indexPath.row];
}


-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [audioTool removeRecordAudios:(int)indexPath.row];
        [audioTool stopPlay];
        //audioTool = nil;
    }
    
    [audioTableView removeFromSuperview];
    [self makeTableView];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}


-(void)stopPlayBtnClick {

    [audioTool stopPlay];
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
