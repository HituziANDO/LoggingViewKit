//
//  UISwitch+LGVLogging.m
//  LoggingViewKit
//
//  Created by Masaki Ando on 2018/12/14.
//  Copyright (c) 2018 Hituzi Ando. All rights reserved.
//

#import "UISwitch+LGVLogging.h"

#import "LGVLoggingViewService.h"

@implementation UISwitch (LGVLogging)

// Maybe UISwitch touchesEnded is not called.
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event {
    [super touchesBegan:touches withEvent:event];

    [[LGVLoggingViewService sharedService] loggingView:self touchesBegan:touches withEvent:event];
}

@end
