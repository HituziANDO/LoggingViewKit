//
//  LGVLog.h
//  LoggingViewKit
//
//  Created by Masaki Ando on 2018/12/18.
//  Copyright (c) 2018 Hituzi Ando. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LGVLog : NSObject

@property (nonatomic) long long int ID;
@property (nonatomic, copy, readonly) NSString *key;
@property (nonatomic, copy, nullable) NSString *name;
@property (nonatomic) double clickX;
@property (nonatomic) double clickY;
@property (nonatomic) double absoluteClickX;
@property (nonatomic) double absoluteClickY;
/**
 * The appendix information
 */
@property (nonatomic, copy) NSMutableDictionary *info;
@property (nonatomic, readonly) NSDate *createdAt;

+ (instancetype)log;
+ (instancetype)logWithKey:(NSString *)key createdAt:(NSDate *)createdAt;

@end

NS_ASSUME_NONNULL_END
