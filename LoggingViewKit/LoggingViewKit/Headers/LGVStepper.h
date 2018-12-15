//
//  LGVStepper.h
//  LoggingViewKit
//
//  Created by Masaki Ando on 2018/12/12.
//  Copyright (c) 2018 Hituzi Ando. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "LGVLogging.h"

NS_ASSUME_NONNULL_BEGIN

@interface LGVStepper : UIStepper <LGVLogging>
/**
 * The name to identify the view.
 */
@property (nonatomic, copy, nullable) IBInspectable NSString *loggingName;
/**
 * True if logging is enabled, otherwise false.
 */
@property (nonatomic, getter=isLogging) IBInspectable BOOL logging;
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
