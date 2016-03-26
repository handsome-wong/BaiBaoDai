//
//  AppDelegate.m
//  百宝袋
//
//  Created by admin on 15/11/10.
//  Copyright (c) 2015年 handsome. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import <AFNetworking/AFNetworking.h>
#import "AVfoundation/Avfoundation.h"

#define APPURL @"http://itunes.apple.com/lookup?id=1061914746"

@interface AppDelegate ()



@end

@implementation AppDelegate {
    NSMutableData *receiveData;
    NSTimer *timer;
    int newNotifCount;
    NSArray *lastNotifList;
    NSString *trackViewURL;

}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    //用户是否允许通知
    if ([self registNotification]) {
        //应用可以后台运行的设置
        NSError *setCategoryErr=nil;
        NSError *activationErr=nil;
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:&setCategoryErr];
        [[AVAudioSession sharedInstance] setActive:YES error:&activationErr];
    }
    //检查版本更新
    if ([self isEightDayPass]) {
        [self checkVersion];
    }
    return YES;
}

#pragma mark 注册通知
-(BOOL)registNotification{
    if ([self isSystemVersioniOS8]) {//IOS8
        //如果已经获得发送通知的授权则创建本地通知，否则请求授权(注意：如果不请求授权在设置中是没有对应的通知设置项的，也就是说如果从来没有发送过请求，即使通过设置也打不开消息允许设置)
        if ([[UIApplication sharedApplication]currentUserNotificationSettings].types!=UIUserNotificationTypeNone){
            [[UIApplication sharedApplication]registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound  categories:nil]];
            return YES;
        }
        
    }else{//IOS7
        UIRemoteNotificationType type=[[UIApplication sharedApplication]enabledRemoteNotificationTypes];
        int typeBadge = (type & UIRemoteNotificationTypeBadge);
        int typeSound = (type & UIRemoteNotificationTypeSound);
        int typeAlert = (type & UIRemoteNotificationTypeAlert);
        BOOL ret =  !typeBadge || !typeSound || !typeAlert;
        return ret;
    }
    return NO;
}
#pragma mark 检查系统是否为IOS8以上
-(BOOL)isSystemVersioniOS8 {
    //check systemVerson of device
    UIDevice *device = [UIDevice currentDevice];
    float sysVersion = [device.systemVersion floatValue];
    if (sysVersion >= 8.0f) {
        return YES;
    }
    return NO;
}


#pragma mark - 版本更新提示
#pragma mark - 获取应用的版本信息
-(void)checkVersion
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:APPURL parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray* infoArray = [responseObject objectForKey:@"results"];
        if (infoArray.count>0) {
            NSDictionary* releaseInfo =[infoArray objectAtIndex:0];
            NSString* appStoreVersion = [releaseInfo objectForKey:@"version"];
            NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
            NSString *currentVersion = [infoDic objectForKey:@"CFBundleShortVersionString"];
            if (![appStoreVersion isEqualToString:currentVersion])
            {
                trackViewURL = [[NSString alloc] initWithString:[releaseInfo objectForKey:@"trackViewUrl"]];
                NSString* msg =[releaseInfo objectForKey:@"releaseNotes"];
                UIAlertView* alertview =[[UIAlertView alloc] initWithTitle:@"版本升级" message:[NSString stringWithFormat:@"%@%@%@", @"新版本特性:",msg, @"\n是否升级？"] delegate:self cancelButtonTitle:@"稍后升级" otherButtonTitles:@"马上升级", nil];
                [alertview show];
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
}

#pragma mark 点击升级的跳转界面
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==1)
    {
        UIApplication *application = [UIApplication sharedApplication];
        [application openURL:[NSURL URLWithString:trackViewURL]];
    }
}

#pragma mark 判断当前时间
-(BOOL)isEightDayPass{
    NSDate *  senddate=[NSDate date];
    
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    
    [dateformatter setDateFormat:@"yyyyMMdd"];
    
    NSString *  locationString=[dateformatter stringFromDate:senddate];
    NSLog(@"location data is %@",locationString);
    if([locationString intValue]>20160120){
        return YES;
        
    }else{
        return NO;
    }
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
