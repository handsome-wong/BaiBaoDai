//
//  ViewController.m
//  百宝袋
//
//  Created by admin on 15/11/10.
//  Copyright (c) 2015年 handsome. All rights reserved.
//

#import "ViewController.h"
#import "NoteViewController.h"
#import "WeatherViewController.h"
#import "ExpressViewController.h"
#import "GameHomeViewController.h"
@interface ViewController ()

@end

@implementation ViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initView];
}

- (void)initView {
    UIImage *express_tabbar_noraml = [UIImage imageNamed:@"express_normal"];
    UIImage *express_tabbar_pressed = [UIImage imageNamed:@"express_pressed"];
    
    UIImage *weather_tabbar_noraml = [UIImage imageNamed:@"weather_normal"];
    UIImage *weather_tabbar_pressed = [UIImage imageNamed:@"weather_pressed"];
    
    UIImage *note_tabbar_noraml = [UIImage imageNamed:@"tabbar-news-selected"];
    UIImage *note_tabbar_pressed = [UIImage imageNamed:@"tabbar-news"];
    
    UIImage *game_tabbar_noraml = [UIImage imageNamed:@"godmode"];
    UIImage *game_tabbar_pressed = [UIImage imageNamed:@"goberserk"];
    
    UITabBarController *tabBarController = [[UITabBarController alloc]init];
    tabBarController.delegate = self;
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tabBarController.tabBar.frame.size.width, tabBarController.tabBar.frame.size.height)];
    backView.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:0.9 alpha:1];
    [tabBarController.tabBar insertSubview:backView atIndex:0];
    
    ExpressViewController *expressVC = [[ExpressViewController alloc]init];
    UINavigationController *expressNav = [[UINavigationController alloc]initWithRootViewController:expressVC];
    expressNav.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"快递" image:express_tabbar_noraml selectedImage:express_tabbar_pressed];
    
    WeatherViewController *weatherVC = [[WeatherViewController alloc]init];
    UINavigationController *weatherNav = [[UINavigationController alloc]initWithRootViewController:weatherVC];
    weatherNav.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"天气" image:weather_tabbar_noraml selectedImage:weather_tabbar_pressed];
    
    NoteViewController *noteVC = [[NoteViewController alloc] init];
    UINavigationController *noteNav = [[UINavigationController alloc] initWithRootViewController:noteVC];
    noteNav.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"备忘" image:note_tabbar_noraml selectedImage:note_tabbar_pressed];
    
//    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    GameHomeViewController *gameVC = [self.storyboard instantiateViewControllerWithIdentifier:@"game"];
//    UINavigationController *gameNav = [[UINavigationController alloc] initWithRootViewController:gameVC];
//    noteNav.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"游戏" image:game_tabbar_noraml selectedImage:game_tabbar_pressed];
    
    tabBarController.viewControllers = [NSArray arrayWithObjects:expressNav,weatherNav, noteNav,nil];
    
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:71.0/255.0 green:71.0/255.0 blue:71.0/255.0 alpha:1.0]];
    //设置标题大小颜色
    [noteNav.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:19],
       NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    // 重要：一定不能让 tabBarController 释放掉，否则会引起崩溃
    self.topTabBarController = tabBarController;
    [self.view addSubview:tabBarController.view];
    self.view.backgroundColor = [UIColor whiteColor];

}


@end
