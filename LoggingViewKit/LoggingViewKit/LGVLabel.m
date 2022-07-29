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

#import "LGVLabel.h"

#import "LGVLoggingViewService.h"

@implementation LGVLabel

- (void)setLogging:(BOOL)logging {
    _logging = logging;

    // Enables the touched log of the receiver.
    self.userInteractionEnabled = logging;
}

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

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    return CGRectContainsPoint(self.touchableBounds, point);
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [[LGVLoggingViewService sharedService] click:self withTouches:touches event:event];

    [super touchesEnded:touches withEvent:event];
}

@end
