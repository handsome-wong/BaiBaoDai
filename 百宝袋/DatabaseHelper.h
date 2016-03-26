//
//  DatabaseHelper.h
//  百宝袋
//
//  Created by admin on 15/11/21.
//  Copyright (c) 2015年 handsome. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "sqlite3.h"

@interface DatabaseHelper : NSObject

@property NSString *databasePath;
@property NSString *docsDir;
@property NSArray *dirPaths;
@property NSError *error;

//insert
- (BOOL)insertDataWithSqlStatement:(NSString *)sqlStatement;

//update
- (BOOL)updateDataWithSqlStatement:(NSString *)sqlStatement;

//delete
- (BOOL)deleteDataWithSqlStatement:(NSString *)sqlStatemen;

//findNote
-(NSArray*)findNoteWithSqlStatement:(NSString*)sqlStatement;
@end
