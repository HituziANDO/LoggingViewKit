//
//  LGVLoggingViewService.m
//  LoggingViewKit
//
//  Created by Masaki Ando on 2018/12/12.
//  Copyright (c) 2018 Hituzi Ando. All rights reserved.
//

#import "LGVLoggingViewService.h"

#import "LGVDatabase.h"
#import "LGVLog.h"
#import "LGVLogging.h"
#import "LGVSQLiteDatabase.h"

NSString *const LGVErrorDomain = @"jp.hituzi.LoggingViewKit.Error";

@implementation LGVError

+ (instancetype)errorWithMessage:(nullable NSString *)message {
    return [LGVError errorWithDomain:LGVErrorDomain code:1 userInfo:@{
        @"message": message ? message : @""
    }];
}

@end

@interface LGVLoggingViewService ()

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

- (NSArray<LGVLog *> *)allLogs {
    return [self.defaultDatabase allLogs];
}

- (void)loggingView:(id <LGVLogging>)loggingView
       touchesBegan:(NSSet<UITouch *> *)touches
          withEvent:(nullable UIEvent *)event {

    [self loggingView:loggingView touches:touches withEvent:event];
}

- (void)loggingView:(id <LGVLogging>)loggingView
       touchesEnded:(NSSet<UITouch *> *)touches
          withEvent:(nullable UIEvent *)event {

    [self loggingView:loggingView touches:touches withEvent:event];
}

#pragma mark - private method

- (void)loggingView:(id <LGVLogging>)loggingView
            touches:(NSSet<UITouch *> *)touches
          withEvent:(nullable UIEvent *)event {

    UITouch *touch = [touches anyObject];

    if (![loggingView isKindOfClass:[UIView class]]) {
        return;
    }

    UIView *view = (UIView *) loggingView;
    CGPoint point = [touch locationInView:view.superview];

    if (loggingView.isLogging && CGRectContainsPoint(loggingView.touchableFrame, point)) {
        dispatch_async(dispatch_get_main_queue(), ^{
            CGPoint absolutePoint = [view.superview convertPoint:point toView:nil];

            LGVLog *log = [LGVLog log];
            log.name = loggingView.loggingName;
            log.clickX = point.x;
            log.clickY = point.y;
            log.absoluteClickX = absolutePoint.x;
            log.absoluteClickY = absolutePoint.y;

            NSMutableDictionary *info = @{
                @"clickX": @(point.x),
                @"clickY": @(point.y),
                @"absoluteClickX": @(absolutePoint.x),
                @"absoluteClickY": @(absolutePoint.y),
            }.mutableCopy;

            if ([view isKindOfClass:[UISegmentedControl class]]) {
                // New value, because occurred at touchesEnded event.
                log.info[@"newValue"] = @(((UISegmentedControl *) view).selectedSegmentIndex);
                info[@"newValue"] = @(((UISegmentedControl *) view).selectedSegmentIndex);
            }
            else if ([view isKindOfClass:[UISlider class]]) {
                // Old value, because occurred at touchesBegan event.
                log.info[@"oldValue"] = @(((UISlider *) view).value);
                info[@"oldValue"] = @(((UISlider *) view).value);
            }
            else if ([view isKindOfClass:[UIStepper class]]) {
                log.info[@"newValue"] = @(((UIStepper *) view).value);
                info[@"newValue"] = @(((UIStepper *) view).value);
            }
            else if ([view isKindOfClass:[UISwitch class]]) {
                log.info[@"oldValue"] = @(((UISwitch *) view).on);
                info[@"oldValue"] = @(((UISwitch *) view).on);
            }

            if ([self.delegate respondsToSelector:@selector(loggingViewService:willSaveLog:ofView:withEvent:)]) {
                [self.delegate loggingViewService:self willSaveLog:log ofView:loggingView withEvent:event];
            }

            LGVError *error = nil;

            if (![self.defaultDatabase addLog:log]) {
                error = [LGVError errorWithMessage:@"Failed to add the log into the database"];
            }

            LGVLog *savedLog = [self.defaultDatabase logByKey:log.key];

            if ([self.delegate respondsToSelector:@selector(loggingViewService:didSaveLog:ofView:withEvent:error:)]) {
                [self.delegate loggingViewService:self didSaveLog:savedLog ofView:loggingView withEvent:event error:error];
            }
        });
    }
}

- (id <LGVDatabase>)defaultDatabase {
    if (!self.database) {
        self.database = [LGVSQLiteDatabase defaultDatabase];
    }

    return self.database;
}

@end
