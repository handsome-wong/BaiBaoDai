//
//  ExpressTableViewCell.m
//  百宝袋
//
//  Created by admin on 15/11/13.
//  Copyright (c) 2015年 handsome. All rights reserved.
//

#import "ExpressTableViewCell.h"

@implementation ExpressTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

+ (instancetype)expressTableViewCellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"Cell";
    ExpressTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ExpressTableViewCell" owner:nil options:nil] firstObject];
    }     return cell;
}

//把tableView的sepratorStyle 设置为none 再重写该分割线
- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [UIColor clearColor].CGColor);
    CGContextFillRect(context, rect);
    
    //上分割线，
    CGContextSetStrokeColorWithColor(context, [UIColor blackColor].CGColor);
    CGContextStrokeRect(context, CGRectMake(5, -1, rect.size.width - 10, 0.5));
    
    //下分割线
    CGContextSetStrokeColorWithColor(context, [UIColor blackColor].CGColor);
    CGContextStrokeRect(context, CGRectMake(5, rect.size.height, rect.size.width - 10, 0.5));
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
//    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
