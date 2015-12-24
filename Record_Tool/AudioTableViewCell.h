//
//  AudioTableViewCell.h
//  RecordingTool
//
//  Created by 张锦辉 on 15/11/25.
//  Copyright © 2015年 张锦辉. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AudioTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *audioRecordLabel;
@property (weak, nonatomic) IBOutlet UILabel *numLabel;
@property (weak, nonatomic) IBOutlet UIButton *stopPlayBtn;


@end
