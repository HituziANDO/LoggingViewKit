//
//  LGVSQLiteDatabase.h
//  LoggingViewKit
//
//  Created by Masaki Ando on 2018/12/17.
//  Copyright (c) 2018 Hituzi Ando. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "LGVDatabase.h"

NS_ASSUME_NONNULL_BEGIN

@interface LGVSQLiteDatabase : NSObject <LGVDatabase>
/**
 * Creates an instance that has default database file path.
 *
 * @return New instance
 */
+ (instancetype)defaultDatabase;
/**
 * Creates a new instance.
 *
 * @param path Database file path
 * @return New instance
 */
+ (instancetype)databaseWithPath:(NSString *)path;

- (void)dropTable;

@end

NS_ASSUME_NONNULL_END
