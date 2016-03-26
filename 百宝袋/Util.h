//
//  Util.h
//  百宝袋
//
//  Created by admin on 15/11/13.
//  Copyright (c) 2015年 handsome. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIKit/UIkit.h"
#import "MBProgressHUD.h"
@interface Util : NSObject

#pragma mark - 第一个参数为限定size 第二个为需要计算的label 第三个为label的内容 返回算出的size
+ (CGSize)boundingRectWithSize:(CGSize)size
                         label:(UILabel *)label;

#pragma mark - 根据内容计算高度
+ (void)setTitleWithText:(NSString *)text
                    cell:(UITableViewCell *)cell;

//toast
+ (void)showToastWithView:(UIView *)view
                     text:(NSString *)text;
//进度条
+ (id)showProgressWithView:(UIView *)view
                      text:(NSString *)text;
@end
