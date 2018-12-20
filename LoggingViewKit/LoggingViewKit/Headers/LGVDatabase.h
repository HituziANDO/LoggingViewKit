//
//  LGVDatabase.h
//  LoggingViewKit
//
//  Created by Masaki Ando on 2018/12/19.
//  Copyright (c) 2018 Hituzi Ando. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class LGVLog;

@protocol LGVDatabase <NSObject>
/**
 * Adds given log to the database.
 *
 * @param log Saving log
 * @return YES if success, otherwise NO
 */
- (BOOL)addLog:(LGVLog *)log;
/**
 * Reads all logs in the database.
 */
- (NSArray<LGVLog *> *)allLogs;
/**
 * Finds the log for given key. If not found it, this method returns nil.
 */
- (nullable LGVLog *)logByKey:(NSString *)key;
/**
 * Deletes all logs in the database.
 */
- (void)deleteAllLogs;

@end

NS_ASSUME_NONNULL_END
