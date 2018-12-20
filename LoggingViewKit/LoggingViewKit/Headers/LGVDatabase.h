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

- (BOOL)addLog:(LGVLog *)log;
- (NSArray<LGVLog *> *)allLogs;
- (nullable LGVLog *)logByKey:(NSString *)key;
- (void)deleteAllLogs;

@end

NS_ASSUME_NONNULL_END
