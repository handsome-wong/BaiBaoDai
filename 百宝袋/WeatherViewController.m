//
//  WeatherViewController.m
//  百宝袋
//
//  Created by admin on 15/11/10.
//  Copyright (c) 2015年 handsome. All rights reserved.
//

#import "WeatherViewController.h"
#import "CoreLocation/CoreLocation.h"
#import "ASIFormDataRequest.h"
#import "JSONKit.h"
#import "Util.h"
#import "UIImageView+WebCache.h"
#import "WeatherTableViewCell.h"
#import <QuartzCore/QuartzCore.h>
#import "EGOCache.h"

@interface WeatherViewController ()<CLLocationManagerDelegate, UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) CLLocationManager* locationManager;

@property (strong, nonatomic) NSString *myCityName;

@property (strong, nonatomic) NSArray *weatherArray;

@property (strong, nonatomic) NSDictionary *weatherDict;

@property (strong, nonatomic) UIProgressView *progressView;
@end

@implementation WeatherViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"天 气"];
    
    if ([[EGOCache globalCache] hasCacheForKey:@"weatherCache"]) {
     id weatherCache = [[EGOCache globalCache] objectForKey:@"weatherCache"];
        _weatherArray = weatherCache;
    }
    _allDayWeatherTableView.delegate = self;
    _allDayWeatherTableView.dataSource = self;

    dispatch_async(dispatch_get_main_queue(), ^{
        [self startLocation];
    });
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _weatherArray.count;
}

//cell生成
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    _weatherDict = [_weatherArray objectAtIndex:[indexPath row]];
    
    NSString *cellID = @"cell";
    WeatherTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"WeatherTableViewCell" owner:nil options:nil] firstObject];
    }
    
    NSString *date;
    switch (indexPath.row) {
        case 0:
            date = @"今天";
            break;
        case 1:
            date = @"明天";
            break;
        default:
            date = [_weatherDict objectForKey:@"week"];
            date = [date stringByReplacingOccurrencesOfString:@"星期" withString:@"周"];
            break;
    }
    cell.date.text = date;
    cell.temperature.text = [_weatherDict objectForKey:@"temperature"];
    
    NSURL *url = [[NSURL alloc] initWithString: [_weatherDict objectForKey:@"weather_icon"]];
    NSURL *url_1 = [[NSURL alloc] initWithString:[_weatherDict objectForKey:@"weather_icon1"]];
    [cell.weatherImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"default"]];
    [cell.weatherImageView_1 sd_setImageWithURL:url_1 placeholderImage:[UIImage imageNamed:@"default"]];
    
    
    return cell;
    
}

//开始定位
-(void)startLocation{
    //菊花转
    _progressView = [Util showProgressWithView:self.view text:@"正在加载..."];
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.distanceFilter = 10.0f;
    [self.locationManager startUpdatingLocation];
}

//定位代理经纬度回调
-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    
    [_locationManager stopUpdatingLocation];
    NSLog(@"location ok");
    NSString *location = [NSString stringWithFormat:@"经度:%3.5f\n纬度:%3.5f",newLocation.coordinate.latitude,newLocation.coordinate.longitude];
    NSLog(@"%@",[NSString stringWithFormat:@"经度:%3.5f\n纬度:%3.5f",newLocation.coordinate.latitude,newLocation.coordinate.longitude]);
    [Util showToastWithView:self.view.window text:location];
    
    
    CLGeocoder * geoCoder = [[CLGeocoder alloc] init];
    [geoCoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        for (CLPlacemark * placemark in placemarks) {
            
            NSDictionary *locationDic = [placemark addressDictionary];
            //  Country(国家) State(省) City(城市)  SubLocality(区) FormattedAddressLines（地址）
            NSString *cityNameString = [locationDic objectForKey:@"City"];
            _myCityName = [cityNameString substringToIndex:[cityNameString length] - 1];
            NSLog(@"Name=%@",_cityName);
            [self getCityDataWithConnection];
            
            
        }
    }];
    
}

- (void)getCityDataWithConnection {
    NSURL *url = [NSURL URLWithString:@"http://api.k780.com:88/?app=weather.city&format=json"];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setDelegate:self];
    [request startAsynchronous];
}

#pragma mark - 请求完成
- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSString *json = [request responseString];
    NSDictionary *results = [json objectFromJSONStringWithParseOptions:JKParseOptionLooseUnicode];
    NSDictionary *result = [results objectForKey:@"result"];
    
    NSString *cityId = [self findCityNumberWithDict:result];
    [self searchCityWeatherWithCityId:cityId];
    NSLog(@"cityid=%@",cityId);
    
}

#pragma mark - 用城市名字查找
- (NSString *)findCityNumberWithDict:(NSDictionary *)result {
    
    for (int i=0; ; i++) {
        NSString *numKey = [NSString stringWithFormat:@"%d",i];
        NSDictionary *cityDic = [result objectForKey:numKey];
        NSString *cityName = [cityDic objectForKey:@"citynm"];
        if ([cityName isEqualToString:_myCityName]) {
            return [cityDic objectForKey:@"weaid"];
        }
    }
}

#pragma mark - 根据城市id来获取该城市的天气
- (void)searchCityWeatherWithCityId:(NSString *)cityId {
    
    NSString *urlStr = [NSString stringWithFormat:@"http://api.k780.com:88/?app=weather.future&weaid=%@&appkey=10003&sign=b59bc3ef6191eb9f747dd4e83c99f2a4&format=json",cityId];
    NSLog(@"url=%@",urlStr);
    NSURL *url = [NSURL URLWithString:urlStr];
    ASIHTTPRequest *request=[ASIHTTPRequest requestWithURL:url];
    [request setDelegate:self];
    [request setDidFinishSelector:@selector(requestDone:)];
    [request setDidFailSelector:@selector(requestWentWrong:)];
    [request startAsynchronous];
    
}


- (void)requestDone:(ASIHTTPRequest *)request{
    NSString *json = [request responseString];
    NSDictionary *jsonDict = [json  objectFromJSONStringWithParseOptions:JKParseOptionLooseUnicode];
    NSString *message = [jsonDict objectForKey:@"success"];
    if ([message isEqualToString:@"1"]){
        _weatherArray = [jsonDict objectForKey:@"result"];
        //缓存
        [[EGOCache globalCache] setObject:_weatherArray forKey:@"weatherCache"];
        
        NSLog(@"_weatherArray=%@",_weatherArray);
        NSDictionary *todayDict = [_weatherArray objectAtIndex:0];
        
        _cityName.text = [todayDict objectForKey:@"citynm"];
        _weather.text = [todayDict objectForKey:@"weather"];
        _wind.text = [todayDict objectForKey:@"wind"];
        _winp.text = [todayDict objectForKey:@"winp"];
        _temperature.text = [todayDict objectForKey:@"temperature"];
        NSURL *url = [[NSURL alloc] initWithString: [todayDict objectForKey:@"weather_icon"]];
        NSURL *url_1 = [[NSURL alloc] initWithString:[todayDict objectForKey:@"weather_icon1"]];
        [_weatherImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"default"]];
        [_weatherImageView_1 sd_setImageWithURL:url_1 placeholderImage:[UIImage imageNamed:@"default"]];
        
        NSString *myWeek = [todayDict objectForKey:@"week"];
        NSDate *date = [NSDate date];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter  setDateFormat:@"MM月dd日"];
        NSString *myDate = [dateFormatter stringFromDate:date];
        [dateFormatter setDateFormat:@"HH:mm"];
        NSString *myTime = [dateFormatter stringFromDate:date];
        _time.text = [NSString stringWithFormat:@"%@（%@）%@ 更新", myDate, myWeek, myTime];
        
        [_allDayWeatherTableView reloadData];
        _progressView.hidden = YES;//隐藏菊花
    }
    
}

- (void)requestWentWrong:(ASIHTTPRequest *)request{
    _progressView.hidden = YES;//隐藏菊花
    
    NSError *error = [request error];
    NSLog(@"SeminarError=%@",error);
    [Util showToastWithView:self.view text:@"获取天气失败！"];
    
}

//改变要查询的城市名称
- (IBAction)changeCityName:(id)sender {
//    [self startLocation];
    CLLocation *location = [[CLLocation alloc]init];
        NSString *locationStr = [NSString stringWithFormat:@"经度:%3.5f\n纬度:%3.5f",location.coordinate.latitude,location.coordinate.longitude];
      [Util showToastWithView:self.view.window text:locationStr];
}

//分享天气
- (IBAction)shareWeather:(id)sender {
//    [Util showToastWithView:self.view text:@"正在开发"];
//    [self screenShot];
}


//截图
-(void) screenShot
{
    UIGraphicsBeginImageContext(self.view.bounds.size);
    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image= UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    NSLog(@"image:%@",image);
    UIImageView *imaView = [[UIImageView alloc] initWithImage:image];
    imaView.frame = CGRectMake(0, 700, 500, 500);
    [self.view addSubview:imaView];
    UIImageWriteToSavedPhotosAlbum(image, self, nil, nil);
    
    
}




@end
