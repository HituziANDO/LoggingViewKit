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

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class LGVLog;
@class LVKCounter;

@protocol LGVDatabase <NSObject>
@required
/**
 * Adds given log to the database.
 *
 * @param log Saving log.
 * @return YES if success, otherwise NO.
 */
- (BOOL) addLog:(LGVLog *)log;

@optional
/**
 * Reads all logs in the database.
 */
- (NSArray<LGVLog *> *) allLogs;
/**
 * Finds the log by given key. If not found it, this method returns nil.
 */
- (nullable LGVLog *) logByKey:(NSString *)key;
/**
 * Selects logs by given event type.
 */
- (NSArray<LGVLog *> *) logsByEventType:(NSString *)eventType;
/**
 * Deletes all logs in the database.
 */
- (void) deleteAllLogs;
/**
 * Deletes logs by given event type.
 */
- (void) deleteLogsByEventType:(NSString *)eventType;
/**
 * Reads all counters in the database.
 *
 * @return All counters.
 */
- (NSArray<LVKCounter *> *) allCounters;
/**
 * Reads the counter by given name. If not found it, this method returns nil.
 *
 * @param name The name of the counter.
 * @return A counter.
 */
- (nullable LVKCounter *) counterByName:(NSString *)name;
/**
 * Saves given counter to the database. If the counter is not added, this method adds it. Otherwise, this method updates it.
 *
 * @param counter Saving counter.
 * @return YES if success, otherwise NO.
 */
- (BOOL) saveCounter:(LVKCounter *)counter;
/**
 * Deletes the counter by given name.
 *
 * @param name The name of the counter.
 */
- (void) deleteCounterByName:(NSString *)name;
@end

NS_ASSUME_NONNULL_END
