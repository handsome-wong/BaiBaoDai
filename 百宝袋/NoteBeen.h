//
//  NoteBeen.h
//  百宝袋
//
//  Created by admin on 15/11/21.
//  Copyright (c) 2015年 handsome. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NoteBeen : NSObject

@property (strong, nonatomic) NSString *noteId;
@property (strong, nonatomic) NSString *noteStartTime;
@property (strong, nonatomic) NSString *noteFinishTime;
@property (strong, nonatomic) NSString *noteLocation;
@property (strong, nonatomic) NSString *noteContent;
@property (strong, nonatomic) NSString *noteTitle;
@property (strong, nonatomic) NSString *notePhoto;

//初始化
- (instancetype)initWithNoteStartTime:(NSString *)noteStartTime
                NoteFinishTime:(NSString *)noteFinishTime
                  NoteContent:(NSString *)noteContent
               NoteLocation:(NSString *)noteLocation
                     NotePhoto:(NSString *)notePhoto
                     NoteTitle:(NSString *)noteTitle;



@end
