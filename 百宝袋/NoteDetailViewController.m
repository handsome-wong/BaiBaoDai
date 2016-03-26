//
//  NoteDetailViewController.m
//  百宝袋
//
//  Created by admin on 15/11/24.
//  Copyright (c) 2015年 handsome. All rights reserved.
//

#import "NoteDetailViewController.h"
#import "NoteDao.h"
#import "NoteBeen.h"

@interface NoteDetailViewController ()

@end

@implementation NoteDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    _noteTitleLabel.text = [defaults objectForKey:@"noteTitle"];
    _noteTimeLabel.text = [defaults objectForKey:@"noteTime"];
    _noteContentLabel.text = [defaults objectForKey:@"noteContent"];
    _noteImageView.image = [UIImage imageWithData:[[ NSData  alloc]initWithBase64EncodedString:[defaults objectForKey:@"notePhoto"] options:NSDataBase64DecodingIgnoreUnknownCharacters]];
}


@end
