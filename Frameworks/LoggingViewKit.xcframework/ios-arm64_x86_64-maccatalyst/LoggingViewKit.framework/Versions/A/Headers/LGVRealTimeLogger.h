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
 * @param log A log.
 * @param logLevel A log level.
 */
- (void) write:(NSString *)log logLevel:(LGVLogLevel)logLevel;

@end

@interface LGVXcodeConsoleDestination : NSObject <LGVDestination>
/**
 * Creates new instance that it outputs a log to Xcode console.
 *
 * @return A destination.
 */
+ (instancetype) destination;

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
 * @param directory A directory path. If the directory doesn't exist,
 * it is created by the receiver.
 * @return A destination.
 */
+ (instancetype) destinationWithFile:(NSString *)fileName
                         inDirectory:(NSString *)directory;
/**
 * Creates new instance that it outputs a log to given file.
 *
 * @param filePath A file path.
 * @return A destination.
 */
+ (instancetype) destinationWithFilePath:(NSString *)filePath;

@end

@protocol LGVSerializer <NSObject>
/**
 * Serializes a log data as `NSString`.
 *
 * @param dictionary A log data.
 * @return Serialized log as `NSString`.
 */
- (NSString *) serialize:(NSDictionary *)dictionary;

@end

@interface LGVStringSerializer : NSObject <LGVSerializer>

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
 * Returns the singleton instance.
 *
 * @return The singleton instance.
 */
+ (instancetype) sharedLogger;

/**
 * Adds a destination outputting logs to the logger.
 *
 * @param destination A destination outputting logs.
 * @return The receiver.
 */
- (instancetype) addDestination:(id <LGVDestination>)destination;
/**
 * Adds a log.
 *
 * @param logLevel The log level.
 * @param format A message using a format.
 */
- (void) logWithLevel:(LGVLogLevel)logLevel format:(nullable NSString *)format, ...;
/**
 * Adds a log.
 *
 * @param logLevel The log level.
 * @param function Set `__FUNCTION__`.
 * @param line Set `__LINE__`.
 * @param format A message using a format.
 */
- (void) logWithLevel:(LGVLogLevel)logLevel
             function:(const char *)function
                 line:(NSUInteger)line
               format:(nullable NSString *)format, ...;

@end

#define LGVLogD(...) [[LGVRealTimeLogger sharedLogger] \
                      logWithLevel:LGVLogLevelDebug function:__FUNCTION__ line:__LINE__ format:__VA_ARGS__]
#define LGVLogI(...) [[LGVRealTimeLogger sharedLogger] \
                      logWithLevel:LGVLogLevelInfo function:__FUNCTION__ line:__LINE__ format:__VA_ARGS__]
#define LGVLogW(...) [[LGVRealTimeLogger sharedLogger] \
                      logWithLevel:LGVLogLevelWarning function:__FUNCTION__ line:__LINE__ format:__VA_ARGS__]
#define LGVLogE(...) [[LGVRealTimeLogger sharedLogger] \
                      logWithLevel:LGVLogLevelError function:__FUNCTION__ line:__LINE__ format:__VA_ARGS__]

NS_ASSUME_NONNULL_END
