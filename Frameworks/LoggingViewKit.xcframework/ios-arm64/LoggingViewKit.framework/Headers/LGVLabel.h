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

#import <UIKit/UIKit.h>

#import "LGVLogging.h"

NS_ASSUME_NONNULL_BEGIN

@interface LGVLabel : UILabel <LGVLogging>
/**
 * The name to identify the view.
 */
@property (nonatomic, copy, nullable) IBInspectable NSString *loggingName;
/**
 * True if logging is enabled, otherwise false.
 */
@property (nonatomic, getter = isLogging) IBInspectable BOOL logging;
/**
 * Touchable extension left.
 */
@property (nonatomic) IBInspectable CGFloat touchableExtensionLeft;
/**
 * Touchable extension top.
 */
@property (nonatomic) IBInspectable CGFloat touchableExtensionTop;
/**
 * Touchable extension right.
 */
@property (nonatomic) IBInspectable CGFloat touchableExtensionRight;
/**
 * Touchable extension bottom.
 */
@property (nonatomic) IBInspectable CGFloat touchableExtensionBottom;
/**
 * Touchable extension.
 *
 * e.g.)
 * button.margin = UIEdgeInsetsMake(10.f, 10.f, 10.f, 10.f);
 */
@property (nonatomic) UIEdgeInsets touchableExtension;
/**
 * Touchable bounds.
 */
@property (nonatomic, readonly) CGRect touchableBounds;
/**
 * Touchable frame.
 */
@property (nonatomic, readonly) CGRect touchableFrame;

@end

NS_ASSUME_NONNULL_END
