//
//  LoggingViewKit
//
//  MIT License
//
//  Copyright (c) 2019-present Hituzi Ando. All rights reserved.
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
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, LGVLogLevel) {
    /**
     * No logs.
     */
        LGVLogLevelOff = -1,
    /**
     * Outputs debug, info, warning and error logs.
     */
        LGVLogLevelDebug,
    /**
     * Outputs info, warning and error logs.
     */
        LGVLogLevelInfo,
    /**
     * Outputs warning and error logs.
     */
        LGVLogLevelWarning,
    /**
     * Outputs error logs.
     */
        LGVLogLevelError,
};

@protocol LGVDestination <NSObject>
/**
 * Writes a log to a destination.
 *
 * @param string A log.
 */
- (void)write:(NSString *)log;

@end

@interface LGVXcodeConsoleDestination : NSObject <LGVDestination>
/**
 * Creates new instance that it outputs a log to Xcode console.
 *
 * @return A destination.
 */
+ (instancetype)destination;

@end

@interface LGVFileDestination : NSObject <LGVDestination>
/**
 * Returns a file path.
 */
@property (nonatomic, copy, readonly) NSString *filePath;

/**
 * Creates new instance that it outputs a log to given file.
 *
 * @param fileName A file name. The file is put in given directory.
 * @param directory A directory path. If the directory doesn't exist, it is created by the receiver.
 * @return A destination.
 */
+ (instancetype)destinationWithFile:(NSString *)fileName inDirectory:(NSString *)directory;
/**
 * Creates new instance that it outputs a log to given file.
 *
 * @param filePath A file path.
 * @return A destination.
 */
+ (instancetype)destinationWithFilePath:(NSString *)filePath;

@end

@protocol LGVSerializer <NSObject>
/**
 * Serializes a log data as `NSString`.
 *
 * @param dictionary A log data.
 * @return Serialized log as `NSString`.
 */
- (NSString *)serialize:(NSDictionary *)dictionary;

@end

@interface LGVJSONSerializer : NSObject <LGVSerializer>

@end

@interface LGVRealTimeLogger : NSObject
/**
 * Log level.  Default level is "Off".
 */
@property (nonatomic) LGVLogLevel logLevel;
/**
 * A serializer. Default is JSON serializer.
 */
@property (nonatomic) id <LGVSerializer> serializer;
/**
 * Returns added destinations.
 */
@property (nonatomic, copy, readonly) NSArray<id <LGVDestination>> *destinations;

/**
 * Returns the singleton instance.
 *
 * @return The singleton instance.
 */
+ (instancetype)sharedLogger;

/**
 * Adds a destination outputting logs to the logger.
 *
 * @param destination A destination outputting logs.
 * @return The receiver.
 */
- (instancetype)addDestination:(id <LGVDestination>)destination;
/**
 * Adds a log.
 *
 * @param logLevel The log level.
 * @param function Set `__FUNCTION__`.
 * @param line Set `__LINE__`.
 * @param format Å message using a format.
 */
- (void)logWithLevel:(LGVLogLevel)logLevel
            function:(const char *)function
                line:(NSUInteger)line
              format:(nullable NSString *)format, ...;
/**
 * Adds a log.
 *
 * @param logLevel The log level.
 * @param function Set `__FUNCTION__`.
 * @param line Set `__LINE__`.
 * @param point A point.
 * @param comment A comment.
 */
- (void)logWithLevel:(LGVLogLevel)logLevel
            function:(const char *)function
                line:(NSUInteger)line
               point:(CGPoint)point
             comment:(nullable NSString *)comment;
/**
 * Adds a log.
 *
 * @param logLevel The log level.
 * @param function Set `__FUNCTION__`.
 * @param line Set `__LINE__`.
 * @param size A size.
 * @param comment A comment.
 */
- (void)logWithLevel:(LGVLogLevel)logLevel
            function:(const char *)function
                line:(NSUInteger)line
                size:(CGSize)size
             comment:(nullable NSString *)comment;
/**
 * Adds a log.
 *
 * @param logLevel The log level.
 * @param function Set `__FUNCTION__`.
 * @param line Set `__LINE__`.
 * @param rect A rect.
 * @param comment A comment.
 */
- (void)logWithLevel:(LGVLogLevel)logLevel
            function:(const char *)function
                line:(NSUInteger)line
                rect:(CGRect)rect
             comment:(nullable NSString *)comment;
/**
 * Adds a log.
 *
 * @param logLevel The log level.
 * @param function Set `__FUNCTION__`.
 * @param line Set `__LINE__`.
 * @param dictionary A dictionary.
 */
- (void)logWithLevel:(LGVLogLevel)logLevel
            function:(const char *)function
                line:(NSUInteger)line
          dictionary:(nullable NSDictionary *)dictionary;

@end

/**
 * Get a string of log level as `NSString` from `LGVLogLevel` value.
 *
 * @param logLevel A log level.
 * @return A string of log level.
 */
FOUNDATION_EXTERN NSString *LGVStringFromLGVLogLevel(LGVLogLevel logLevel);

#define LGVLogD(...) [[LGVRealTimeLogger sharedLogger] \
    logWithLevel:LGVLogLevelDebug function:__FUNCTION__ line:__LINE__ format:__VA_ARGS__]
#define LGVLogI(...) [[LGVRealTimeLogger sharedLogger] \
    logWithLevel:LGVLogLevelInfo function:__FUNCTION__ line:__LINE__ format:__VA_ARGS__]
#define LGVLogW(...) [[LGVRealTimeLogger sharedLogger] \
    logWithLevel:LGVLogLevelWarning function:__FUNCTION__ line:__LINE__ format:__VA_ARGS__]
#define LGVLogE(...) [[LGVRealTimeLogger sharedLogger] \
    logWithLevel:LGVLogLevelError function:__FUNCTION__ line:__LINE__ format:__VA_ARGS__]

#define LGVLogPointD(_point, _comment) [[LGVRealTimeLogger sharedLogger] \
    logWithLevel:LGVLogLevelDebug function:__FUNCTION__ line:__LINE__ point:_point comment:_comment]
#define LGVLogPointI(_point, _comment) [[LGVRealTimeLogger sharedLogger] \
    logWithLevel:LGVLogLevelInfo function:__FUNCTION__ line:__LINE__ point:_point comment:_comment]
#define LGVLogPointW(_point, _comment) [[LGVRealTimeLogger sharedLogger] \
    logWithLevel:LGVLogLevelWarning function:__FUNCTION__ line:__LINE__ point:_point comment:_comment]
#define LGVLogPointE(_point, _comment) [[LGVRealTimeLogger sharedLogger] \
    logWithLevel:LGVLogLevelError function:__FUNCTION__ line:__LINE__ point:_point comment:_comment]

#define LGVLogSizeD(_size, _comment) [[LGVRealTimeLogger sharedLogger] \
    logWithLevel:LGVLogLevelDebug function:__FUNCTION__ line:__LINE__ size:_size comment:_comment]
#define LGVLogSizeI(_size, _comment) [[LGVRealTimeLogger sharedLogger] \
    logWithLevel:LGVLogLevelInfo function:__FUNCTION__ line:__LINE__ size:_size comment:_comment]
#define LGVLogSizeW(_size, _comment) [[LGVRealTimeLogger sharedLogger] \
    logWithLevel:LGVLogLevelWarning function:__FUNCTION__ line:__LINE__ size:_size comment:_comment]
#define LGVLogSizeE(_size, _comment) [[LGVRealTimeLogger sharedLogger] \
    logWithLevel:LGVLogLevelError function:__FUNCTION__ line:__LINE__ size:_size comment:_comment]

#define LGVLogRectD(_rect, _comment) [[LGVRealTimeLogger sharedLogger] \
    logWithLevel:LGVLogLevelDebug function:__FUNCTION__ line:__LINE__ rect:_rect comment:_comment]
#define LGVLogRectI(_rect, _comment) [[LGVRealTimeLogger sharedLogger] \
    logWithLevel:LGVLogLevelInfo function:__FUNCTION__ line:__LINE__ rect:_rect comment:_comment]
#define LGVLogRectW(_rect, _comment) [[LGVRealTimeLogger sharedLogger] \
    logWithLevel:LGVLogLevelWarning function:__FUNCTION__ line:__LINE__ rect:_rect comment:_comment]
#define LGVLogRectE(_rect, _comment) [[LGVRealTimeLogger sharedLogger] \
    logWithLevel:LGVLogLevelError function:__FUNCTION__ line:__LINE__ rect:_rect comment:_comment]

#define LGVLogDictionaryD(dict) [[LGVRealTimeLogger sharedLogger] \
    logWithLevel:LGVLogLevelDebug function:__FUNCTION__ line:__LINE__ dictionary:dict]
#define LGVLogDictionaryI(dict) [[LGVRealTimeLogger sharedLogger] \
    logWithLevel:LGVLogLevelInfo function:__FUNCTION__ line:__LINE__ dictionary:dict]
#define LGVLogDictionaryW(dict) [[LGVRealTimeLogger sharedLogger] \
    logWithLevel:LGVLogLevelWarning function:__FUNCTION__ line:__LINE__ dictionary:dict]
#define LGVLogDictionaryE(dict) [[LGVRealTimeLogger sharedLogger] \
    logWithLevel:LGVLogLevelError function:__FUNCTION__ line:__LINE__ dictionary:dict]

NS_ASSUME_NONNULL_END
