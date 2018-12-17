//
//  LGVLog.m
//  LoggingViewKit
//
//  Created by Masaki Ando on 2018/12/18.
//  Copyright (c) 2018 Hituzi Ando. All rights reserved.
//

#import "LGVLog.h"

@interface LGVLog ()

@property (nonatomic, copy) NSString *key;
@property (nonatomic) NSDate *createdAt;

@end

@implementation LGVLog

+ (instancetype)log {
    LGVLog *log = [LGVLog new];
    log.key = [NSUUID UUID].UUIDString.uppercaseString;
    log.createdAt = [NSDate date];

    return log;
}

+ (instancetype)logWithKey:(NSString *)key createdAt:(NSDate *)createdAt {
    LGVLog *log = [LGVLog new];
    log.key = key;
    log.createdAt = createdAt;

    return log;
}

- (instancetype)init {
    self = [super init];

    if (self) {
        _info = [NSMutableDictionary new];
    }

    return self;
}

- (NSString *)description {
    return [self dictionaryWithValuesForKeys:@[
        @"ID",
        @"key",
        @"name",
        @"clickX",
        @"clickY",
        @"absoluteClickX",
        @"absoluteClickY",
        @"info",
        @"createdAt",
    ]].description;
}

@end
