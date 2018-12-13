//
//  LGVButton.m
//  LoggingViewKit
//
//  Created by Masaki Ando on 2018/12/12.
//  Copyright (c) 2018 Hituzi Ando. All rights reserved.
//

#import "LGVButton.h"

#import "LGVLoggingViewService.h"

@implementation LGVButton

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [[LGVLoggingViewService sharedService] loggingView:self touchesEnded:touches withEvent:event];

    [super touchesEnded:touches withEvent:event];
}

@end
