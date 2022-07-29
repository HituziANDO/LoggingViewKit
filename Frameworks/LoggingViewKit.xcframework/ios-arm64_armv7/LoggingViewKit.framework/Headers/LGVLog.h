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

FOUNDATION_EXTERN const double LGVUndefinedLocation;

@interface LGVLog : NSObject

@property (nonatomic) long long int ID;
/**
 * The key.
 */
@property (nonatomic, copy, readonly) NSString *key;
/**
 * The type of an event.
 */
@property (nonatomic, copy) NSString *eventType;
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
/**
 * Converts the receiver to `NSDictionary`.
 */
@property (nonatomic, copy, readonly) NSDictionary *toDictionary;

+ (instancetype)logWithEventType:(NSString *)eventType;
+ (instancetype)logWithKey:(NSString *)key createdAt:(NSDate *)createdAt;

@end

NS_ASSUME_NONNULL_END
