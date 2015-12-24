//
//  AudioTableViewCell.m
//  RecordingTool
//
//  Created by 张锦辉 on 15/11/25.
//  Copyright © 2015年 张锦辉. All rights reserved.
//

#import "AudioTableViewCell.h"

@implementation AudioTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    self.stopPlayBtn.layer.cornerRadius = 5;
    self.stopPlayBtn.layer.borderColor = [UIColor redColor].CGColor;
    self.stopPlayBtn.layer.borderWidth =  1;
    
    //self.stopPlayBtn.enabled = NO;
}


@end
