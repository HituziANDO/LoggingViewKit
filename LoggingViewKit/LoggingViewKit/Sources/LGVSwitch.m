//
//  LGVSwitch.m
//  LoggingViewKit
//
//  Created by Masaki Ando on 2018/12/12.
//  Copyright (c) 2018 Hituzi Ando. All rights reserved.
//

#import "LGVSwitch.h"

#import "LGVLoggingViewService.h"

@implementation LGVSwitch

// Maybe UISwitch touchesEnded is not called.
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event {
    [super touchesBegan:touches withEvent:event];

    [[LGVLoggingViewService sharedService] loggingView:self touchesBegan:touches withEvent:event];
}

@end
