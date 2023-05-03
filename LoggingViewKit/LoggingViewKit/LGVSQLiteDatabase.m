//
//  LoggingViewKit
//
//  MIT License
//
//  Copyright (c) 2018-present Hituzi Ando. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//

#import "LGVFMDB.h"

#import "LGVSQLiteDatabase.h"

#import "LGVLog.h"

@interface LGVSQLiteDatabase ()

@property (nonatomic) LGVFMDatabase *db;

@end

@implementation LGVSQLiteDatabase

+ (instancetype) defaultDatabase {
    NSString *docDir = NSSearchPathForDirectoriesInDomains(
        NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    NSString *path = [docDir stringByAppendingPathComponent:@"logging_view_kit.db"];

    return [self databaseWithPath:path];
}

+ (instancetype) databaseWithPath:(NSString *)path {
    LGVSQLiteDatabase *database = [LGVSQLiteDatabase new];

    database.db = [LGVFMDatabase databaseWithPath:path];
    [database createTable];

    return database;
}

#pragma mark - LGVDatabase

- (BOOL) addLog:(LGVLog *)log {
    NSString *sql = @"INSERT INTO lgv_logs "
        "(key, "
        "event_type, "
        "name, "
        "click_x, "
        "click_y, "
        "absolute_click_x, "
        "absolute_click_y, "
        "info, "
        "created_at) "
        "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?);";

    if (![self.db open]) {
        return NO;
    }

    [self.db beginTransaction];

    const BOOL success = [self.db executeUpdate:sql withArgumentsInArray:@[
                              log.key,
                              log.eventType,
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

- (NSArray<LGVLog *> *) allLogs {
    NSString *sql = @"SELECT * FROM lgv_logs ORDER BY id;";

    if (![self.db open]) {
        return @[];
    }

    LGVFMResultSet *results = [self.db executeQuery:sql];
    NSArray *logs = [self parseResult:results];

    [self.db close];

    return logs;
}

- (LGVLog *) logByKey:(NSString *)key {
    if (key.length <= 0) {
        return nil;
    }

    NSString *sql = @"SELECT * FROM lgv_logs WHERE key=:key ORDER BY id;";

    if (![self.db open]) {
        return nil;
    }

    LGVFMResultSet *results = [self.db executeQuery:sql withParameterDictionary:@{ @"key": key }];
    NSArray *logs = [self parseResult:results];

    [self.db close];

    return logs.firstObject;
}

- (NSArray<LGVLog *> *) logsByEventType:(NSString *)eventType {
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM lgv_logs WHERE event_type = '%@' ORDER BY id;", eventType];

    if (![self.db open]) {
        return @[];
    }

    LGVFMResultSet *results = [self.db executeQuery:sql];
    NSArray *logs = [self parseResult:results];

    [self.db close];

    return logs;
}

- (void) deleteAllLogs {
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

- (void) deleteLogsByEventType:(NSString *)eventType {
    NSString *sql = [NSString stringWithFormat:@"DELETE FROM lgv_logs WHERE event_type = '%@';", eventType];

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

- (void) createTable {
    NSString *sql = @"CREATE TABLE IF NOT EXISTS lgv_logs ("
        "id INTEGER PRIMARY KEY AUTOINCREMENT, "
        "key TEXT NOT NULL, "
        "event_type TEXT NOT NULL, "
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

- (NSArray<LGVLog *> *) parseResult:(LGVFMResultSet *)results {
    NSMutableArray *logs = [NSMutableArray new];

    while ([results next]) {
        LGVLog *log = [LGVLog logWithKey:[results stringForColumn:@"key"]
                               createdAt:[results dateForColumn:@"created_at"]];
        log.ID = [results longLongIntForColumn:@"id"];
        log.eventType = [results stringForColumn:@"event_type"];
        log.name = [results stringForColumn:@"name"];
        log.clickX = [results doubleForColumn:@"click_x"];
        log.clickY = [results doubleForColumn:@"click_y"];
        log.absoluteClickX = [results doubleForColumn:@"absolute_click_x"];
        log.absoluteClickY = [results doubleForColumn:@"absolute_click_y"];
        log.info = [self deserialize:[results stringForColumn:@"info"]].mutableCopy;
        [logs addObject:log];
    }

    return logs;
}

- (NSString *) serialize:(NSDictionary *)dict {
    if ([NSJSONSerialization isValidJSONObject:dict]) {
        NSError *error = nil;
        NSData *data = [NSJSONSerialization dataWithJSONObject:dict options:0 error:&error];

        if (!error) {
            return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        }
    }

    return @"";
}

- (NSDictionary *) deserialize:(NSString *)string {
    NSError *error = nil;
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:[string dataUsingEncoding:NSUTF8StringEncoding]
                                                         options:NSJSONReadingAllowFragments
                                                           error:&error];

    if (!error) {
        return dict;
    }

    return @{};
}

@end
