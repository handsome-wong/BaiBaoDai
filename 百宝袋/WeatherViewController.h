//
//  WeatherViewController.h
//  百宝袋
//
//  Created by admin on 15/11/10.
//  Copyright (c) 2015年 handsome. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WeatherViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *cityName;

- (IBAction)changeCityName:(id)sender;

@property (weak, nonatomic) IBOutlet UIImageView *weatherImageView;

@property (weak, nonatomic) IBOutlet UIImageView *weatherImageView_1;

@property (weak, nonatomic) IBOutlet UILabel *temperature;

- (IBAction)shareWeather:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *weather;

@property (weak, nonatomic) IBOutlet UILabel *wind;

@property (weak, nonatomic) IBOutlet UILabel *winp;

@property (weak, nonatomic) IBOutlet UILabel *time;

@property (strong, nonatomic) IBOutlet UITableView *allDayWeatherTableView;
@end
