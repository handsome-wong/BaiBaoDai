//
//  Util.m
//  百宝袋
//
//  Created by admin on 15/11/13.
//  Copyright (c) 2015年 handsome. All rights reserved.
//

#import "Util.h"

@implementation Util

#pragma mark - 第一个参数为限定size 第二个为需要计算的label 第三个为label的内容 返回算出的size
+ (CGSize)boundingRectWithSize:(CGSize)size
                         label:(UILabel *)label {
    NSDictionary *attribute = @{NSFontAttributeName: label.font};
    
    CGSize retSize = [label.text boundingRectWithSize:size
                                        options:\
                      NSStringDrawingTruncatesLastVisibleLine |
                      NSStringDrawingUsesLineFragmentOrigin |
                      NSStringDrawingUsesFontLeading
                                     attributes:attribute
                                        context:nil].size;
    
    return retSize;
}

#pragma mark - 根据内容计算高度
+ (void)setTitleWithText:(NSString *)text
                    cell:(UITableViewCell *)cell {
    //获得当前cell高度
    CGRect frame = [cell frame];
    //文本赋值
    cell.textLabel.text = text;
    //设置label的最大行数
    cell.textLabel.numberOfLines = 10;
    
    CGSize size = CGSizeMake(320,2000); //设置一个行高上限
    CGSize labelSize = [self boundingRectWithSize:size label:cell.textLabel];
    frame.size.height = labelSize.height+100;
    //计算出自适应的高度
    frame.size.height = labelSize.height+65;
    
    cell.frame = frame;
    
}

//toast
+ (void)showToastWithView:(UIView *)view
                     text:(NSString *)text {
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:view];
    [view addSubview:HUD];
    HUD.labelText = text;
    HUD.mode = MBProgressHUDModeText;
    
    //指定距离中心点的X轴和Y轴的偏移量，如果不指定则在屏幕中间显示
    //        HUD.yOffset = 80.0f;
    //        HUD.xOffset = 100.0f;
    
    [HUD showAnimated:YES whileExecutingBlock:^{
        sleep(1);
    } completionBlock:^{
        [HUD removeFromSuperview];
    }];
}

//进度条
+ (id)showProgressWithView:(UIView *)view
                      text:(NSString *)text {
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:view];
    [view addSubview:HUD];
    HUD.progress = 0.5;
    HUD.mode = MBProgressHUDModeIndeterminate;
    
    [HUD showAnimated:YES whileExecutingBlock:^{
        sleep(5);
    } completionBlock:^{
        [HUD removeFromSuperview];
    }];
    return HUD;
}


@end
