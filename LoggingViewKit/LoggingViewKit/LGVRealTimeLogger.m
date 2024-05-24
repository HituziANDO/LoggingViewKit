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

NSString * LGVLogLevelToString(LGVLogLevel logLevel) {
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

+ (instancetype) destination {
    return [LGVXcodeConsoleDestination new];
}

#pragma mark - LGVDestination

- (void) write:(NSString *)log logLevel:(LGVLogLevel)logLevel {
    NSLog(@"\n%@\n", log);
}

@end

@interface LGVFileDestination ()

@property (nonatomic, copy) NSString *filePath;

@end

@implementation LGVFileDestination

+ (instancetype) destinationWithFile:(NSString *)fileName
                         inDirectory:(NSString *)directory {
    if (![[NSFileManager defaultManager] fileExistsAtPath:directory]) {
        if (![[NSFileManager defaultManager] createDirectoryAtPath:directory
                                       withIntermediateDirectories:YES
                                                        attributes:nil
                                                             error:nil]) {
            NSString *reason = [NSString stringWithFormat:@"Failed to create a directory at %@",
                                directory];
            @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                           reason:reason
                                         userInfo:nil];
        }
    }

    return [self destinationWithFilePath:[directory stringByAppendingPathComponent:fileName]];
}

+ (instancetype) destinationWithFilePath:(NSString *)filePath {
    LGVFileDestination *destination = [LGVFileDestination new];

    destination.filePath = filePath;

    return destination;
}

#pragma mark - LGVDestination

- (void) write:(NSString *)log logLevel:(LGVLogLevel)logLevel {
    if ([[NSFileManager defaultManager] fileExistsAtPath:self.filePath]) {
        // Append
        NSFileHandle *fileHandle = [NSFileHandle fileHandleForWritingAtPath:self.filePath];
        [fileHandle seekToEndOfFile];
        [fileHandle writeData:[[NSString stringWithFormat:@",\n%@", log]
                               dataUsingEncoding:NSUTF8StringEncoding]];
    }
    else {
        // Create
        NSError *error = nil;

        if (![log writeToFile:self.filePath
                   atomically:YES
                     encoding:NSUTF8StringEncoding
                        error:&error]) {
            NSLog(@"%@ failed to write a log. %@",
                  NSStringFromClass([self class]), error.description);
        }
    }
}

@end

@implementation LGVStringSerializer

- (NSString *) serialize:(NSDictionary *)dictionary {
    NSMutableArray<NSString *> *messages = [NSMutableArray new];

    if (dictionary[@"timestamp"]) {
        [messages addObject:dictionary[@"timestamp"]];
    }
    if (dictionary[@"identifier"]) {
        NSString *str = [NSString stringWithFormat:@"[%@]", dictionary[@"identifier"]];
        [messages addObject:str];
    }
    if (dictionary[@"logLevel"]) {
        NSString *str = [NSString stringWithFormat:@"[%@]", dictionary[@"logLevel"]];
        [messages addObject:str];
    }
    if (dictionary[@"method"] && dictionary[@"line"]) {
        NSString *str = [NSString stringWithFormat:@"%@:%@",
                         dictionary[@"method"], dictionary[@"line"]];
        [messages addObject:str];
    }
    if (dictionary[@"thread"]) {
        NSString *str = [NSString stringWithFormat:@"[%@]", dictionary[@"thread"]];
        [messages addObject:str];
    }
    if (dictionary[@"message"]) {
        [messages addObject:[NSString stringWithFormat:@"\n%@", dictionary[@"message"]]];
    }

    return [messages componentsJoinedByString:@" "];
}

@end

@implementation LGVJSONSerializer

- (NSString *) serialize:(NSDictionary *)dictionary {
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

@property (nonatomic) NSMutableArray<id <LGVDestination> > *destinations;

@end

@implementation LGVRealTimeLogger

+ (instancetype) sharedLogger {
    static LGVRealTimeLogger *logger = nil;
    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{
        logger = [[LGVRealTimeLogger alloc] initWithIdentifier:@"LoggingViewKit"];
    });

    return logger;
}

- (instancetype) initWithIdentifier:(NSString *)identifier {
    if (self = [super init]) {
        _identifier = identifier;
        _logLevel = LGVLogLevelDebug;
        _serializer = [LGVStringSerializer new];
        _destinations = [NSMutableArray new];
    }

    return self;
}

#pragma mark - public method

- (instancetype) addDestination:(id <LGVDestination>)destination {
    if (destination) {
        [self.destinations addObject:destination];
    }

    return self;
}

- (void) logWithLevel:(LGVLogLevel)logLevel format:(nullable NSString *)format, ... {
    if (self.logLevel == LGVLogLevelOff || self.logLevel > logLevel) {
        return;
    }

    NSString *message;
    if (format) {
        va_list args;
        va_start(args, format);
        message = [[NSString alloc] initWithFormat:format arguments:args];
        va_end(args);
    }

    NSString *log = [self.serializer serialize:@{
                         @"identifier": self.identifier,
                         @"logLevel": LGVLogLevelToString(logLevel),
                         @"timestamp": [[self dateFormatter] stringFromDate:[NSDate date]],
                         @"message": message ?: @"",
                     }];

    for (id <LGVDestination> dest in self.destinations) {
        [dest write:log logLevel:logLevel];
    }
}

- (void) logWithLevel:(LGVLogLevel)logLevel
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

    [self logWithLevel:logLevel function:function line:line message:message];
}

- (void) logWithLevel:(LGVLogLevel)logLevel
             function:(const char *)function
                 line:(NSUInteger)line
              message:(NSString *)message {
    if (self.logLevel == LGVLogLevelOff || self.logLevel > logLevel) {
        return;
    }

    NSString *threadName;
    if (NSThread.currentThread.isMainThread) {
        threadName = @"main";
    }
    else {
        threadName = NSThread.currentThread.name ?: @"";
    }

    NSString *log = [self.serializer serialize:@{
                         @"identifier": self.identifier,
                         @"logLevel": LGVLogLevelToString(logLevel),
                         @"method": [NSString stringWithCString:function encoding:NSUTF8StringEncoding],
                         @"line": @(line),
                         @"thread": threadName,
                         @"timestamp": [[self dateFormatter] stringFromDate:[NSDate date]],
                         @"message": message ?: @"",
                     }];

    for (id <LGVDestination> dest in self.destinations) {
        [dest write:log logLevel:logLevel];
    }
}

#pragma mark - private method

- (NSDateFormatter *) dateFormatter {
    NSDateFormatter *formatter = [NSDateFormatter new];

    formatter.locale = NSLocale.currentLocale;
    formatter.calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss.SSS";

    return formatter;
}

@end
