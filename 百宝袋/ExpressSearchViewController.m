//
//  ExpressSearchViewController.m
//  百宝袋
//
//  Created by admin on 15/11/11.
//  Copyright (c) 2015年 handsome. All rights reserved.
//

#import "ExpressSearchViewController.h"
#import "ASIFormDataRequest.h"
#import "JSONKit.h"
#import "ExpressProcess.h"
#import "Util.h"
@interface ExpressSearchViewController ()<UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) NSArray *myExpressArr;

@property (strong, nonatomic) UIProgressView *progressView;

@end

@implementation ExpressSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _searchBar.delegate = self;
    _myExpressProcessTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

#pragma mark - 视图出现
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self isHiddenLabel:YES];
}

#pragma mark - 视图消失
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self isHiddenLabel:NO];
}

#pragma mark - searchBar点击
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    _progressView = [Util showProgressWithView:self.view text:@"正在查询..."];
    [self searchMyEXpress];
}

- (void)searchMyEXpress {
    [_searchBar resignFirstResponder];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *expressId = [defaults valueForKey:@"expressId"];
    [self searchExpressByConnection:expressId :_searchBar.text];

}

- (BOOL)prefersStatusBarHidden{
    return YES;
}

- (void)searchExpressByConnection:(NSString *)type :(NSString *)expressId{
    
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://www.kuaidi100.com/query?type=%@&postid=%@",type,expressId]];
    NSLog(@"url=%@",url);
    
    ASIFormDataRequest *requestForm = [[ASIFormDataRequest alloc] initWithURL:url];
    [requestForm setDidFinishSelector:@selector(requestDone:)];
    [requestForm setDidFailSelector:@selector(requestWentWrong:)];
    [requestForm setDelegate:self];
    [requestForm startAsynchronous];
    
    
}

- (void)requestDone:(ASIHTTPRequest *)request{
    NSString *json = [request responseString];
    NSDictionary *result = [json objectFromJSONStringWithParseOptions:JKParseOptionLooseUnicode];
    NSLog(@"result=%@",result);
    _progressView.hidden = YES;
    NSString *message = [result objectForKey:@"message"];
    if ([message isEqualToString:@"ok"] == YES) {
        [self isHiddenLabel:NO];
        NSArray *data = [result objectForKey:@"data"];
        _myExpressArr = data;
        [self showExpressMessage:[[NSUserDefaults standardUserDefaults] objectForKey:@"expressName"] :_searchBar.text :[result objectForKey:@"ischeck"]];
        [_myExpressProcessTableView reloadData];
    } else {
        [Util showToastWithView:self.view text:@"查找失败！"];
    }
    
}

- (void)requestWentWrong:(ASIHTTPRequest *)request{
    NSError *error = [request error];
    NSLog(@"SeminarError=%@",error);
    [Util showToastWithView:self.view text:@"查找失败！"];
    
}

#pragma mark - cell生成
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _myExpressArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dataDict = _myExpressArr[indexPath.row];
    
    static NSString *ID =@"cell";//保持ID不会给再次销毁创建
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
        
    }
    NSString *context = [dataDict objectForKey:@"context"];
    [Util setTitleWithText:context cell:cell];
    cell.detailTextLabel.text = [dataDict objectForKey:@"time"];
    cell.backgroundColor = [UIColor clearColor];
    return cell;
 
}

#pragma mark - cell高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height;
}


#pragma mark - 显示信息
- (void)showExpressMessage:(NSString *)expressName :(NSString *)expressNumber :(NSString *)sign{
    _myExpressName.text = expressName;
    _myExpressNumber.text = expressNumber;
    _sign.textColor = [UIColor greenColor];
    if ([sign isEqualToString:@"1"]) {
        _sign.textColor = [UIColor greenColor];
            _sign.text = @"已签收";
    } else {
        _sign.textColor = [UIColor redColor];
        _sign.text = @"未签收";
    }

}

#pragma mark - 设置label隐藏
- (void)isHiddenLabel:(BOOL)isHidden {
    _myExpressNameLabel.hidden = isHidden;
    _myExpressNumberLabel.hidden = isHidden;
    _myExpressSignLabel.hidden = isHidden;
    _myExpress.hidden = isHidden;
}

@end
