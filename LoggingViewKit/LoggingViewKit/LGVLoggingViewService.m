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

#import <LoggingViewKit/LoggingViewKit-Swift.h>

#import "LGVLoggingViewService.h"

#import "LGVDatabase.h"
#import "LGVLog.h"
#import "LGVLogging.h"
#import "LGVLoggingAttribute.h"
#import "LGVRealTimeLogger.h"
#import "LGVSQLiteDatabase.h"

NSString *const LGVErrorDomain = @"jp.hituzi.LGVErrorDomain";

@implementation LGVError

+ (instancetype) errorWithMessage:(nullable NSString *)message {
    return [LGVError errorWithDomain:LGVErrorDomain code:1 userInfo:@{
                NSLocalizedFailureReasonErrorKey: message ? message : @""
            }];
}

@end

@interface LGVLoggingViewService ()

@property (nonatomic) BOOL isRecording;

@end

@implementation LGVLoggingViewService

static LGVLoggingViewService *_loggingViewService = nil;

+ (NSString *) versionString {
    return @"6.1.6-fmdb2.7.10";
}

+ (instancetype) sharedService {
    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{
        _loggingViewService = [LGVLoggingViewService new];
    });

    return _loggingViewService;
}

- (instancetype) init {
    if (self = [super init]) {
        _database = [LGVSQLiteDatabase defaultDatabase];
    }
    return self;
}

#pragma mark - public method

- (void) startRecording {
    self.isRecording = YES;
}

- (void) stopRecording {
    self.isRecording = NO;
}

- (NSArray<LGVLog *> *) allLogs {
    if ([self.database respondsToSelector:@selector(allLogs)]) {
        return [self.database allLogs];
    }
    else {
        return @[];
    }
}

- (NSArray<LGVLog *> *) logsByEventType:(NSString *)eventType {
    if ([self.database respondsToSelector:@selector(logsByEventType:)]) {
        return [self.database logsByEventType:eventType];
    }
    else {
        return @[];
    }
}

- (void) deleteAllLogs {
    if ([self.database respondsToSelector:@selector(deleteAllLogs)]) {
        [self.database deleteAllLogs];
    }
}

- (void) deleteLogsByEventType:(NSString *)eventType {
    if ([self.database respondsToSelector:@selector(deleteLogsByEventType:)]) {
        [self.database deleteLogsByEventType:eventType];
    }
}

- (void) click:(LGVLoggingAttribute *)attribute {
    [self click:attribute completionHandler:nil];
}

- (void) click:(LGVLoggingAttribute *)attribute completionHandler:(void (^ _Nullable)(void))completionHandler {
    [self              addLog:@"click"
                    attribute:attribute
     appendingMoreInfoHandler:^(LGVLog *log, LGVLoggingAttribute *attribute) {
#if TARGET_OS_IOS
         if (attribute.view) {
             UIView *view = attribute.view;
             NSSet<UITouch *> *touches = attribute.touches;

             if (touches) {
                 UITouch *touch = [touches anyObject];
                 CGPoint point = [touch locationInView:view.superview];

                 CGRect frame = view.frame;
                 if ([view respondsToSelector:@selector(touchableFrame)]) {
                     frame = ((id <LGVTouching>) view).touchableFrame;
                 }

                 if (!CGRectContainsPoint(frame, point)) {
                     // Clicked outside the view.
                     return;
                 }

                 CGPoint absolutePoint = [view.superview convertPoint:point toView:nil];

                 log.clickX = point.x;
                 log.clickY = point.y;
                 log.absoluteClickX = absolutePoint.x;
                 log.absoluteClickY = absolutePoint.y;
             }

             if ([view isKindOfClass:[UISegmentedControl class]]) {
                 // New value, because occurred at touchesEnded event.
                 log.info[@"newValue"] = @(((UISegmentedControl *) view).selectedSegmentIndex);
             }
             else if ([view isKindOfClass:[UISlider class]]) {
                 // Old value, because occurred at touchesBegan event.
                 log.info[@"oldValue"] = @(((UISlider *) view).value);
             }
             else if ([view isKindOfClass:[UIStepper class]]) {
                 log.info[@"newValue"] = @(((UIStepper *) view).value);
             }
             else if ([view isKindOfClass:[UISwitch class]]) {
                 log.info[@"oldValue"] = @(((UISwitch *) view).on);
             }
         }
#elif TARGET_OS_MAC
         if (attribute.view) {
             NSView *view = attribute.view;
             NSEvent *event = attribute.event;

             if (event) {
                 NSPoint point = [view convertPoint:event.locationInWindow fromView:nil];

                 CGRect frame = view.frame;
                 if ([view respondsToSelector:@selector(touchableFrame)]) {
                     frame = ((id <LGVTouching>) view).touchableFrame;
                 }

                 if (!CGRectContainsPoint(frame, point)) {
                     // Clicked outside the view.
                     return;
                 }

                 log.clickX = point.x;
                 log.clickY = point.y;
                 log.absoluteClickX = event.locationInWindow.x;
                 log.absoluteClickY = event.locationInWindow.y;
             }
         }
#endif
     }
            completionHandler:completionHandler];
}

- (void) customEvent:(NSString *)eventType attribute:(LGVLoggingAttribute *)attribute {
    [self customEvent:eventType attribute:attribute completionHandler:nil];
}

- (void)  customEvent:(NSString *)eventType
            attribute:(LGVLoggingAttribute *)attribute
    completionHandler:(void (^ _Nullable)(void))completionHandler {
    [self              addLog:eventType
                    attribute:attribute
     appendingMoreInfoHandler:nil
            completionHandler:completionHandler];
}

- (NSArray<LVKCounter *> *) allCounters {
    if (!self.isRecording) {
        return @[];
    }

    if ([self.database respondsToSelector:@selector(allCounters)]) {
        return [self.database allCounters];
    }
    else {
        return @[];
    }
}

- (LVKCounter *) counterWithName:(NSString *)name {
    if (!self.isRecording) {
        return nil;
    }

    LVKCounter *obj;

    if ([self.database respondsToSelector:@selector(counterByName:)]) {
        obj = [self.database counterByName:name];
    }

    if (obj) {
        return obj;
    }
    else {
        return [[LVKCounter alloc] initWithName:name database:self.database];
    }
}

#pragma mark - private method

- (void)              addLog:(NSString *)eventType
                   attribute:(LGVLoggingAttribute *)attribute
    appendingMoreInfoHandler:(void (^ _Nullable)(LGVLog *, LGVLoggingAttribute *))appendingMoreInfoHandler
           completionHandler:(void (^ _Nullable)(void))completionHandler {
    if (!self.isRecording || !attribute.loggingEnabled) {
        return;
    }

    dispatch_async(dispatch_get_main_queue(), ^{
        LGVLog *log = [LGVLog logWithEventType:eventType];
        log.name = attribute.name;

        if (appendingMoreInfoHandler) {
            appendingMoreInfoHandler(log, attribute);
        }

        if (attribute.info) {
            // Appends more information.
            [log.info setDictionary:attribute.info];
        }

        if ([self.delegate respondsToSelector:@selector(loggingViewService:willSaveLog:attribute:)]) {
            [self.delegate loggingViewService:self willSaveLog:log attribute:attribute];
        }

        LGVError *error = nil;

        if (![self.database addLog:log]) {
            error = [LGVError errorWithMessage:@"Failed to add a log into the database"];
        }

        LGVLog *savedLog = log;

        // Recreates the object with last inserted ID like the SQLite.
        if ([self.database respondsToSelector:@selector(logByKey:)]) {
            savedLog = [self.database logByKey:log.key];
        }

        if (error) {
            [self.logger logWithLevel:LGVLogLevelDebug
                             function:__FUNCTION__
                                 line:__LINE__
                               format:@"%@ %@", error.description, error.localizedFailureReason];
        }
        else {
            [self.logger logWithLevel:LGVLogLevelDebug
                             function:__FUNCTION__
                                 line:__LINE__
                               format:@"%@", savedLog];
        }

        if ([self.delegate respondsToSelector:@selector(loggingViewService:didSaveLog:attribute:error:)]) {
            [self.delegate loggingViewService:self
                                   didSaveLog:savedLog
                                    attribute:attribute
                                        error:error];
        }

        if (completionHandler) {
            completionHandler();
        }
    });
}

@end
