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

#import "LGVLoggingViewService.h"

#import "LGVDatabase.h"
#import "LGVLog.h"
#import "LGVLogging.h"
#import "LGVRealTimeLogger.h"
#import "LGVSQLiteDatabase.h"

NSString *const LGVErrorDomain = @"jp.hituzi.LGVErrorDomain";

@implementation LGVError

+ (instancetype)errorWithMessage:(nullable NSString *)message {
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

+ (instancetype)sharedService {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _loggingViewService = [LGVLoggingViewService new];
    });

    return _loggingViewService;
}

#pragma mark - public method

- (void)startRecording {
    self.isRecording = YES;
}

- (void)stopRecording {
    self.isRecording = NO;
}

- (NSArray<LGVLog *> *)allLogs {
    if ([self.defaultDatabase respondsToSelector:@selector(allLogs)]) {
        return [self.defaultDatabase allLogs];
    }
    else {
        return @[];
    }
}

- (void)deleteAllLogs {
    if ([self.defaultDatabase respondsToSelector:@selector(deleteAllLogs)]) {
        [self.defaultDatabase deleteAllLogs];
    }
}

- (void)click:(id <LGVLogging>)loggingView {
    [self click:loggingView withTouches:nil event:nil];
}

- (void)click:(id <LGVLogging>)loggingView
  withTouches:(NSSet<UITouch *> *)touches
        event:(UIEvent *)event {
    if (!self.isRecording || !loggingView.isLogging) {
        return;
    }

    if (![loggingView isKindOfClass:[UIView class]]) {
        return;
    }

    dispatch_async(dispatch_get_main_queue(), ^{
        UIView *view = (UIView *) loggingView;

        LGVLog *log = [LGVLog log];
        log.name = loggingView.loggingName;

        if (touches) {
            UITouch *touch = [touches anyObject];
            CGPoint point = [touch locationInView:view.superview];

            if (!CGRectContainsPoint(loggingView.touchableFrame, point)) {
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

        if ([self.delegate respondsToSelector:@selector(loggingViewService:willSaveLog:ofView:withEvent:)]) {
            [self.delegate loggingViewService:self
                                  willSaveLog:log
                                       ofView:loggingView
                                    withEvent:event];
        }

        LGVError *error = nil;

        if (![self.defaultDatabase addLog:log]) {
            error = [LGVError errorWithMessage:@"Failed to add a log into the database"];
        }

        LGVLog *savedLog = log;

        // Recreates the object with last inserted ID like the SQLite.
        if ([self.defaultDatabase respondsToSelector:@selector(logByKey:)]) {
            savedLog = [self.defaultDatabase logByKey:log.key];
        }

        if (error) {
            LGVLogD(@"%@ %@", error.description, error.localizedFailureReason);
        }
        else {
            LGVLogDictionaryD(savedLog.toDictionary);
        }

        if (self.isOutputToConsoleInRealTime) {
            NSLog(@"[%@] %@", NSStringFromClass([self class]), error ? error.description : savedLog.description);
        }

        if ([self.delegate respondsToSelector:@selector(loggingViewService:didSaveLog:ofView:withEvent:error:)]) {
            [self.delegate loggingViewService:self
                                   didSaveLog:savedLog
                                       ofView:loggingView
                                    withEvent:event
                                        error:error];
        }
    });
}

#pragma mark - private method

- (id <LGVDatabase>)defaultDatabase {
    if (!self.database) {
        self.database = [LGVSQLiteDatabase defaultDatabase];
    }

    return self.database;
}

@end
