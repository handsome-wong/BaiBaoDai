//
//  ExpressTableViewCell.h
//  百宝袋
//
//  Created by admin on 15/11/13.
//  Copyright (c) 2015年 handsome. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ExpressTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *expressIcon;

@property (weak, nonatomic) IBOutlet UILabel *expressName;

+ (instancetype)expressTableViewCellWithTableView:(UITableView *)tableView;
@end
