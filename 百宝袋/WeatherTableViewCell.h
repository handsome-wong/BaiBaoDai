//
//  WeatherTableViewCell.h
//  百宝袋
//
//  Created by admin on 15/11/20.
//  Copyright (c) 2015年 handsome. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WeatherTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *date;

@property (weak, nonatomic) IBOutlet UIImageView *weatherImageView;

@property (weak, nonatomic) IBOutlet UIImageView *weatherImageView_1;

@property (weak, nonatomic) IBOutlet UILabel *temperature;

@end
