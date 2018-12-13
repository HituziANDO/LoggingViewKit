//
//  LGVLoggingViewService.m
//  LoggingViewKit
//
//  Created by Masaki Ando on 2018/12/12.
//  Copyright (c) 2018 Hituzi Ando. All rights reserved.
//

#import "LGVLoggingViewService.h"
#import "LoggingViewKit.h"

@implementation LGVLoggingViewService

static LGVLoggingViewService *_loggingViewService = nil;

+ (instancetype)sharedService {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _loggingViewService = [LGVLoggingViewService new];
    });

    return _loggingViewService;
}

- (void)loggingView:(UIView *)view touchesBegan:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event {
    [self loggingView:view touches:touches withEvent:event];
}

- (void)loggingView:(UIView *)view touchesEnded:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event {
    [self loggingView:view touches:touches withEvent:event];
}

- (void)loggingView:(UIView *)view touches:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:view.superview];

    if (view.lgv_isLogging && CGRectContainsPoint(view.lgv_touchableFrame, point)) {
        dispatch_async(dispatch_get_main_queue(), ^{
            CGPoint absolutePoint = [view.superview convertPoint:point toView:nil];
            NSMutableDictionary *info = @{
                @"clickX": @(point.x),
                @"clickY": @(point.y),
                @"absoluteClickX": @(absolutePoint.x),
                @"absoluteClickY": @(absolutePoint.y),
            }.mutableCopy;

            if ([view isKindOfClass:[UISegmentedControl class]]) {
                info[@"selectedSegmentIndex"] = @(((UISegmentedControl *) view).selectedSegmentIndex);
            }
            else if ([view isKindOfClass:[UISwitch class]]) {
                info[@"on"] = @(((UISwitch *) view).on);
            }

            if ([self.delegate respondsToSelector:@selector(saveLogOfView:withEvent:info:)]) {
                [self.delegate saveLogOfView:view withEvent:event info:info];
            }
        });
    }
}

@end
