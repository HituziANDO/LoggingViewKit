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

#import "LGVRealTimeLogger.h"

NSString *LGVStringFromLGVLogLevel(LGVLogLevel logLevel) {
    switch (logLevel) {
        case LGVLogLevelDebug:
            return @"Debug";
        case LGVLogLevelInfo:
            return @"Info";
        case LGVLogLevelWarning:
            return @"Warning";
        case LGVLogLevelError:
            return @"Error";
        default:
            return @"";
    }
}

@implementation LGVXcodeConsoleDestination

+ (instancetype)destination {
    return [LGVXcodeConsoleDestination new];
}

#pragma mark - LGVDestination

- (void)write:(NSString *)log logLevel:(LGVLogLevel)logLevel {
    NSLog(@"\n%@\n", log);
}

@end

@interface LGVFileDestination ()

@property (nonatomic, copy) NSString *filePath;

@end

@implementation LGVFileDestination

+ (instancetype)destinationWithFile:(NSString *)fileName inDirectory:(NSString *)directory {
    if (![[NSFileManager defaultManager] fileExistsAtPath:directory]) {
        if (![[NSFileManager defaultManager] createDirectoryAtPath:directory
                                       withIntermediateDirectories:YES
                                                        attributes:nil
                                                             error:nil]) {

            @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                           reason:[NSString stringWithFormat:@"Failed to create a directory at %@",
                                                                             directory]
                                         userInfo:nil];
        }
    }

    return [self destinationWithFilePath:[directory stringByAppendingPathComponent:fileName]];
}

+ (instancetype)destinationWithFilePath:(NSString *)filePath {
    LGVFileDestination *destination = [LGVFileDestination new];
    destination.filePath = filePath;

    return destination;
}

#pragma mark - LGVDestination

- (void)write:(NSString *)log logLevel:(LGVLogLevel)logLevel {
    if ([[NSFileManager defaultManager] fileExistsAtPath:self.filePath]) {
        // Append
        NSFileHandle *fileHandle = [NSFileHandle fileHandleForWritingAtPath:self.filePath];
        [fileHandle seekToEndOfFile];
        [fileHandle writeData:[[NSString stringWithFormat:@",\n%@", log] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    else {
        // Create
        NSError *error = nil;

        if (![log writeToFile:self.filePath atomically:YES encoding:NSUTF8StringEncoding error:&error]) {
            LGVLogE(@"%@ failed to write a log. %@", NSStringFromClass([self class]), error.description);
        }
    }
}

@end

@implementation LGVJSONSerializer

#pragma mark - LGVSerializer

- (NSString *)serialize:(NSDictionary *)dictionary {
    if ([NSJSONSerialization isValidJSONObject:dictionary]) {
        NSData *data = [NSJSONSerialization dataWithJSONObject:dictionary
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:nil];
        return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    }

    return @"";
}

@end

@interface LGVRealTimeLogger ()

@property (nonatomic, copy) NSMutableArray<id <LGVDestination>> *dests;

@end

@implementation LGVRealTimeLogger

+ (instancetype)sharedLogger {
    static LGVRealTimeLogger *logger = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        logger = [LGVRealTimeLogger new];
    });

    return logger;
}

- (instancetype)init {
    self = [super init];

    if (self) {
        _logLevel = LGVLogLevelOff;
        _serializer = [LGVJSONSerializer new];
        _dests = [NSMutableArray new];
    }

    return self;
}

#pragma mark - property

- (NSArray<id <LGVDestination>> *)destinations {
    return [self.dests copy];
}

#pragma mark - public method

- (instancetype)addDestination:(id <LGVDestination>)destination {
    if (destination) {
        [self.dests addObject:destination];
    }

    return self;
}

- (void)logWithLevel:(LGVLogLevel)logLevel
            function:(const char *)function
                line:(NSUInteger)line
              format:(nullable NSString *)format, ... {

    NSString *message;

    if (format) {
        va_list args;
        va_start(args, format);
        message = [[NSString alloc] initWithFormat:format arguments:args];
        va_end(args);
    }

    [self logWithLevel:logLevel function:function line:line dictionary:@{
        @"message": message ? message : @"",
    }];
}

- (void)logWithLevel:(LGVLogLevel)logLevel
            function:(const char *)function
                line:(NSUInteger)line
               point:(CGPoint)point
             comment:(nullable NSString *)comment {

    [self logWithLevel:logLevel
              function:function
                  line:line
            dictionary:@{
                @"x": @(point.x),
                @"y": @(point.y),
                @"comment": comment ? comment : @"",
            }];
}

- (void)logWithLevel:(LGVLogLevel)logLevel
            function:(const char *)function
                line:(NSUInteger)line
                size:(CGSize)size
             comment:(nullable NSString *)comment {

    [self logWithLevel:logLevel
              function:function
                  line:line
            dictionary:@{
                @"width": @(size.width),
                @"height": @(size.height),
                @"comment": comment ? comment : @"",
            }];
}

- (void)logWithLevel:(LGVLogLevel)logLevel
            function:(const char *)function
                line:(NSUInteger)line
                rect:(CGRect)rect
             comment:(nullable NSString *)comment {

    [self logWithLevel:logLevel
              function:function
                  line:line
            dictionary:@{
                @"x": @(rect.origin.x),
                @"y": @(rect.origin.y),
                @"width": @(rect.size.width),
                @"height": @(rect.size.height),
                @"comment": comment ? comment : @"",
            }];
}

- (void)logWithLevel:(LGVLogLevel)logLevel
            function:(const char *)function
                line:(NSUInteger)line
          dictionary:(nullable NSDictionary *)dictionary {

    if (self.logLevel != LGVLogLevelOff && self.logLevel <= logLevel) {
        NSString *log = [self.serializer serialize:@{
            @"logLevel": LGVStringFromLGVLogLevel(logLevel),
            @"method": [NSString stringWithCString:function encoding:NSUTF8StringEncoding],
            @"line": @(line),
            @"isMainThread": @([NSThread currentThread].isMainThread),
            @"timestamp": [NSDate date].description,
            @"log": dictionary ? dictionary : @{},
        }];

        [self.dests enumerateObjectsUsingBlock:^(id <LGVDestination> destination, NSUInteger idx, BOOL *stop) {
            [destination write:log logLevel:logLevel];
        }];
    }
}

@end
