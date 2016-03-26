//
//  ExpressSearchViewController.h
//  百宝袋
//
//  Created by admin on 15/11/11.
//  Copyright (c) 2015年 handsome. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ExpressSearchViewController : UIViewController
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UILabel *myExpressName;
@property (weak, nonatomic) IBOutlet UILabel *myExpressNumber;
@property (weak, nonatomic) IBOutlet UITableView *myExpressProcessTableView;
@property (weak, nonatomic) IBOutlet UILabel *sign;

@property (weak, nonatomic) IBOutlet UILabel *myExpressNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *myExpressNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *myExpressSignLabel;
@property (weak, nonatomic) IBOutlet UILabel *myExpress;

@end
