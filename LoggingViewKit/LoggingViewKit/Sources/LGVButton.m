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

- (void)setTouchableExtension:(UIEdgeInsets)touchableExtension {
    self.touchableExtensionLeft = touchableExtension.left;
    self.touchableExtensionTop = touchableExtension.top;
    self.touchableExtensionRight = touchableExtension.right;
    self.touchableExtensionBottom = touchableExtension.bottom;
}

- (UIEdgeInsets)touchableExtension {
    return UIEdgeInsetsMake(self.touchableExtensionTop,
                            self.touchableExtensionLeft,
                            self.touchableExtensionBottom,
                            self.touchableExtensionRight);
}

- (CGRect)touchableBounds {
    CGRect rect = self.bounds;
    rect.origin.x -= self.touchableExtensionLeft;
    rect.origin.y -= self.touchableExtensionTop;
    rect.size.width += (self.touchableExtensionLeft + self.touchableExtensionRight);
    rect.size.height += (self.touchableExtensionTop + self.touchableExtensionBottom);

    return rect;
}

- (CGRect)touchableFrame {
    CGRect rect = self.frame;
    rect.origin.x -= self.touchableExtensionLeft;
    rect.origin.y -= self.touchableExtensionTop;
    rect.size.width += (self.touchableExtensionLeft + self.touchableExtensionRight);
    rect.size.height += (self.touchableExtensionTop + self.touchableExtensionBottom);

    return rect;
}

- (BOOL)pointInside:(CGPoint)point withEvent:(nullable UIEvent *)event {
    return CGRectContainsPoint(self.touchableBounds, point);
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [[LGVLoggingViewService sharedService] loggingView:self touchesEnded:touches withEvent:event];

    [super touchesEnded:touches withEvent:event];
}

@end
