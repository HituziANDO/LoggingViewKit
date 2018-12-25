//
//  LGVSQLiteDatabase.m
//  LoggingViewKit
//
//  Created by Masaki Ando on 2018/12/17.
//  Copyright (c) 2018 Hituzi Ando. All rights reserved.
//

#import "LGVFMDB.h"

#import "LGVSQLiteDatabase.h"

#import "LGVLog.h"

@interface LGVSQLiteDatabase ()

@property (nonatomic) LGVFMDatabase *db;

@end

@implementation LGVSQLiteDatabase

+ (instancetype)defaultDatabase {
    NSString *docDir = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    NSString *path = [docDir stringByAppendingPathComponent:@"logging_view_kit.db"];

    return [self databaseWithPath:path];
}

+ (instancetype)databaseWithPath:(NSString *)path {
    LGVSQLiteDatabase *database = [LGVSQLiteDatabase new];
    database.db = [LGVFMDatabase databaseWithPath:path];
    [database createTable];

    return database;
}

#pragma mark - LGVDatabase

- (BOOL)addLog:(LGVLog *)log {
    NSString *sql = @"INSERT INTO lgv_logs "
                    "(key, name, click_x, click_y, absolute_click_x, absolute_click_y, info, created_at) "
                    "VALUES (?, ?, ?, ?, ?, ?, ?, ?);";

    if (![self.db open]) {
        return NO;
    }

    [self.db beginTransaction];

    const BOOL success = [self.db executeUpdate:sql withArgumentsInArray:@[
        log.key,
        log.name ? log.name : @"",
        @(log.clickX),
        @(log.clickY),
        @(log.absoluteClickX),
        @(log.absoluteClickY),
        [self serialize:log.info],
        log.createdAt,
    ]];

    if (success) {
        [self.db commit];
    }
    else {
        [self.db rollback];
    }

    [self.db close];

    return success;
}

- (NSArray<LGVLog *> *)allLogs {
    NSMutableArray *logs = [NSMutableArray new];

    NSString *sql = @"SELECT * FROM lgv_logs ORDER BY id;";

    if (![self.db open]) {
        return @[];
    }

    LGVFMResultSet *results = [self.db executeQuery:sql];

    while ([results next]) {
        LGVLog *log = [LGVLog logWithKey:[results stringForColumn:@"key"]
                               createdAt:[results dateForColumn:@"created_at"]];
        log.ID = [results longLongIntForColumn:@"id"];
        log.name = [results stringForColumn:@"name"];
        log.clickX = [results doubleForColumn:@"click_x"];
        log.clickY = [results doubleForColumn:@"click_y"];
        log.absoluteClickX = [results doubleForColumn:@"absolute_click_x"];
        log.absoluteClickY = [results doubleForColumn:@"absolute_click_y"];
        log.info = [self deserialize:[results stringForColumn:@"info"]].mutableCopy;
        [logs addObject:log];
    }

    [self.db close];

    return logs;
}

- (LGVLog *)logByKey:(NSString *)key {
    if (key.length <= 0) {
        return nil;
    }

    NSString *sql = @"SELECT * FROM lgv_logs WHERE key=:key ORDER BY id;";

    if (![self.db open]) {
        return nil;
    }

    LGVFMResultSet *results = [self.db executeQuery:sql withParameterDictionary:@{ @"key": key }];

    LGVLog *log = nil;

    if ([results next]) {
        log = [LGVLog logWithKey:[results stringForColumn:@"key"]
                       createdAt:[results dateForColumn:@"created_at"]];
        log.ID = [results longLongIntForColumn:@"id"];
        log.name = [results stringForColumn:@"name"];
        log.clickX = [results doubleForColumn:@"click_x"];
        log.clickY = [results doubleForColumn:@"click_y"];
        log.absoluteClickX = [results doubleForColumn:@"absolute_click_x"];
        log.absoluteClickY = [results doubleForColumn:@"absolute_click_y"];
        log.info = [self deserialize:[results stringForColumn:@"info"]].mutableCopy;
    }

    [self.db close];

    return log;
}

- (void)deleteAllLogs {
    NSString *sql = @"DELETE FROM lgv_logs;";

    if (![self.db open]) {
        return;
    }

    [self.db beginTransaction];

    if ([self.db executeUpdate:sql]) {
        [self.db commit];
        [self.db executeUpdate:@"VACUUM"];
    }
    else {
        [self.db rollback];
    }

    [self.db close];
}

#pragma mark - private method

- (void)createTable {
    NSString *sql = @"CREATE TABLE IF NOT EXISTS lgv_logs ("
                    "id INTEGER PRIMARY KEY AUTOINCREMENT, "
                    "key TEXT NOT NULL, "
                    "name TEXT, "
                    "click_x REAL, "
                    "click_y REAL, "
                    "absolute_click_x REAL, "
                    "absolute_click_y REAL, "
                    "info TEXT, "
                    "created_at DATETIME NOT NULL"
                    ");";

    if (![self.db open]) {
        return;
    }

    [self.db executeUpdate:sql];
    [self.db close];
}

- (NSString *)serialize:(NSDictionary *)dict {
    NSString *str = @"";

    if ([NSJSONSerialization isValidJSONObject:dict]) {
        NSError *error = nil;
        NSData *data = [NSJSONSerialization dataWithJSONObject:dict options:0 error:&error];

        if (!error) {
            str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        }
    }

    return str;
}

- (NSDictionary *)deserialize:(NSString *)string {
    NSError *error = nil;
    NSDictionary *logInfo = [NSJSONSerialization JSONObjectWithData:[string dataUsingEncoding:NSUTF8StringEncoding]
                                                            options:NSJSONReadingAllowFragments
                                                              error:&error];

    if (!error) {
        return logInfo;
    }

    return @{};
}

@end
