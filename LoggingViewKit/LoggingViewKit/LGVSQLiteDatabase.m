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

#import <LoggingViewKit/LoggingViewKit-Swift.h>

#import "LVKFMDB.h"

#import "LGVSQLiteDatabase.h"

#import "LGVLog.h"

@interface LGVSQLiteDatabase ()

@property (nonatomic) LVKFMDatabase *db;

@end

@implementation LGVSQLiteDatabase

static NSString *const DefaultDatabaseName = @"logging_view_kit.db";
static NSString *const TestDatabaseName = @"logging_view_kit_test.db";

+ (instancetype) defaultDatabase {
    NSString *docDir = NSSearchPathForDirectoriesInDomains(
        NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    NSString *path = [docDir stringByAppendingPathComponent:DefaultDatabaseName];

    return [self databaseWithPath:path];
}

+ (instancetype) databaseWithPath:(NSString *)path {
    LGVSQLiteDatabase *database = [LGVSQLiteDatabase new];

    database.db = [LVKFMDatabase databaseWithPath:path];
    [database createTable];

    return database;
}

+ (instancetype) testDatabase {
    NSString *docDir = NSSearchPathForDirectoriesInDomains(
        NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    NSString *path = [docDir stringByAppendingPathComponent:TestDatabaseName];

    return [self databaseWithPath:path];
}

+ (void) deleteTestDatabase {
    NSString *docDir = NSSearchPathForDirectoriesInDomains(
        NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    NSString *path = [docDir stringByAppendingPathComponent:TestDatabaseName];

    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        [[NSFileManager defaultManager] removeItemAtPath:path error:NULL];
    }
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

    LVKFMResultSet *results = [self.db executeQuery:sql];
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

    LVKFMResultSet *results = [self.db executeQuery:sql withParameterDictionary:@{ @"key": key }];
    NSArray *logs = [self parseResult:results];

    [self.db close];

    return logs.firstObject;
}

- (NSArray<LGVLog *> *) logsByEventType:(NSString *)eventType {
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM lgv_logs WHERE event_type = '%@' ORDER BY id;", eventType];

    if (![self.db open]) {
        return @[];
    }

    LVKFMResultSet *results = [self.db executeQuery:sql];
    NSArray *logs = [self parseResult:results];

    [self.db close];

    return logs;
}

- (void) deleteAllLogs {
    [self deleteWithSQL:@"DELETE FROM lgv_logs;"];
}

- (void) deleteLogsByEventType:(NSString *)eventType {
    NSString *sql = [NSString stringWithFormat:@"DELETE FROM lgv_logs WHERE event_type = '%@';", eventType];

    [self deleteWithSQL:sql];
}

- (NSArray<LVKCounter *> *) allCounters {
    NSString *sql = @"SELECT * FROM counters ORDER BY name;";

    if (![self.db open]) {
        return @[];
    }

    LVKFMResultSet *results = [self.db executeQuery:sql];
    NSMutableArray<LVKCounter *> *counters = [NSMutableArray new];

    while ([results next]) {
        LVKCounter *counter = [[LVKCounter alloc] initWithName:[results stringForColumn:@"name"]
                                                         count:[[results stringForColumn:@"count"] longLongValue]
                                                     createdAt:[results dateForColumn:@"created_at"]
                                                     updatedAt:[results dateForColumn:@"updated_at"]
                                                      database:self];
        [counters addObject:counter];
    }

    [self.db close];

    return counters;
}

- (LVKCounter *) counterByName:(NSString *)name {
    NSString *sql = @"SELECT * FROM counters WHERE name=:name;";

    if (![self.db open]) {
        return nil;
    }

    LVKFMResultSet *results = [self.db executeQuery:sql withParameterDictionary:@{ @"name": name }];
    LVKCounter *counter;

    while ([results next]) {
        counter = [[LVKCounter alloc] initWithName:[results stringForColumn:@"name"]
                                             count:[[results stringForColumn:@"count"] longLongValue]
                                         createdAt:[results dateForColumn:@"created_at"]
                                         updatedAt:[results dateForColumn:@"updated_at"]
                                          database:self];
        break;
    }

    [self.db close];

    return counter;
}

- (BOOL) saveCounter:(LVKCounter *)counter {
    LVKCounter *savedCounter = [self counterByName:counter.name];

    if (![self.db open]) {
        return NO;
    }

    [self.db beginTransaction];

    BOOL success;
    if (savedCounter) {
        // Update
        success = [self.db executeUpdate:@"UPDATE counters SET "
                   "count = ?, "
                   "created_at = ?, "
                   "updated_at = ? "
                   "WHERE name = ?;" withArgumentsInArray:@[
                       [NSString stringWithFormat:@"%lld", counter.count],
                       counter.createdAt,
                       counter.lastUpdatedAt,
                       counter.name
        ]];
    }
    else {
        // Insert
        success = [self.db executeUpdate:@"INSERT INTO counters "
                   "(name, "
                   "count, "
                   "created_at, "
                   "updated_at) "
                   "VALUES (?, ?, ?, ?);" withArgumentsInArray:@[
                       counter.name,
                       [NSString stringWithFormat:@"%lld", counter.count],
                       counter.createdAt,
                       counter.lastUpdatedAt
        ]];
    }


    if (success) {
        [self.db commit];
    }
    else {
        [self.db rollback];
    }

    [self.db close];

    return success;
}

- (void) deleteCounterByName:(NSString *)name {
    NSString *sql = [NSString stringWithFormat:@"DELETE FROM counters WHERE name = '%@';", name];

    [self deleteWithSQL:sql];
}

#pragma mark - private method

- (void) createTable {
    if (![self.db open]) {
        return;
    }

    [self.db executeUpdate:@"CREATE TABLE IF NOT EXISTS lgv_logs ("
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
     ");"];

    [self.db executeUpdate:@"CREATE TABLE IF NOT EXISTS counters ("
     "name TEXT PRIMARY KEY, "
     "count TEXT NOT NULL, "
     "created_at DATETIME NOT NULL, "
     "updated_at DATETIME NOT NULL"
     ");"];

    [self.db close];
}

- (void) deleteWithSQL:(NSString *)sql {
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

- (NSArray<LGVLog *> *) parseResult:(LVKFMResultSet *)results {
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
