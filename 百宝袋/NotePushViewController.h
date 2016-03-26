//
//  NotePushViewController.h
//  百宝袋
//
//  Created by admin on 15/11/23.
//  Copyright (c) 2015年 handsome. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NotePushViewController : UIViewController
- (IBAction)addDate:(id)sender;

@property (weak, nonatomic) IBOutlet UITextField *noteTitleTextField;

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UITextView *contentTextView;

- (IBAction)takePhoto:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *noteImageView;

- (IBAction)pushNote:(id)sender;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end
