//
//  NoteDao.m
//  百宝袋
//
//  Created by admin on 15/11/21.
//  Copyright (c) 2015年 handsome. All rights reserved.
//

#import "NoteDao.h"

@implementation NoteDao {
    DatabaseHelper *db;

}

- (id)init{
    if (self=[super init]) {
        db=[[DatabaseHelper alloc]init];
        
    }
    return self;
}

//添加
- (BOOL)insertNote:(NoteBeen *)note {
    NSString *sqlStament = [NSString stringWithFormat:@"INSERT INTO note ( noteTitle, noteStartTime, noteFinishTime, noteLocation, noteContent, notePhoto) VALUES(\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\")", note.noteTitle, note.noteStartTime, note.noteFinishTime, note.noteLocation, note.noteContent, note.notePhoto];
    return [db insertDataWithSqlStatement:sqlStament];
}
//删除
- (BOOL)deleteNote:(NoteBeen *)note {
    NSString *sqlStament = [NSString stringWithFormat:@"delete from note where noteId = \"%@\"",note.noteId];
    return [db deleteDataWithSqlStatement:sqlStament];
}
//更新
- (BOOL)updateNote:(NoteBeen *)note {
    if([self isExist:note.noteId]){
        NSString *sqlStament = [NSString stringWithFormat:@"update note set noteTitle= \"%@\",noteStartTime= \"%@\",noteFinishTime= \"%@\" ,noteLocation=\"%@\",noteContent= \"%@\" ,notePhoto= \"%@\"  where noteId = \"%@\"",note.noteId, note.noteTitle, note.noteStartTime, note.noteFinishTime, note.noteLocation, note.noteContent, note.notePhoto];
        return [db updateDataWithSqlStatement:sqlStament];
    }
    return NO;
    
}

//查找所有
- (NSArray *)findAllNote {
    NSArray *noteList=[[NSArray alloc]init];
    NSString *sqlStament = [NSString stringWithFormat:@"SELECT * FROM note"];
    noteList = [db findNoteWithSqlStatement:sqlStament];
    return noteList;
}
//查找笔记
- (NoteBeen *)searchNote:(NSString *)noteId {
    NSString *sqlStament = [NSString stringWithFormat:@"SELECT * FROM note where noteId = \"%@\"",noteId];
    NSArray *noteList=[db findNoteWithSqlStatement:sqlStament];
    if ([noteList count]>0) {
        NoteBeen *myNote=[noteList objectAtIndex:0];
        return myNote;
    }
    return nil;
}


//isExist
- (BOOL)isExist:(NSString *)noteId {
    if ([self searchNote:noteId]==nil) {
        return NO;
    }
    return YES;
}


@end
