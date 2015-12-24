//
//  RecordListViewController.h
//  Record_Tool
//
//  Created by 张锦辉 on 15/12/21.
//  Copyright © 2015年 张锦辉. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AudioTableViewCell.h"
#import "AudioTool.h"

@interface RecordListViewController : UIViewController<AudioToolDelegate,UITableViewDataSource,UITableViewDelegate>

@end
