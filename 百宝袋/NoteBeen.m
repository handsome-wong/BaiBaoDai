//
//  NoteBeen.m
//  百宝袋
//
//  Created by admin on 15/11/21.
//  Copyright (c) 2015年 handsome. All rights reserved.
//

#import "NoteBeen.h"

@implementation NoteBeen

- (instancetype)initWithNoteStartTime:(NSString *)noteStartTime
                       NoteFinishTime:(NSString *)noteFinishTime
                          NoteContent:(NSString *)noteContent
                         NoteLocation:(NSString *)noteLocation
                            NotePhoto:(NSString *)notePhoto
                            NoteTitle:(NSString *)noteTitle {
    if (self = [super init]) {
        [self setNoteFinishTime:noteFinishTime];
//        [self setNoteId:noteId];
        [self setNoteLocation:noteLocation];
        [self setNoteContent:noteContent];
        [self setNotePhoto:notePhoto];
        [self setNoteStartTime:noteStartTime];
        [self setNoteTitle:noteTitle];
    }
    return self;
}

@end
