//
//  NoteViewController.h
//  百宝袋
//
//  Created by admin on 15/11/10.
//  Copyright (c) 2015年 handsome. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoteCollectionViewCell.h"

@interface NoteViewController : UIViewController

@property (weak, nonatomic) IBOutlet UICollectionView *noteCollectionView;
- (IBAction)addNote:(id)sender;

@end
