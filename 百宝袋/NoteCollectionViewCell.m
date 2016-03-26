//
//  NoteCollectionViewCell.m
//  百宝袋
//
//  Created by admin on 15/11/22.
//  Copyright (c) 2015年 handsome. All rights reserved.
//

#import "NoteCollectionViewCell.h"

@implementation NoteCollectionViewCell

- (void)awakeFromNib {
    // Initialization code
}

+ (instancetype)noteCellWithCollectonView:(UICollectionView *)collectionView AndIndexPath:(NSIndexPath *)indexPath {
    static NSString *ID = @"cell";
    NoteCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
//    if (cell == nil) {
//        cell = [[[NSBundle mainBundle] loadNibNamed:@"NoteCollectionViewCell" owner:nil options:nil] firstObject];
//    }
    return cell;
}

@end
