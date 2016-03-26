//
//  NotePushViewController.m
//  百宝袋
//
//  Created by admin on 15/11/23.
//  Copyright (c) 2015年 handsome. All rights reserved.
//

#import "NotePushViewController.h"
#import "CKCalendarView.h"
#import <CoreGraphics/CoreGraphics.h>
#import "NoteDao.h"
#import "NoteBeen.h"
#import "Util.h"

@interface NotePushViewController ()<UIActionSheetDelegate,CKCalendarDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property(nonatomic, weak) CKCalendarView *calendar;
@property(nonatomic, strong) NSDateFormatter *dateFormatter;
@property(nonatomic, strong) NSDate *minimumDate;
@property(nonatomic, strong) NSArray *disabledDates;



@property UIDatePicker *datePicker;

@end

@implementation NotePushViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setViewClickWithView:self.view];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"备忘" style:(UIBarButtonItemStyleBordered) target:self action:@selector(pushNote:)];
}


//添加日期
- (IBAction)addDate:(id)sender {
    [self showDCalendarView];
}

- (void)showDCalendarView {
    CKCalendarView *calendar = [[CKCalendarView alloc] initWithStartDay:startMonday];
    self.calendar = calendar;
    calendar.delegate = self;
    
    self.dateFormatter = [[NSDateFormatter alloc] init];
    [self.dateFormatter setDateFormat:@"dd/MM/yyyy"];
    self.minimumDate = [self.dateFormatter dateFromString:@"20/09/2012"];
    
    self.disabledDates = @[
                           [self.dateFormatter dateFromString:@"05/01/2013"],
                           [self.dateFormatter dateFromString:@"06/01/2013"],
                           [self.dateFormatter dateFromString:@"07/01/2013"]
                           ];
    
    calendar.onlyShowCurrentMonth = NO;
    calendar.adaptHeightToNumberOfWeeksInMonth = YES;
    
    calendar.frame = CGRectMake(10, 10, 300, 320);
    [self.view addSubview:calendar];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(localeDidChange) name:NSCurrentLocaleDidChangeNotification object:nil];
}


- (void)localeDidChange {
    [self.calendar setLocale:[NSLocale currentLocale]];
}

- (BOOL)dateIsDisabled:(NSDate *)date {
    for (NSDate *disabledDate in self.disabledDates) {
        if ([disabledDate isEqualToDate:date]) {
            return YES;
        }
    }
    return NO;
}

#pragma mark - CKCalendarDelegate

- (void)calendar:(CKCalendarView *)calendar configureDateItem:(CKDateItem *)dateItem forDate:(NSDate *)date {
    // TODO: play with the coloring if we want to...
    if ([self dateIsDisabled:date]) {
        dateItem.backgroundColor = [UIColor redColor];
        dateItem.textColor = [UIColor whiteColor];
    }
}

- (BOOL)calendar:(CKCalendarView *)calendar willSelectDate:(NSDate *)date {
    return ![self dateIsDisabled:date];
}

- (void)calendar:(CKCalendarView *)calendar didSelectDate:(NSDate *)date {
    self.dateLabel.text = [self.dateFormatter stringFromDate:date];
    _calendar.hidden = YES;
}

- (BOOL)calendar:(CKCalendarView *)calendar willChangeToMonth:(NSDate *)date {
    if ([date laterDate:self.minimumDate] == date) {
        self.calendar.backgroundColor = [UIColor blueColor];
        return YES;
    } else {
        self.calendar.backgroundColor = [UIColor redColor];
        return NO;
    }
}

- (void)calendar:(CKCalendarView *)calendar didLayoutInRect:(CGRect)frame {
    NSLog(@"calendar layout: %@", NSStringFromCGRect(frame));
}

#pragma mark - 打开photo
- (void)getPhoto{
    [_noteTitleTextField resignFirstResponder];
    UIActionSheet *myActionSheet = [[UIActionSheet alloc]
                                    initWithTitle:nil
                                    delegate:self
                                    cancelButtonTitle:@"取消"
                                    destructiveButtonTitle:nil
                                    otherButtonTitles:@"从相册选择" , @"拍照",nil];
    [myActionSheet showInView:self.view];
    
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0:
            //从相册选择
            [self LocalPhoto];
            break;
        case 1:
            //拍照
            [self takePhoto];
            break;
        default:
            break;
    }
}


//从相册选择
-(void)LocalPhoto{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    //资源类型为图片库
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate = self;
    //设置选择后的图片可被编辑
    //    picker.allowsEditing = YES;
    [self presentViewController:picker animated:YES completion:^{
    } ];
}

//拍照
-(void)takePhoto{
    //资源类型为照相机
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    //判断是否有相机
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]){
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        //设置拍照后的图片可被编辑
        picker.allowsEditing = YES;
        //资源类型为照相机
        picker.sourceType = sourceType;
        [self presentViewController:picker animated:YES completion:^{
            
        } ];
    }else {
        NSLog(@"没有摄像头");
    }
}


#pragma Delegate method UIImagePickerControllerDelegate
//图像选取器的委托方法，选完图片后回调该方法
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo{
    _noteImageView.image = image;
    //关闭相册界面
    [picker dismissModalViewControllerAnimated:YES];
}


//添加照片
- (IBAction)takePhoto:(id)sender {
    [self getPhoto];
}

//记录笔记
- (void)pushNote:(id)sender {
    NSString *noteTitle = _noteTitleTextField.text;
    NSString *noteDate = _dateLabel.text;
    NSString *content = _contentTextView.text;
    
    NSDate *date = [[NSDate alloc] init];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd/MM/yyyy"];
    NSString *noteFinishDate = [dateFormatter stringFromDate:date];
    NSData *imageData = UIImagePNGRepresentation(_noteImageView.image);
    NSString *imageString = [imageData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    
    NoteBeen *noteBeen = [[NoteBeen alloc] initWithNoteStartTime:noteDate NoteFinishTime:noteFinishDate NoteContent:content NoteLocation:@"暂无" NotePhoto:imageString NoteTitle:noteTitle];
    NoteDao *noteDao = [[NoteDao alloc] init];
    if ([noteDao insertNote:noteBeen]) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [Util showToastWithView:self.view text:@"备忘失败！"];

    }
    
}

- (void)touchesEnded:(NSSet *)touches
           withEvent:(UIEvent *)event {
    if (![_noteTitleTextField isExclusiveTouch] || ![_contentTextView isExclusiveTouch]) {
        [_noteTitleTextField resignFirstResponder];
        [_contentTextView resignFirstResponder];
    }
}


#pragma mark - 设置图片可以点击并监听
- (void)setViewClickWithView:(UIView *)myUIView {
    
    //单指单击
    UITapGestureRecognizer *singleFingerOne = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                      action:@selector(handleSingleFingerEvent:)];
    singleFingerOne.numberOfTouchesRequired = 1; //手指数
    singleFingerOne.numberOfTapsRequired = 1; //tap次数
    //        singleFingerOne.delegate= self;
    [myUIView addGestureRecognizer:singleFingerOne];
}


#pragma mark - 处理单指事件
- (void)handleSingleFingerEvent:(UITapGestureRecognizer *)sender
{
    [_noteTitleTextField resignFirstResponder];
    [_contentTextView resignFirstResponder];

}


@end
