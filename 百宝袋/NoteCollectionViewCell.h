//
//  NoteCollectionViewCell.h
//  百宝袋
//
//  Created by admin on 15/11/22.
//  Copyright (c) 2015年 handsome. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NoteCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *NoteStartTime;

@property (weak, nonatomic) IBOutlet UILabel *noteTitle;

@property (weak, nonatomic) IBOutlet UILabel *noteContent;

@property (weak, nonatomic) IBOutlet UIImageView *noteImageView;

+ (instancetype)noteCellWithCollectonView:(UICollectionView *)collectionView AndIndexPath:(NSIndexPath *)indexPath;

@end
