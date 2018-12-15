//
//  LGVLoggingViewService.m
//  LoggingViewKit
//
//  Created by Masaki Ando on 2018/12/12.
//  Copyright (c) 2018 Hituzi Ando. All rights reserved.
//

#import "LGVLoggingViewService.h"

#import "LGVLogging.h"

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
            NSMutableDictionary *info = @{
                @"clickX": @(point.x),
                @"clickY": @(point.y),
                @"absoluteClickX": @(absolutePoint.x),
                @"absoluteClickY": @(absolutePoint.y),
            }.mutableCopy;

            if ([view isKindOfClass:[UISegmentedControl class]]) {
                // New value, because occurred at touchesEnded event.
                info[@"newValue"] = @(((UISegmentedControl *) view).selectedSegmentIndex);
            }
            else if ([view isKindOfClass:[UIStepper class]]) {
                info[@"newValue"] = @(((UIStepper *) view).value);
            }
            else if ([view isKindOfClass:[UISwitch class]]) {
                // Old value, because occurred at touchesBegan event.
                info[@"oldValue"] = @(((UISwitch *) view).on);
            }

            if ([self.delegate respondsToSelector:@selector(loggingViewService:saveLogOfView:withEvent:info:)]) {
                [self.delegate loggingViewService:self saveLogOfView:loggingView withEvent:event info:info];
            }
        });
    }
}

@end
