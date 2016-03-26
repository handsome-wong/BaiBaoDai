//
//  ExpressViewController.m
//  百宝袋
//
//  Created by admin on 15/11/10.
//  Copyright (c) 2015年 handsome. All rights reserved.
//

#import "ExpressViewController.h"
#import "Express.h"
#import "ExpressSearchViewController.h"
#import "ExpressTableViewCell.h"
#import "NotePushViewController.h"
#import "AFNetworking.h"
#import "NoteDao.h"
#import "NoteBeen.h"
#import "Util.h"

@interface ExpressViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) NSArray *expressArr;

@end

@implementation ExpressViewController
@synthesize expressArr;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"快 递"];
    expressArr = [self findExpressArray];
    _expressTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"note"] == nil) {
        [self pushNote:nil];
        [defaults setObject:@"note" forKey:@"note"];
    }
//    [_expressTableView setSeparatorInset:UIEdgeInsetsMake(2, 6, 2, 6)];

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return expressArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ExpressTableViewCell *cell = [ExpressTableViewCell expressTableViewCellWithTableView:tableView];
    
    Express *model = expressArr[indexPath.row];
  
    cell.expressIcon.image = [UIImage imageNamed:model.icon];
    cell.expressName.text = model.name;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.backgroundColor = [UIColor clearColor];
    
    return cell;
}

#pragma mark - 跳转
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    Express *model = expressArr[indexPath.row];
    NSString *expressId =model.expressId;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:expressId forKey:@"expressId"];
    [defaults setObject:model.name forKey:@"expressName"];
    [defaults synchronize];
    ExpressSearchViewController *expressSearchVC = [[ExpressSearchViewController alloc] init];
    [self.navigationController pushViewController:expressSearchVC animated:YES];
}

#pragma mark - 返回row的高度
-  (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
     return 60;
}

- (NSArray *)findExpressArray
{
    
    if (expressArr ==nil) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"ExpressName.plist" ofType:nil];
        NSArray *arrayDict = [[NSArray alloc] initWithContentsOfFile:path];
        NSMutableArray *arrayModels = [NSMutableArray array];
        for (NSDictionary *dict in arrayDict ) {
            Express *model = [Express expressWithDict:dict];
            [arrayModels addObject:model];
        }
        expressArr = arrayModels;
        
    }
  
    return expressArr;
}


#pragma mark - 视图出现
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.hidesBottomBarWhenPushed = YES;
}

#pragma mark - 视图消失
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    self.hidesBottomBarWhenPushed = NO;
}


//默认记录笔记
- (void)pushNote:(id)sender {
    NSString *noteTitle = @"欢迎来到百宝袋备忘录";
    NSString *noteDate = @"2020/01/01";
    NSString *content = @"快开始撰写你的备忘吧";
    
    NSDate *date = [[NSDate alloc] init];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd/MM/yyyy"];
    NSString *noteFinishDate = [dateFormatter stringFromDate:date];
    NSData *imageData = UIImagePNGRepresentation([UIImage imageNamed:@"weatherBackground"]);
    NSString *imageString = [imageData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    
    NoteBeen *noteBeen = [[NoteBeen alloc] initWithNoteStartTime:noteDate NoteFinishTime:noteFinishDate NoteContent:content NoteLocation:@"暂无" NotePhoto:imageString NoteTitle:noteTitle];
    NoteDao *noteDao = [[NoteDao alloc] init];
    if ([noteDao insertNote:noteBeen]) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [Util showToastWithView:self.view text:@"备忘失败！"];
        
    }
    
}



@end
