//
//  NoteViewController.m
//  百宝袋
//
//  Created by admin on 15/11/10.
//  Copyright (c) 2015年 handsome. All rights reserved.
//

#import "NoteViewController.h"
#import "NotePushViewController.h"
#import "ExpressSearchViewController.h"
#import "WeatherViewController.h"
#import "NoteBeen.h"
#import "NoteDao.h"
#import "NoteDetailViewController.h"

#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)


@interface NoteViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>


@property (strong, nonatomic) NSArray *noteArray;

@property (strong, nonatomic) NSDictionary *noteDict;

@end

@implementation NoteViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self setTitle:@"备 忘"];

    //获取Note列表
    NoteDao *noteDao = [[NoteDao alloc] init];
    _noteArray = [noteDao findAllNote];
    
       _noteCollectionView.backgroundColor = [UIColor whiteColor];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //获取Note列表
    NoteDao *noteDao = [[NoteDao alloc] init];
    _noteArray = [noteDao findAllNote];
    [_noteCollectionView reloadData];
    

}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    self.hidesBottomBarWhenPushed = YES;
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    self.hidesBottomBarWhenPushed = NO;
}

#pragma mark - 生成cell

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)sectio {
    
    return _noteArray.count;

}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NoteBeen *noteBeen = [_noteArray objectAtIndex:indexPath.row];
    
    static NSString *ID = @"cell";

    //通过Nib生成cell，然后注册 Nib的view需要继承 UICollectionViewCell
    [self.noteCollectionView registerNib:[UINib nibWithNibName:@"NoteCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:ID];
    NoteCollectionViewCell *cell = (NoteCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    
    cell.noteTitle.text = noteBeen.noteTitle;
    cell.NoteStartTime.text = noteBeen.noteStartTime;
    cell.noteContent.text = noteBeen.noteContent;
    [cell.noteImageView setImage:[UIImage imageWithData:[[NSData alloc]initWithBase64EncodedString:noteBeen.notePhoto options:NSDataBase64DecodingIgnoreUnknownCharacters]]];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NoteBeen *noteBeen = [_noteArray objectAtIndex:indexPath.row];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:noteBeen.noteTitle forKey:@"noteTitle"];
    [defaults setObject:noteBeen.noteStartTime forKey:@"noteTime"];
    [defaults setObject:noteBeen.noteContent forKey:@"noteContent"];
    [defaults setObject:noteBeen.notePhoto forKey:@"notePhoto"];
    [defaults synchronize];
    
    NoteDetailViewController *noteDetailVc = [[NoteDetailViewController alloc] init];
    [self.navigationController pushViewController:noteDetailVc animated:YES];
    
}

//collection头部
- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {

}

#pragma mark --UICollectionViewDelegateFlowLayout
//定义每个CollectionCell 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    float cellWith=(SCREEN_WIDTH-60)/2;
    float cellHeight=cellWith;
    NSLog(@"wh=%f",cellHeight);
    return CGSizeMake(cellWith,cellHeight);
}


//定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    
    return UIEdgeInsetsMake(-15, 10, 15, 15);
}




- (IBAction)addNote:(id)sender {
    NotePushViewController *notePushVC = [[NotePushViewController alloc] init];
    [self.navigationController pushViewController:notePushVC animated:YES];
}
@end
