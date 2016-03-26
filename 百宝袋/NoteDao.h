//
//  NoteDao.h
//  百宝袋
//
//  Created by admin on 15/11/21.
//  Copyright (c) 2015年 handsome. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DatabaseHelper.h"
#import "NoteBeen.h"

@interface NoteDao : NSObject

//添加
- (BOOL)insertNote:(NoteBeen *)note;

//删除
- (BOOL)deleteNote:(NoteBeen *)note;

//更新
- (BOOL)updateNote:(NoteBeen *)note;

//查找所有
- (NSArray *)findAllNote;

//查找笔记
- (NoteBeen *)searchNote:(NSString *)noteId;

//isExist
- (BOOL)isExist:(NSString *)noteId;

@end
