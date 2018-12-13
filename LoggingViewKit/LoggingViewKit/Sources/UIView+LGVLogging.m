//
//  UIView+LGVLogging.m
//  LoggingViewKit
//
//  Created by Masaki Ando on 2018/12/12.
//  Copyright (c) 2018 Hituzi Ando. All rights reserved.
//

#import <objc/runtime.h>

#import "UIView+LGVLogging.h"

#import "LGVLoggingViewService.h"

@implementation UIView (LGVLogging)

static void *LGVLoggingViewAssocKey_Name;
static void *LGVLoggingViewAssocKey_Logging;
static void *LGVLoggingViewAssocKey_TouchableInsetsLeft;
static void *LGVLoggingViewAssocKey_TouchableInsetsRight;
static void *LGVLoggingViewAssocKey_TouchableInsetsTop;
static void *LGVLoggingViewAssocKey_TouchableInsetsBottom;

- (void)lgv_setName:(NSString *)name {
    objc_setAssociatedObject(self, &LGVLoggingViewAssocKey_Name, name, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSString *)lgv_name {
    return objc_getAssociatedObject(self, &LGVLoggingViewAssocKey_Name);
}

- (void)lgv_setLogging:(BOOL)logging {
    objc_setAssociatedObject(self, &LGVLoggingViewAssocKey_Logging, @(logging), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)lgv_isLogging {
    NSNumber *isLogging = objc_getAssociatedObject(self, &LGVLoggingViewAssocKey_Logging);

    return [isLogging boolValue];
}

- (void)lgv_setTouchableInsets:(UIEdgeInsets)touchableInsets {
    objc_setAssociatedObject(self, &LGVLoggingViewAssocKey_TouchableInsetsLeft, @(touchableInsets.left), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &LGVLoggingViewAssocKey_TouchableInsetsRight, @(touchableInsets.right), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &LGVLoggingViewAssocKey_TouchableInsetsTop, @(touchableInsets.top), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &LGVLoggingViewAssocKey_TouchableInsetsBottom, @(touchableInsets.bottom), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIEdgeInsets)lgv_touchableInsets {
    NSNumber *left = objc_getAssociatedObject(self, &LGVLoggingViewAssocKey_TouchableInsetsLeft);
    NSNumber *right = objc_getAssociatedObject(self, &LGVLoggingViewAssocKey_TouchableInsetsRight);
    NSNumber *top = objc_getAssociatedObject(self, &LGVLoggingViewAssocKey_TouchableInsetsTop);
    NSNumber *bottom = objc_getAssociatedObject(self, &LGVLoggingViewAssocKey_TouchableInsetsBottom);

    return UIEdgeInsetsMake([top floatValue], [left floatValue], [bottom floatValue], [right floatValue]);
}

- (CGRect)lgv_touchableFrame {
    CGRect rect = self.frame;
    rect.origin.x += self.lgv_touchableInsets.left;
    rect.origin.y += self.lgv_touchableInsets.top;
    rect.size.width -= (self.lgv_touchableInsets.left + self.lgv_touchableInsets.right);
    rect.size.height -= (self.lgv_touchableInsets.top + self.lgv_touchableInsets.bottom);

    return rect;
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [[LGVLoggingViewService sharedService] loggingView:self touchesEnded:touches withEvent:event];

    [super touchesEnded:touches withEvent:event];
}

@end
