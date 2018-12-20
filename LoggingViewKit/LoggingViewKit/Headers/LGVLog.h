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
/**
 * The key.
 */
@property (nonatomic, copy, readonly) NSString *key;
/**
 * The name of the view.
 */
@property (nonatomic, copy, nullable) NSString *name;
/**
 * The location x of clicked view in the parent view coordinate.
 */
@property (nonatomic) double clickX;
/**
 * The location y of clicked view in the parent view coordinate.
 */
@property (nonatomic) double clickY;
/**
 * The location x of clicked view in the root view coordinate.
 */
@property (nonatomic) double absoluteClickX;
/**
 * The location y of clicked view in the root view coordinate.
 */
@property (nonatomic) double absoluteClickY;
/**
 * The appendix information.
 */
@property (nonatomic, copy) NSMutableDictionary *info;
/**
 * The created date.
 */
@property (nonatomic, readonly) NSDate *createdAt;

+ (instancetype)log;
+ (instancetype)logWithKey:(NSString *)key createdAt:(NSDate *)createdAt;

@end

NS_ASSUME_NONNULL_END
