//
//  NoteDetailViewController.h
//  百宝袋
//
//  Created by admin on 15/11/24.
//  Copyright (c) 2015年 handsome. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NoteDetailViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *noteTitleLabel;

@property (weak, nonatomic) IBOutlet UILabel *noteTimeLabel;

@property (weak, nonatomic) IBOutlet UILabel *noteContentLabel;

@property (weak, nonatomic) IBOutlet UIImageView *noteImageView;


@end
