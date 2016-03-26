//
//  DatabaseHelper.m
//  百宝袋
//
//  Created by admin on 15/11/21.
//  Copyright (c) 2015年 handsome. All rights reserved.
//

#import "DatabaseHelper.h"
#import "NoteBeen.h"

#define BBD @"BaiBaoDai.sqlite"

@implementation DatabaseHelper {
    sqlite3 *dataBase;
}

//初始化，检查并复制本地sqlite到APP
- (id)init {
    if (self = [super init]) {
        _dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        _docsDir = [_dirPaths objectAtIndex:0];
        _databasePath = [[NSString alloc] initWithString:[_docsDir stringByAppendingPathComponent:BBD]];
        NSLog(@"path=%@",_databasePath);
        //复制数据库
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSString *writableDBPath = [_docsDir stringByAppendingPathComponent:BBD];
        //判断数据库是否存在
        BOOL isSuccess = [fileManager fileExistsAtPath:writableDBPath];
        if (!isSuccess) {
            NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:BBD];
            NSError *error = nil;
            BOOL isSuccess_1 = [fileManager copyItemAtPath:defaultDBPath toPath:writableDBPath error:&error];
            if (!isSuccess_1) {
                NSLog(@"sqlite was created false,error:%@ ",error);
            } else {
                NSLog(@"sqlite was created success");
            }
        } else {
        NSLog(@"sqlite was created success");
        }
        
    }
    return self;
}

//insert
- (BOOL)insertDataWithSqlStatement:(NSString *)sqlStatement {
    sqlite3_stmt *statement;
    if ([self openDB]) {
        const char *insertStatement = [sqlStatement UTF8String];
        sqlite3_prepare_v2(dataBase, insertStatement, -1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE) {
            sqlite3_step(statement);
            sqlite3_close(dataBase);
            return YES;
        } else {
            NSLog(@"save failed,Error:%s",sqlite3_errmsg(dataBase));
            sqlite3_finalize(statement);
            }
    }
    
    sqlite3_close(dataBase);
    return NO;
}


//update
- (BOOL)updateDataWithSqlStatement:(NSString *)sqlStatement {
    sqlite3_stmt *statement;
    if ([self openDB]) {
        const char *insertStatement = [sqlStatement UTF8String];
        if (sqlite3_prepare_v2(dataBase, insertStatement, -1, &statement, NULL) == SQLITE_OK) {
            int result = sqlite3_step(statement);
            if (result == SQLITE_DONE) {
                sqlite3_finalize(statement);
                [self closeDB];
                return YES;
            }
        }
    }
    NSLog(@"update failed!Error:%s",sqlite3_errmsg(dataBase));
    [self closeDB];
    return NO;

}

//delete
- (BOOL)deleteDataWithSqlStatement:(NSString *)sqlStatement {
    sqlite3_stmt *statement;
    if ([self openDB]) {
        const char *insertStatement = [sqlStatement UTF8String];
        if (sqlite3_prepare_v2(dataBase, insertStatement, -1, &statement, NULL) ==  SQLITE_OK) {
            if (sqlite3_step(statement) == SQLITE_DONE) {
                sqlite3_finalize(statement);
                [self class];
                return YES;
            }
        }
    }
    
    NSLog(@"delete failed");
    NSLog(@"Error:%s",sqlite3_errmsg(dataBase));
    sqlite3_finalize(statement);
    [self closeDB];
    return  NO;
}

//findNote
-(NSArray*)findNoteWithSqlStatement:(NSString*)sqlStatement {
    NSMutableArray *noteList=[[NSMutableArray alloc]init];
    sqlite3_stmt *statement;
    if ([self openDB]) {
        const char *querystatement = [sqlStatement UTF8String];
        if (sqlite3_prepare_v2(dataBase, querystatement, -1, &statement, NULL)==SQLITE_OK) {
            while (sqlite3_step(statement)==SQLITE_ROW) {
//                NSString *noteId= [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)];
                NSString *noteTitle= [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 1)];
                NSString *noteStartTime= [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 2)];
                NSString *noteFinishTime= [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 3)];
                NSString *noteLocation = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 4)];
                NSString *noteContent= [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 5)];
                NSString *notePhoto= [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 6)];
                NoteBeen *noteBeen = [[NoteBeen alloc] initWithNoteStartTime:noteStartTime NoteFinishTime:noteFinishTime NoteContent:noteContent NoteLocation:noteLocation NotePhoto:notePhoto NoteTitle:noteTitle];
                [noteList addObject:noteBeen];
            }
            sqlite3_finalize(statement);
        }else {
            NSLog(@"findNote false!Error:%s",sqlite3_errmsg(dataBase));
        }
        
    }
    [self closeDB];
    return noteList;
}



- (BOOL)openDB {
    const char *dbpath = [_databasePath UTF8String];
    if(sqlite3_open(dbpath, &dataBase)==SQLITE_OK){
        return YES;
    }else{
        return NO;
    }
    
}

-(void)closeDB{
    sqlite3_close(dataBase);
    dataBase=nil;
}


@end
